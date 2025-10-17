import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/appointment.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
    this.onCancel,
  });

  Color _getStatusColor() {
    switch (appointment.status) {
      case AppointmentStatus.upcoming:
        return AppColors.upcoming;
      case AppointmentStatus.completed:
        return AppColors.completed;
      case AppointmentStatus.cancelled:
        return AppColors.cancelled;
    }
  }

  String _getStatusText() {
    switch (appointment.status) {
      case AppointmentStatus.upcoming:
        return 'Upcoming';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  IconData _getStatusIcon() {
    switch (appointment.status) {
      case AppointmentStatus.upcoming:
        return CupertinoIcons.clock_fill;
      case AppointmentStatus.completed:
        return CupertinoIcons.check_mark_circled_solid;
      case AppointmentStatus.cancelled:
        return CupertinoIcons.xmark_circle_fill;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppConstants.borderRadiusL,
          border: Border.all(
            color: _getStatusColor().withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with status
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingM,
                vertical: AppConstants.paddingS,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusL),
                  topRight: Radius.circular(AppConstants.radiusL),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(),
                    size: AppConstants.iconS,
                    color: _getStatusColor(),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _getStatusText(),
                    style: TextStyle(
                      fontSize: AppConstants.fontS,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(),
                    ),
                  ),
                  const Spacer(),
                  if (appointment.status == AppointmentStatus.upcoming)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingS,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusS,
                        ),
                      ),
                      child: Text(
                        appointment.timeUntil,
                        style: const TextStyle(
                          fontSize: AppConstants.fontXS,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Doctor avatar
                      Container(
                        width: AppConstants.avatarM,
                        height: AppConstants.avatarM,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusM,
                          ),
                          border: Border.all(
                            color: _getStatusColor(),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusM,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: appointment.doctor.avatar,
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
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingM),

                      // Doctor info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.doctor.name,
                              style: const TextStyle(
                                fontSize: AppConstants.fontM,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              appointment.doctor.specialty,
                              style: const TextStyle(
                                fontSize: AppConstants.fontS,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingM),

                  // Appointment details
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          CupertinoIcons.calendar,
                          Formatters.formatRelativeDate(appointment.dateTime),
                        ),
                        const SizedBox(height: AppConstants.paddingS),
                        _buildDetailRow(
                          CupertinoIcons.time,
                          appointment.duration,
                        ),
                        const SizedBox(height: AppConstants.paddingS),
                        _buildDetailRow(
                          CupertinoIcons.doc_text,
                          appointment.reason,
                        ),
                      ],
                    ),
                  ),

                  // Action button
                  if (onCancel != null &&
                      appointment.status == AppointmentStatus.upcoming)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppConstants.paddingM,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.paddingS,
                          ),
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusM,
                          ),
                          onPressed: onCancel,
                          child: const Text(
                            'Cancel Appointment',
                            style: TextStyle(
                              fontSize: AppConstants.fontM,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: AppConstants.iconS, color: AppColors.primary),
        const SizedBox(width: AppConstants.paddingS),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: AppConstants.fontS,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
