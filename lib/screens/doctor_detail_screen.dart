import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../providers/doctor_provider.dart';
import '../providers/appointment_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(CupertinoIcons.back, color: AppColors.primary),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            doctorProvider.toggleFavorite(doctor.id);
          },
          child: Icon(
            doctor.isFavorite
                ? CupertinoIcons.heart_fill
                : CupertinoIcons.heart,
            color:
                doctor.isFavorite ? AppColors.error : AppColors.textSecondary,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Doctor Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingL),
                      child: Column(
                        children: [
                          // Avatar
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: doctor.avatar,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.surfaceVariant,
                                  child: const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.surfaceVariant,
                                  child: const Icon(
                                    CupertinoIcons.person_fill,
                                    size: 48,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingM),

                          // Name
                          Text(
                            doctor.name,
                            style: const TextStyle(
                              fontSize: AppConstants.fontXXL,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppConstants.paddingS),

                          // Specialty
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingM,
                              vertical: AppConstants.paddingS,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusRound,
                              ),
                            ),
                            child: Text(
                              doctor.specialty,
                              style: const TextStyle(
                                fontSize: AppConstants.fontM,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingL),

                          // Stats Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStat(
                                icon: CupertinoIcons.star_fill,
                                value: Formatters.formatRating(doctor.rating),
                                label: 'Rating',
                                color: AppColors.warning,
                              ),
                              _buildDivider(),
                              _buildStat(
                                icon: CupertinoIcons.person_2_fill,
                                value:
                                    '${Formatters.formatReviewCount(doctor.reviewCount)}',
                                label: 'Reviews',
                                color: AppColors.primary,
                              ),
                              _buildDivider(),
                              _buildStat(
                                icon: CupertinoIcons.briefcase_fill,
                                value: '${doctor.experience}',
                                label: 'Years',
                                color: AppColors.secondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // About Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About',
                            style: TextStyle(
                              fontSize: AppConstants.fontXL,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingM),
                          Text(
                            doctor.about,
                            style: const TextStyle(
                              fontSize: AppConstants.fontM,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Details Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Details',
                            style: TextStyle(
                              fontSize: AppConstants.fontXL,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingM),
                          _buildDetailItem(
                            icon: CupertinoIcons.building_2_fill,
                            title: 'Hospital',
                            value: doctor.hospital,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: AppConstants.paddingM),
                          _buildDetailItem(
                            icon: CupertinoIcons.calendar,
                            title: 'Available Days',
                            value: doctor.availabilityText,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(height: AppConstants.paddingM),
                          _buildDetailItem(
                            icon: CupertinoIcons.clock_fill,
                            title: 'Working Hours',
                            value: '${doctor.startTime} - ${doctor.endTime}',
                            color: AppColors.accent,
                          ),
                          const SizedBox(height: AppConstants.paddingM),
                          _buildDetailItem(
                            icon: CupertinoIcons.money_dollar_circle_fill,
                            title: 'Consultation Fee',
                            value: Formatters.formatCurrency(
                              doctor.consultationFee,
                            ),
                            color: AppColors.success,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppConstants.paddingXL),
                  ),
                ],
              ),
            ),

            // Book Appointment Button
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingM,
                    ),
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    onPressed: () {
                      _showBookingSheet(context);
                    },
                    child: const Text(
                      'Book Appointment',
                      style: TextStyle(
                        fontSize: AppConstants.fontL,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: AppConstants.iconL),
        const SizedBox(height: AppConstants.paddingS),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppConstants.fontXL,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppConstants.fontS,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 48, color: AppColors.divider);
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Icon(icon, color: color, size: AppConstants.iconM),
          ),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppConstants.fontS,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: AppConstants.fontM,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(
          'Book Appointment',
          style: TextStyle(
            fontSize: AppConstants.fontL,
            fontWeight: FontWeight.w600,
          ),
        ),
        message: Text(
          'Select a date and time to book an appointment with ${doctor.name}',
          style: const TextStyle(fontSize: AppConstants.fontM),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showDateTimePicker(context);
            },
            child: const Text('Select Date & Time'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showDateTimePicker(BuildContext context) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
    final TextEditingController reasonController = TextEditingController();

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        color: AppColors.surface,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                  const Text(
                    'Book Appointment',
                    style: TextStyle(
                      fontSize: AppConstants.fontL,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _createAppointment(
                        context,
                        selectedDate,
                        selectedTime,
                        reasonController.text,
                      );
                    },
                    child: const Text(
                      'Book',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Date Picker Section
                    const Padding(
                      padding: EdgeInsets.all(AppConstants.paddingL),
                      child: Text(
                        'Select Date',
                        style: TextStyle(
                          fontSize: AppConstants.fontL,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: selectedDate,
                        minimumDate: DateTime.now(),
                        maximumDate:
                            DateTime.now().add(const Duration(days: 90)),
                        onDateTimeChanged: (DateTime newDate) {
                          selectedDate = newDate;
                        },
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingM),

                    // Time Picker Section
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingL),
                      child: Text(
                        'Select Time',
                        style: TextStyle(
                          fontSize: AppConstants.fontL,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          9,
                          0,
                        ),
                        use24hFormat: false,
                        onDateTimeChanged: (DateTime newTime) {
                          selectedTime = TimeOfDay.fromDateTime(newTime);
                        },
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingM),

                    // Reason Input Section
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reason for visit (optional)',
                            style: TextStyle(
                              fontSize: AppConstants.fontM,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingS),
                          CupertinoTextField(
                            controller: reasonController,
                            placeholder:
                                'e.g., Regular checkup, Consultation...',
                            padding:
                                const EdgeInsets.all(AppConstants.paddingM),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radiusM),
                              border: Border.all(color: AppColors.border),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom padding for safe area
                    const SizedBox(height: AppConstants.paddingXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createAppointment(
    BuildContext context,
    DateTime selectedDate,
    TimeOfDay selectedTime,
    String reason,
  ) {
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );

    // Combine date and time
    final appointmentDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Check if the selected time is in the past
    if (appointmentDateTime.isBefore(DateTime.now())) {
      _showErrorDialog(context, 'Please select a future date and time.');
      return;
    }

    // Check if doctor is available on the selected day
    final dayName = _getDayName(appointmentDateTime.weekday);
    if (!doctor.availableDays.contains(dayName)) {
      _showErrorDialog(
        context,
        'Dr. ${doctor.name} is not available on ${dayName}s.',
      );
      return;
    }

    // Check if the selected time is within working hours
    final appointmentTime =
        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
    if (appointmentTime.compareTo(doctor.startTime) < 0 ||
        appointmentTime.compareTo(doctor.endTime) > 0) {
      _showErrorDialog(
        context,
        'Please select a time between ${doctor.startTime} and ${doctor.endTime}.',
      );
      return;
    }

    // Create new appointment
    final newAppointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      doctor: doctor,
      dateTime: appointmentDateTime,
      duration: '30 min',
      reason: reason.isEmpty ? 'General consultation' : reason,
      status: AppointmentStatus.upcoming,
    );

    // Add appointment to provider
    appointmentProvider.addAppointment(newAppointment);

    // Close the picker
    Navigator.pop(context);

    // Show success message
    _showSuccessDialog(context, appointmentDateTime);
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return 'Mon';
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, DateTime appointmentDateTime) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Appointment Booked!'),
        content: Text(
          'Your appointment with ${doctor.name} has been scheduled for ${Formatters.formatDate(appointmentDateTime)} at ${Formatters.formatTime(appointmentDateTime)}.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to doctor detail screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
