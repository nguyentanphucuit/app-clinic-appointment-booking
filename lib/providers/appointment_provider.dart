import 'package:flutter/foundation.dart';
import '../models/appointment.dart';
import '../models/doctor.dart';
import '../services/firestore_service.dart';
import '../providers/user_provider.dart';

class AppointmentProvider with ChangeNotifier {
  List<Appointment> _appointments = [];
  String _filterStatus = 'Tất cả';
  final FirestoreService _firestore = FirestoreService.instance;
  UserProvider? _userProvider;

  List<Appointment> get appointments => _appointments;
  String get filterStatus => _filterStatus;

  List<Appointment> get filteredAppointments {
    if (_filterStatus == 'Tất cả') {
      return _appointments;
    } else if (_filterStatus == 'Sắp tới') {
      return _appointments
          .where((a) => a.status == AppointmentStatus.upcoming)
          .toList();
    } else if (_filterStatus == 'Hoàn thành') {
      return _appointments
          .where((a) => a.status == AppointmentStatus.completed)
          .toList();
    } else if (_filterStatus == 'Đã hủy') {
      return _appointments
          .where((a) => a.status == AppointmentStatus.cancelled)
          .toList();
    }
    return _appointments;
  }

  List<Appointment> get upcomingAppointments {
    return _appointments
        .where((a) => a.status == AppointmentStatus.upcoming && a.isUpcoming)
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<Appointment> get todayAppointments {
    return _appointments
        .where((a) => a.isToday && a.status == AppointmentStatus.upcoming)
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<Appointment> get pastAppointments {
    return _appointments
        .where((a) => a.isPast || a.status == AppointmentStatus.completed)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  int get upcomingCount {
    return _appointments
        .where((a) => a.status == AppointmentStatus.upcoming)
        .length;
  }

  int get completedCount {
    return _appointments
        .where((a) => a.status == AppointmentStatus.completed)
        .length;
  }

  int get cancelledCount {
    return _appointments
        .where((a) => a.status == AppointmentStatus.cancelled)
        .length;
  }

  void setUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  void clearAppointments() {
    _appointments = [];
    notifyListeners();
  }

  Future<void> loadAppointments() async {
    try {
      final userId = _userProvider?.currentUser?.id;
      if (userId != null) {
        // Load appointments của user hiện tại
        _appointments = await _firestore.getUserAppointments(userId);
      } else {
        // Fallback: load tất cả nếu chưa có user
        _appointments = await _firestore.getAllAppointments();
      }
      notifyListeners();
    } catch (e) {
      // Nếu có lỗi (ví dụ: chưa có index trong Firestore), set empty list
      _appointments = [];
      notifyListeners();
      rethrow; // Re-throw để caller biết có lỗi
    }
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  Future<void> addAppointment(Appointment appointment) async {
    final userId = _userProvider?.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }
    await _firestore.createAppointment(appointment, userId);
    _appointments.add(appointment);
    notifyListeners();
  }

  Future<void> updateAppointment(String id, Appointment appointment) async {
    await _firestore.updateAppointment(appointment);
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index] = appointment;
      notifyListeners();
    }
  }

  Future<void> cancelAppointment(String id) async {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      final updatedAppointment = _appointments[index].copyWith(
        status: AppointmentStatus.cancelled,
      );
      await _firestore.updateAppointment(updatedAppointment);
      _appointments[index] = updatedAppointment;
      notifyListeners();
    }
  }

  Future<void> completeAppointment(String id, {String? notes, String? prescription}) async {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      final updatedAppointment = _appointments[index].copyWith(
        status: AppointmentStatus.completed,
        notes: notes,
        prescription: prescription,
      );
      await _firestore.updateAppointment(updatedAppointment);
      _appointments[index] = updatedAppointment;
      notifyListeners();
    }
  }

  Future<void> loadSampleAppointments(List<Doctor> doctors) async {
    if (doctors.isEmpty) return;
    
    final userId = _userProvider?.currentUser?.id;
    if (userId == null) return;

    final sampleAppointments = [
      Appointment(
        id: '1',
        doctor: doctors[0], // Dr. Sarah Johnson - Cardiology
        dateTime: DateTime.now().add(const Duration(days: 2, hours: 10)),
        duration: '30 min',
        reason: 'Regular heart checkup',
        status: AppointmentStatus.upcoming,
      ),
      Appointment(
        id: '2',
        doctor: doctors[2], // Dr. Emily Rodriguez - Pediatrics
        dateTime: DateTime.now().add(const Duration(hours: 3)),
        duration: '20 min',
        reason: 'Child vaccination',
        status: AppointmentStatus.upcoming,
      ),
      Appointment(
        id: '3',
        doctor: doctors[1], // Dr. Michael Chen - Dermatology
        dateTime: DateTime.now().subtract(const Duration(days: 5)),
        duration: '25 min',
        reason: 'Skin consultation',
        status: AppointmentStatus.completed,
        notes: 'Prescribed topical cream for acne treatment',
        prescription: 'Tretinoin 0.025% cream - Apply once daily',
      ),
      Appointment(
        id: '4',
        doctor: doctors[6], // Dr. Maria Garcia - Psychiatry
        dateTime: DateTime.now().add(const Duration(days: 7, hours: 14)),
        duration: '45 min',
        reason: 'Mental health consultation',
        status: AppointmentStatus.upcoming,
      ),
      Appointment(
        id: '5',
        doctor: doctors[5], // Dr. James Wilson - General Practice
        dateTime: DateTime.now().subtract(const Duration(days: 15)),
        duration: '15 min',
        reason: 'Annual physical exam',
        status: AppointmentStatus.completed,
        notes: 'All vitals normal. Continue current lifestyle',
      ),
      Appointment(
        id: '6',
        doctor: doctors[3], // Dr. David Thompson - Orthopedics
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        duration: '30 min',
        reason: 'Knee pain evaluation',
        status: AppointmentStatus.cancelled,
      ),
      Appointment(
        id: '7',
        doctor: doctors[7], // Dr. Robert Lee - Dentistry
        dateTime: DateTime.now().add(const Duration(days: 14, hours: 9)),
        duration: '30 min',
        reason: 'Dental cleaning',
        status: AppointmentStatus.upcoming,
      ),
    ];

    // Insert all appointments into Firestore
    for (final appointment in sampleAppointments) {
      await _firestore.createAppointment(appointment, userId);
    }
    _appointments = sampleAppointments;
    notifyListeners();
  }
}
