import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';

class FirestoreService {
  static final FirestoreService instance = FirestoreService._init();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreService._init();

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _doctorsCollection => _firestore.collection('doctors');
  CollectionReference get _appointmentsCollection => _firestore.collection('appointments');

  // User operations
  Future<void> createUser(User user) async {
    await _usersCollection.doc(user.id).set({
      'name': user.name,
      'email': user.email,
      'password': user.password,
      'phone': user.phone,
      'avatar': user.avatar,
      'dateOfBirth': Timestamp.fromDate(user.dateOfBirth),
      'gender': user.gender,
      'bloodType': user.bloodType,
      'address': user.address,
      'medicalHistory': user.medicalHistory,
    });
  }

  Future<User?> getUser(String id) async {
    final doc = await _usersCollection.doc(id).get();
    if (!doc.exists) return null;
    return _userFromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<User?> getCurrentUser() async {
    final snapshot = await _usersCollection.limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return _userFromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<User?> getUserByEmail(String email) async {
    final snapshot = await _usersCollection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return _userFromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<void> updateUser(User user) async {
    final doc = await _usersCollection.doc(user.id).get();
    final currentData = doc.data() as Map<String, dynamic>?;
    
    final updateData = <String, dynamic>{
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'avatar': user.avatar,
      'dateOfBirth': Timestamp.fromDate(user.dateOfBirth),
      'gender': user.gender,
      'bloodType': user.bloodType,
      'address': user.address,
      'medicalHistory': user.medicalHistory,
    };
    
    // Giữ nguyên password nếu không được cập nhật
    if (currentData != null && currentData.containsKey('password')) {
      updateData['password'] = currentData['password'];
    } else {
      updateData['password'] = user.password;
    }
    
    await _usersCollection.doc(user.id).update(updateData);
  }

  User _userFromMap(String id, Map<String, dynamic> data) {
    return User(
      id: id,
      name: data['name'] as String,
      email: data['email'] as String,
      password: data['password'] as String? ?? '', // Default empty nếu không có
      phone: data['phone'] as String,
      avatar: data['avatar'] as String,
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
      gender: data['gender'] as String,
      bloodType: data['bloodType'] as String,
      address: data['address'] as String,
      medicalHistory: List<String>.from(data['medicalHistory'] ?? []),
    );
  }

  // Doctor operations
  Future<void> createDoctor(Doctor doctor) async {
    await _doctorsCollection.doc(doctor.id).set({
      'name': doctor.name,
      'specialty': doctor.specialty,
      'avatar': doctor.avatar,
      'rating': doctor.rating,
      'reviewCount': doctor.reviewCount,
      'experience': doctor.experience,
      'hospital': doctor.hospital,
      'about': doctor.about,
      'availableDays': doctor.availableDays,
      'startTime': doctor.startTime,
      'endTime': doctor.endTime,
      'consultationFee': doctor.consultationFee,
      'isFavorite': doctor.isFavorite,
    });
  }

  Future<List<Doctor>> getAllDoctors() async {
    final snapshot = await _doctorsCollection.get();
    return snapshot.docs
        .map((doc) => _doctorFromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Doctor?> getDoctor(String id) async {
    final doc = await _doctorsCollection.doc(id).get();
    if (!doc.exists) return null;
    return _doctorFromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<void> updateDoctor(Doctor doctor) async {
    await _doctorsCollection.doc(doctor.id).update({
      'name': doctor.name,
      'specialty': doctor.specialty,
      'avatar': doctor.avatar,
      'rating': doctor.rating,
      'reviewCount': doctor.reviewCount,
      'experience': doctor.experience,
      'hospital': doctor.hospital,
      'about': doctor.about,
      'availableDays': doctor.availableDays,
      'startTime': doctor.startTime,
      'endTime': doctor.endTime,
      'consultationFee': doctor.consultationFee,
      'isFavorite': doctor.isFavorite,
    });
  }

  Future<void> toggleDoctorFavorite(String doctorId, bool isFavorite) async {
    await _doctorsCollection.doc(doctorId).update({
      'isFavorite': isFavorite,
    });
  }

  Doctor _doctorFromMap(String id, Map<String, dynamic> data) {
    return Doctor(
      id: id,
      name: data['name'] as String,
      specialty: data['specialty'] as String,
      avatar: data['avatar'] as String,
      rating: (data['rating'] as num).toDouble(),
      reviewCount: data['reviewCount'] as int,
      experience: data['experience'] as int,
      hospital: data['hospital'] as String,
      about: data['about'] as String,
      availableDays: List<String>.from(data['availableDays']),
      startTime: data['startTime'] as String,
      endTime: data['endTime'] as String,
      consultationFee: (data['consultationFee'] as num).toDouble(),
      isFavorite: data['isFavorite'] as bool? ?? false,
    );
  }

  // Appointment operations
  Future<void> createAppointment(Appointment appointment, String userId) async {
    await _appointmentsCollection.doc(appointment.id).set({
      'userId': userId,
      'doctorId': appointment.doctor.id,
      'dateTime': Timestamp.fromDate(appointment.dateTime),
      'duration': appointment.duration,
      'reason': appointment.reason,
      'status': appointment.status.name,
      'notes': appointment.notes,
      'prescription': appointment.prescription,
    });
  }

  Future<List<Appointment>> getAllAppointments() async {
    final snapshot = await _appointmentsCollection
        .orderBy('dateTime', descending: true)
        .get();

    final appointments = <Appointment>[];
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final doctor = await getDoctor(data['doctorId'] as String);
      if (doctor != null) {
        appointments.add(_appointmentFromMap(doc.id, data, doctor));
      }
    }
    return appointments;
  }

  Future<List<Appointment>> getUserAppointments(String userId) async {
    try {
      // Thử query với orderBy trước
      final snapshot = await _appointmentsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('dateTime', descending: true)
          .get();

      final appointments = <Appointment>[];
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final doctor = await getDoctor(data['doctorId'] as String);
        if (doctor != null) {
          appointments.add(_appointmentFromMap(doc.id, data, doctor));
        }
      }
      return appointments;
    } catch (e) {
      // Nếu lỗi do thiếu index, thử query không orderBy
      try {
        final snapshot = await _appointmentsCollection
            .where('userId', isEqualTo: userId)
            .get();

        final appointments = <Appointment>[];
        for (final doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final doctor = await getDoctor(data['doctorId'] as String);
          if (doctor != null) {
            appointments.add(_appointmentFromMap(doc.id, data, doctor));
          }
        }
        // Sort manually
        appointments.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        return appointments;
      } catch (e2) {
        // Nếu vẫn lỗi, trả về empty list
        print('Error loading user appointments: $e2');
        return [];
      }
    }
  }

  Future<Appointment?> getAppointment(String id) async {
    final doc = await _appointmentsCollection.doc(id).get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    final doctor = await getDoctor(data['doctorId'] as String);
    if (doctor == null) return null;
    return _appointmentFromMap(doc.id, data, doctor);
  }

  Future<void> updateAppointment(Appointment appointment) async {
    final doc = await _appointmentsCollection.doc(appointment.id).get();
    final currentData = doc.data() as Map<String, dynamic>?;
    
    await _appointmentsCollection.doc(appointment.id).update({
      'doctorId': appointment.doctor.id,
      'dateTime': Timestamp.fromDate(appointment.dateTime),
      'duration': appointment.duration,
      'reason': appointment.reason,
      'status': appointment.status.name,
      'notes': appointment.notes,
      'prescription': appointment.prescription,
      // Giữ nguyên userId nếu có
      if (currentData != null && currentData.containsKey('userId'))
        'userId': currentData['userId'],
    });
  }

  Future<void> deleteAppointment(String id) async {
    await _appointmentsCollection.doc(id).delete();
  }

  Appointment _appointmentFromMap(
    String id,
    Map<String, dynamic> data,
    Doctor doctor,
  ) {
    return Appointment(
      id: id,
      doctor: doctor,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      duration: data['duration'] as String,
      reason: data['reason'] as String,
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == data['status'] as String,
      ),
      notes: data['notes'] as String?,
      prescription: data['prescription'] as String?,
    );
  }

  // Real-time listeners
  Stream<List<Doctor>> watchDoctors() {
    return _doctorsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => _doctorFromMap(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    });
  }

  Stream<List<Appointment>> watchAppointments() {
    return _appointmentsCollection
        .orderBy('dateTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final appointments = <Appointment>[];
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final doctor = await getDoctor(data['doctorId'] as String);
        if (doctor != null) {
          appointments.add(_appointmentFromMap(doc.id, data, doctor));
        }
      }
      return appointments;
    });
  }
}

