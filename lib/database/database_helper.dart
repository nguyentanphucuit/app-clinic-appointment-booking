import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('clinic_appointment.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        avatar TEXT NOT NULL,
        dateOfBirth INTEGER NOT NULL,
        gender TEXT NOT NULL,
        bloodType TEXT NOT NULL,
        address TEXT NOT NULL,
        medicalHistory TEXT
      )
    ''');

    // Doctors table
    await db.execute('''
      CREATE TABLE doctors (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        specialty TEXT NOT NULL,
        avatar TEXT NOT NULL,
        rating REAL NOT NULL,
        reviewCount INTEGER NOT NULL,
        experience INTEGER NOT NULL,
        hospital TEXT NOT NULL,
        about TEXT NOT NULL,
        availableDays TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        consultationFee REAL NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Appointments table
    await db.execute('''
      CREATE TABLE appointments (
        id TEXT PRIMARY KEY,
        doctorId TEXT NOT NULL,
        dateTime INTEGER NOT NULL,
        duration TEXT NOT NULL,
        reason TEXT NOT NULL,
        status TEXT NOT NULL,
        notes TEXT,
        prescription TEXT,
        FOREIGN KEY (doctorId) REFERENCES doctors (id)
      )
    ''');
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(
      'users',
      {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'avatar': user.avatar,
        'dateOfBirth': user.dateOfBirth.millisecondsSinceEpoch,
        'gender': user.gender,
        'bloodType': user.bloodType,
        'address': user.address,
        'medicalHistory': user.medicalHistory.join('|||'),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser(String id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return _userFromMap(maps.first);
  }

  Future<User?> getCurrentUser() async {
    final db = await database;
    final maps = await db.query('users', limit: 1);

    if (maps.isEmpty) return null;
    return _userFromMap(maps.first);
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      {
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'avatar': user.avatar,
        'dateOfBirth': user.dateOfBirth.millisecondsSinceEpoch,
        'gender': user.gender,
        'bloodType': user.bloodType,
        'address': user.address,
        'medicalHistory': user.medicalHistory.join('|||'),
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  User _userFromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      avatar: map['avatar'] as String,
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int),
      gender: map['gender'] as String,
      bloodType: map['bloodType'] as String,
      address: map['address'] as String,
      medicalHistory: (map['medicalHistory'] as String?)
              ?.split('|||')
              .where((s) => s.isNotEmpty)
              .toList() ??
          [],
    );
  }

  // Doctor operations
  Future<int> insertDoctor(Doctor doctor) async {
    final db = await database;
    return await db.insert(
      'doctors',
      {
        'id': doctor.id,
        'name': doctor.name,
        'specialty': doctor.specialty,
        'avatar': doctor.avatar,
        'rating': doctor.rating,
        'reviewCount': doctor.reviewCount,
        'experience': doctor.experience,
        'hospital': doctor.hospital,
        'about': doctor.about,
        'availableDays': doctor.availableDays.join(','),
        'startTime': doctor.startTime,
        'endTime': doctor.endTime,
        'consultationFee': doctor.consultationFee,
        'isFavorite': doctor.isFavorite ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Doctor>> getAllDoctors() async {
    final db = await database;
    final maps = await db.query('doctors');
    return maps.map((map) => _doctorFromMap(map)).toList();
  }

  Future<Doctor?> getDoctor(String id) async {
    final db = await database;
    final maps = await db.query(
      'doctors',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return _doctorFromMap(maps.first);
  }

  Future<int> updateDoctor(Doctor doctor) async {
    final db = await database;
    return await db.update(
      'doctors',
      {
        'name': doctor.name,
        'specialty': doctor.specialty,
        'avatar': doctor.avatar,
        'rating': doctor.rating,
        'reviewCount': doctor.reviewCount,
        'experience': doctor.experience,
        'hospital': doctor.hospital,
        'about': doctor.about,
        'availableDays': doctor.availableDays.join(','),
        'startTime': doctor.startTime,
        'endTime': doctor.endTime,
        'consultationFee': doctor.consultationFee,
        'isFavorite': doctor.isFavorite ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [doctor.id],
    );
  }

  Future<int> toggleDoctorFavorite(String doctorId, bool isFavorite) async {
    final db = await database;
    return await db.update(
      'doctors',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [doctorId],
    );
  }

  Doctor _doctorFromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as String,
      name: map['name'] as String,
      specialty: map['specialty'] as String,
      avatar: map['avatar'] as String,
      rating: map['rating'] as double,
      reviewCount: map['reviewCount'] as int,
      experience: map['experience'] as int,
      hospital: map['hospital'] as String,
      about: map['about'] as String,
      availableDays: (map['availableDays'] as String).split(','),
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      consultationFee: map['consultationFee'] as double,
      isFavorite: (map['isFavorite'] as int) == 1,
    );
  }

  // Appointment operations
  Future<int> insertAppointment(Appointment appointment) async {
    final db = await database;
    return await db.insert(
      'appointments',
      {
        'id': appointment.id,
        'doctorId': appointment.doctor.id,
        'dateTime': appointment.dateTime.millisecondsSinceEpoch,
        'duration': appointment.duration,
        'reason': appointment.reason,
        'status': appointment.status.name,
        'notes': appointment.notes,
        'prescription': appointment.prescription,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Appointment>> getAllAppointments() async {
    final db = await database;
    final maps = await db.query('appointments', orderBy: 'dateTime DESC');

    final appointments = <Appointment>[];
    for (final map in maps) {
      final doctor = await getDoctor(map['doctorId'] as String);
      if (doctor != null) {
        appointments.add(_appointmentFromMap(map, doctor));
      }
    }
    return appointments;
  }

  Future<Appointment?> getAppointment(String id) async {
    final db = await database;
    final maps = await db.query(
      'appointments',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    final doctor = await getDoctor(maps.first['doctorId'] as String);
    if (doctor == null) return null;
    return _appointmentFromMap(maps.first, doctor);
  }

  Future<int> updateAppointment(Appointment appointment) async {
    final db = await database;
    return await db.update(
      'appointments',
      {
        'doctorId': appointment.doctor.id,
        'dateTime': appointment.dateTime.millisecondsSinceEpoch,
        'duration': appointment.duration,
        'reason': appointment.reason,
        'status': appointment.status.name,
        'notes': appointment.notes,
        'prescription': appointment.prescription,
      },
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  Future<int> deleteAppointment(String id) async {
    final db = await database;
    return await db.delete(
      'appointments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Appointment _appointmentFromMap(Map<String, dynamic> map, Doctor doctor) {
    return Appointment(
      id: map['id'] as String,
      doctor: doctor,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      duration: map['duration'] as String,
      reason: map['reason'] as String,
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == map['status'] as String,
      ),
      notes: map['notes'] as String?,
      prescription: map['prescription'] as String?,
    );
  }

  // Utility methods
  Future<void> clearAllTables() async {
    final db = await database;
    await db.delete('appointments');
    await db.delete('doctors');
    await db.delete('users');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

