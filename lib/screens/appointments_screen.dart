import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../widgets/appointment_card.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final filteredAppointments = appointmentProvider.filteredAppointments;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
        middle: Text(
          'My Appointments',
          style: TextStyle(
            fontSize: AppConstants.fontL,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Filter Tabs
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              child: Row(
                children: [
                  Expanded(
                    child: _FilterChip(
                      label: 'All',
                      count: appointmentProvider.appointments.length,
                      isSelected: appointmentProvider.filterStatus == 'All',
                      onTap: () {
                        appointmentProvider.setFilterStatus('All');
                      },
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingS),
                  Expanded(
                    child: _FilterChip(
                      label: 'Upcoming',
                      count: appointmentProvider.upcomingCount,
                      isSelected:
                          appointmentProvider.filterStatus == 'Upcoming',
                      color: AppColors.upcoming,
                      onTap: () {
                        appointmentProvider.setFilterStatus('Upcoming');
                      },
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingS),
                  Expanded(
                    child: _FilterChip(
                      label: 'Completed',
                      count: appointmentProvider.completedCount,
                      isSelected:
                          appointmentProvider.filterStatus == 'Completed',
                      color: AppColors.completed,
                      onTap: () {
                        appointmentProvider.setFilterStatus('Completed');
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Appointments List
            Expanded(
              child: filteredAppointments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.calendar,
                            size: 64,
                            color: AppColors.textTertiary.withOpacity(0.5),
                          ),
                          const SizedBox(height: AppConstants.paddingM),
                          const Text(
                            'No appointments found',
                            style: TextStyle(
                              fontSize: AppConstants.fontL,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingS),
                          const Text(
                            'Book an appointment with a doctor',
                            style: TextStyle(
                              fontSize: AppConstants.fontM,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingL,
                      ),
                      itemCount: filteredAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = filteredAppointments[index];
                        return AppointmentCard(
                          appointment: appointment,
                          onTap: () {
                            // Show appointment details
                            _showAppointmentDetails(context, appointment);
                          },
                          onCancel: () {
                            _showCancelDialog(context, appointment.id);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppointmentDetails(BuildContext context, appointment) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(
          'Appointment Details',
          style: TextStyle(
            fontSize: AppConstants.fontL,
            fontWeight: FontWeight.w600,
          ),
        ),
        message: Text(
          'Appointment with ${appointment.doctor.name}',
          style: const TextStyle(fontSize: AppConstants.fontM),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('View Doctor Profile'),
          ),
          if (appointment.notes != null || appointment.prescription != null)
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('View Medical Records'),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String appointmentId) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text(
          'Are you sure you want to cancel this appointment?',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Provider.of<AppointmentProvider>(
                context,
                listen: false,
              ).cancelAppointment(appointmentId);
              Navigator.pop(context);
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingM),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: isSelected ? chipColor : AppColors.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: chipColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: AppConstants.fontXL,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.textOnPrimary : chipColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: AppConstants.fontXS,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
