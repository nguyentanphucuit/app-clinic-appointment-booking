class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final DateTime dateOfBirth;
  final String gender;
  final String bloodType;
  final String address;
  final List<String> medicalHistory;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodType,
    required this.address,
    this.medicalHistory = const [],
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodType,
    String? address,
    List<String>? medicalHistory,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      address: address ?? this.address,
      medicalHistory: medicalHistory ?? this.medicalHistory,
    );
  }
}
