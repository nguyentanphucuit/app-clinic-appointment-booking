import 'package:flutter/cupertino.dart';
import '../models/specialty.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class SpecialtyCard extends StatelessWidget {
  final Specialty specialty;
  final VoidCallback? onTap;
  final bool isSelected;

  const SpecialtyCard({
    super.key,
    required this.specialty,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: AppConstants.paddingM),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: AppConstants.borderRadiusL,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.textOnPrimary.withOpacity(0.2)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                child: Icon(
                  specialty.icon,
                  size: AppConstants.iconL,
                  color:
                      isSelected ? AppColors.textOnPrimary : AppColors.primary,
                ),
              ),
              const SizedBox(height: AppConstants.paddingS),
              Text(
                specialty.name,
                style: TextStyle(
                  fontSize: AppConstants.fontXS,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.textOnPrimary
                      : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${specialty.doctorCount} bác sĩ',
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? AppColors.textOnPrimary.withOpacity(0.8)
                      : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
