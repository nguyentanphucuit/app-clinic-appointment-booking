import 'package:flutter/cupertino.dart';
import '../models/doctor.dart';
import '../services/firestore_service.dart';

class DoctorProvider with ChangeNotifier {
  List<Doctor> _doctors = [];
  String _searchQuery = '';
  String _selectedSpecialty = 'Tất cả';
  final FirestoreService _firestore = FirestoreService.instance;

  List<Doctor> get doctors => _doctors;
  String get searchQuery => _searchQuery;
  String get selectedSpecialty => _selectedSpecialty;

  List<Doctor> get filteredDoctors {
    var filtered = _doctors;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((doctor) {
        return doctor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            doctor.specialty.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            doctor.hospital.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Filter by specialty
    if (_selectedSpecialty != 'Tất cả') {
      filtered = filtered.where((doctor) {
        return doctor.specialty == _selectedSpecialty;
      }).toList();
    }

    return filtered;
  }

  List<Doctor> get favoriteDoctors {
    return _doctors.where((doctor) => doctor.isFavorite).toList();
  }

  List<Doctor> get topRatedDoctors {
    var sorted = List<Doctor>.from(_doctors);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(5).toList();
  }

  DoctorProvider() {
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    _doctors = await _firestore.getAllDoctors();
    if (_doctors.isEmpty) {
      await _loadSampleDoctors();
    }
    notifyListeners();
  }

  Future<void> _loadSampleDoctors() async {
    _doctors = [
      Doctor(
        id: '1',
        name: 'BS. Nguyễn Thị Hương',
        specialty: 'Tim mạch',
        avatar: 'https://i.pravatar.cc/150?img=47',
        rating: 4.9,
        reviewCount: 284,
        experience: 15,
        hospital: 'City Medical Center',
        about:
            'Experienced cardiologist specializing in heart disease prevention and treatment. Board certified with extensive experience in cardiac care.',
        availableDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        startTime: '09:00',
        endTime: '17:00',
        consultationFee: 500000,
        isFavorite: true,
      ),
      Doctor(
        id: '2',
        name: 'BS. Trần Văn Minh',
        specialty: 'Da liễu',
        avatar: 'https://i.pravatar.cc/150?img=33',
        rating: 4.8,
        reviewCount: 196,
        experience: 12,
        hospital: 'Skin & Beauty Clinic',
        about:
            'Expert dermatologist focused on skin health, acne treatment, and cosmetic dermatology procedures.',
        availableDays: ['Mon', 'Wed', 'Fri', 'Sat'],
        startTime: '10:00',
        endTime: '18:00',
        consultationFee: 400000,
      ),
      Doctor(
        id: '3',
        name: 'BS. Lê Thị Mai',
        specialty: 'Nhi khoa',
        avatar: 'https://i.pravatar.cc/150?img=45',
        rating: 4.9,
        reviewCount: 342,
        experience: 18,
        hospital: 'Children\'s Hospital',
        about:
            'Compassionate pediatrician dedicated to providing comprehensive care for infants, children, and adolescents.',
        availableDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        startTime: '08:00',
        endTime: '16:00',
        consultationFee: 350000,
        isFavorite: true,
      ),
      Doctor(
        id: '4',
        name: 'BS. Phạm Đức Anh',
        specialty: 'Chỉnh hình',
        avatar: 'https://i.pravatar.cc/150?img=15',
        rating: 4.7,
        reviewCount: 158,
        experience: 20,
        hospital: 'Sports Medicine Institute',
        about:
            'Orthopedic surgeon specializing in sports injuries, joint replacement, and musculoskeletal disorders.',
        availableDays: ['Tue', 'Thu', 'Fri', 'Sat'],
        startTime: '09:00',
        endTime: '17:00',
        consultationFee: 600000,
      ),
      Doctor(
        id: '5',
        name: 'BS. Hoàng Thị Lan',
        specialty: 'Thần kinh',
        avatar: 'https://i.pravatar.cc/150?img=48',
        rating: 4.8,
        reviewCount: 213,
        experience: 14,
        hospital: 'Brain & Spine Center',
        about:
            'Neurologist with expertise in treating headaches, epilepsy, stroke, and neurodegenerative diseases.',
        availableDays: ['Mon', 'Wed', 'Thu', 'Fri'],
        startTime: '09:00',
        endTime: '16:00',
        consultationFee: 550000,
      ),
      Doctor(
        id: '6',
        name: 'BS. Vũ Văn Hùng',
        specialty: 'Tổng quát',
        avatar: 'https://i.pravatar.cc/150?img=13',
        rating: 4.6,
        reviewCount: 428,
        experience: 22,
        hospital: 'Community Health Clinic',
        about:
            'General practitioner providing comprehensive primary care services for patients of all ages.',
        availableDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        startTime: '08:00',
        endTime: '20:00',
        consultationFee: 250000,
      ),
      Doctor(
        id: '7',
        name: 'BS. Đỗ Thị Hoa',
        specialty: 'Tâm thần',
        avatar: 'https://i.pravatar.cc/150?img=44',
        rating: 4.9,
        reviewCount: 167,
        experience: 16,
        hospital: 'Mental Wellness Center',
        about:
            'Board-certified psychiatrist specializing in anxiety, depression, and mental health counseling.',
        availableDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
        startTime: '10:00',
        endTime: '18:00',
        consultationFee: 450000,
        isFavorite: true,
      ),
      Doctor(
        id: '8',
        name: 'BS. Nguyễn Văn Tuấn',
        specialty: 'Nha khoa',
        avatar: 'https://i.pravatar.cc/150?img=52',
        rating: 4.7,
        reviewCount: 295,
        experience: 11,
        hospital: 'Smile Dental Clinic',
        about:
            'Experienced dentist offering general dentistry, cosmetic procedures, and oral health care.',
        availableDays: ['Mon', 'Tue', 'Thu', 'Fri', 'Sat'],
        startTime: '09:00',
        endTime: '17:00',
        consultationFee: 300000,
      ),
    ];

    // Insert all doctors into Firestore
    for (final doctor in _doctors) {
      await _firestore.createDoctor(doctor);
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedSpecialty(String specialty) {
    _selectedSpecialty = specialty;
    notifyListeners();
  }

  Future<void> toggleFavorite(String doctorId) async {
    final index = _doctors.indexWhere((d) => d.id == doctorId);
    if (index != -1) {
      final newFavoriteStatus = !_doctors[index].isFavorite;
      await _firestore.toggleDoctorFavorite(doctorId, newFavoriteStatus);
      _doctors[index] = _doctors[index].copyWith(
        isFavorite: newFavoriteStatus,
      );
      notifyListeners();
    }
  }

  Future<Doctor?> getDoctorById(String id) async {
    try {
      return _doctors.firstWhere((doctor) => doctor.id == id);
    } catch (e) {
      return await _firestore.getDoctor(id);
    }
  }

  List<String> get allSpecialties {
    final specialties = _doctors.map((d) => d.specialty).toSet().toList();
    specialties.sort();
    return ['Tất cả', ...specialties];
  }
}
