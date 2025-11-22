class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String avatar;
  final double rating;
  final int reviewCount;
  final int experience; // years
  final String hospital;
  final String about;
  final List<String> availableDays; // Mon, Tue, Wed, etc.
  final String startTime; // e.g., "09:00"
  final String endTime; // e.g., "17:00"
  final double consultationFee;
  final bool isFavorite;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.avatar,
    required this.rating,
    required this.reviewCount,
    required this.experience,
    required this.hospital,
    required this.about,
    required this.availableDays,
    required this.startTime,
    required this.endTime,
    required this.consultationFee,
    this.isFavorite = false,
  });

  String get availabilityText {
    if (availableDays.length == 7) {
      return 'Có mặt mỗi ngày';
    } else if (availableDays.length >= 5) {
      return 'Có mặt các ngày trong tuần';
    } else {
      final dayNames = availableDays.map((day) {
        switch (day) {
          case 'Mon':
            return 'Thứ Hai';
          case 'Tue':
            return 'Thứ Ba';
          case 'Wed':
            return 'Thứ Tư';
          case 'Thu':
            return 'Thứ Năm';
          case 'Fri':
            return 'Thứ Sáu';
          case 'Sat':
            return 'Thứ Bảy';
          case 'Sun':
            return 'Chủ Nhật';
          default:
            return day;
        }
      }).toList();
      return 'Có mặt ${dayNames.join(", ")}';
    }
  }

  Doctor copyWith({
    String? id,
    String? name,
    String? specialty,
    String? avatar,
    double? rating,
    int? reviewCount,
    int? experience,
    String? hospital,
    String? about,
    List<String>? availableDays,
    String? startTime,
    String? endTime,
    double? consultationFee,
    bool? isFavorite,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      avatar: avatar ?? this.avatar,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      experience: experience ?? this.experience,
      hospital: hospital ?? this.hospital,
      about: about ?? this.about,
      availableDays: availableDays ?? this.availableDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      consultationFee: consultationFee ?? this.consultationFee,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
