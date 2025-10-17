import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  UserProvider() {
    _loadSampleUser();
  }

  void _loadSampleUser() {
    _currentUser = User(
      id: '1',
      name: 'John Smith',
      email: 'john.smith@email.com',
      phone: '0123456789',
      avatar: 'https://i.pravatar.cc/150?img=12',
      dateOfBirth: DateTime(1990, 5, 15),
      gender: 'Male',
      bloodType: 'O+',
      address: '123 Healthcare St, Medical City',
      medicalHistory: [
        'Hypertension (2020)',
        'Seasonal allergies',
        'Regular checkups',
      ],
    );
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    DateTime? dateOfBirth,
    String? bloodType,
  }) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email,
        phone: phone,
        address: address,
        dateOfBirth: dateOfBirth,
        bloodType: bloodType,
      );
      notifyListeners();
    }
  }
}
