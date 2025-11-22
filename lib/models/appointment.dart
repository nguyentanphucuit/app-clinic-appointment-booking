import 'doctor.dart';

enum AppointmentStatus { upcoming, completed, cancelled }

class Appointment {
  final String id;
  final Doctor doctor;
  final DateTime dateTime;
  final String duration; // e.g., "30 min"
  final String reason;
  final AppointmentStatus status;
  final String? notes;
  final String? prescription;

  Appointment({
    required this.id,
    required this.doctor,
    required this.dateTime,
    required this.duration,
    required this.reason,
    required this.status,
    this.notes,
    this.prescription,
  });

  bool get isUpcoming {
    return status == AppointmentStatus.upcoming &&
        dateTime.isAfter(DateTime.now());
  }

  bool get isPast {
    return dateTime.isBefore(DateTime.now());
  }

  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  String get timeUntil {
    if (isPast) return 'Đã qua';

    final difference = dateTime.difference(DateTime.now());

    if (difference.inDays > 0) {
      return 'Còn ${difference.inDays} ngày';
    } else if (difference.inHours > 0) {
      return 'Còn ${difference.inHours} giờ';
    } else if (difference.inMinutes > 0) {
      return 'Còn ${difference.inMinutes} phút';
    } else {
      return 'Sắp bắt đầu';
    }
  }

  Appointment copyWith({
    String? id,
    Doctor? doctor,
    DateTime? dateTime,
    String? duration,
    String? reason,
    AppointmentStatus? status,
    String? notes,
    String? prescription,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctor: doctor ?? this.doctor,
      dateTime: dateTime ?? this.dateTime,
      duration: duration ?? this.duration,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      prescription: prescription ?? this.prescription,
    );
  }
}
