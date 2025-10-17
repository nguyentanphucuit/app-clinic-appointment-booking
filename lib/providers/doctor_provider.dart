import 'package:flutter/cupertino.dart';
import '../models/doctor.dart';

class DoctorProvider with ChangeNotifier {
  List<Doctor> _doctors = [];
  String _searchQuery = '';
  String _selectedSpecialty = 'All';

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
    if (_selectedSpecialty != 'All') {
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
    _loadSampleDoctors();
  }

  void _loadSampleDoctors() {
    _doctors = [
      Doctor(
        id: '1',
        name: 'Dr. Sarah Johnson',
        specialty: 'Cardiology',
        avatar: 'https://i.pravatar.cc/150?img=47',
        rating: 4.9,
        reviewCount: 284,
        experience: 15,
        hospital: 'City Medical Center',
        about:
            'Experienced cardiologist specializing in heart disease prevention and treatment. Board certified with extensive experience in cardiac care.',
        availableDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
        startTime: '09:00',
        endTime: '17:00',
        consultationFee: 500000,
        isFavorite: true,
      ),
      Doctor(
        id: '2',
        name: 'Dr. Michael Chen',
        specialty: 'Dermatology',
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
        name: 'Dr. Emily Rodriguez',
        specialty: 'Pediatrics',
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
        name: 'Dr. David Thompson',
        specialty: 'Orthopedics',
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
        name: 'Dr. Lisa Anderson',
        specialty: 'Neurology',
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
        name: 'Dr. James Wilson',
        specialty: 'General Practice',
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
        name: 'Dr. Maria Garcia',
        specialty: 'Psychiatry',
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
        name: 'Dr. Robert Lee',
        specialty: 'Dentistry',
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

  void toggleFavorite(String doctorId) {
    final index = _doctors.indexWhere((d) => d.id == doctorId);
    if (index != -1) {
      _doctors[index] = _doctors[index].copyWith(
        isFavorite: !_doctors[index].isFavorite,
      );
      notifyListeners();
    }
  }

  Doctor? getDoctorById(String id) {
    try {
      return _doctors.firstWhere((doctor) => doctor.id == id);
    } catch (e) {
      return null;
    }
  }

  List<String> get allSpecialties {
    final specialties = _doctors.map((d) => d.specialty).toSet().toList();
    specialties.sort();
    return ['All', ...specialties];
  }
}
