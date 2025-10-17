import 'package:flutter/cupertino.dart';

class Specialty {
  final String id;
  final String name;
  final IconData icon;
  final int doctorCount;
  final String description;

  Specialty({
    required this.id,
    required this.name,
    required this.icon,
    required this.doctorCount,
    required this.description,
  });
}
