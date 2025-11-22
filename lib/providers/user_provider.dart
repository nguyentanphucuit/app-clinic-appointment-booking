import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../database/database_helper.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  final DatabaseHelper _db = DatabaseHelper.instance;

  User? get currentUser => _currentUser;

  UserProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _currentUser = await _db.getCurrentUser();
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
    await _db.insertUser(sampleUser);
    _currentUser = sampleUser;
  }

  Future<void> updateUser(User user) async {
    await _db.updateUser(user);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    DateTime? dateOfBirth,
    String? bloodType,
  }) async {
    if (_currentUser != null) {
      final updatedUser = _currentUser!.copyWith(
        name: name,
        email: email,
        phone: phone,
        address: address,
        dateOfBirth: dateOfBirth,
        bloodType: bloodType,
      );
      await _db.updateUser(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
    }
  }
}
