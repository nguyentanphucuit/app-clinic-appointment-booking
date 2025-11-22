import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  final FirestoreService _firestore = FirestoreService.instance;

  User? get currentUser => _currentUser;

  UserProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _currentUser = await _firestore.getCurrentUser();
    if (_currentUser == null) {
      await _loadSampleUser();
    }
    notifyListeners();
  }

  Future<void> _loadSampleUser() async {
    final sampleUser = User(
      id: '1',
      name: 'Nguyễn Văn Nam',
      email: 'nguyen.van.nam@email.com',
      password: '123456', // Default password cho sample user
      phone: '0123456789',
      avatar: 'https://i.pravatar.cc/150?img=12',
      dateOfBirth: DateTime(1990, 5, 15),
      gender: 'Nam',
      bloodType: 'O+',
      address: '123 Healthcare St, Medical City',
      medicalHistory: [
        'Hypertension (2020)',
        'Seasonal allergies',
        'Regular checkups',
      ],
    );
    await _firestore.createUser(sampleUser);
    _currentUser = sampleUser;
  }

  Future<void> updateUser(User user) async {
    await _firestore.updateUser(user);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodType,
    List<String>? medicalHistory,
  }) async {
    if (_currentUser != null) {
      final updatedUser = _currentUser!.copyWith(
        name: name,
        email: email,
        phone: phone,
        address: address,
        dateOfBirth: dateOfBirth,
        gender: gender,
        bloodType: bloodType,
        medicalHistory: medicalHistory,
      );
      await _firestore.updateUser(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
}
