import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/doctor.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.onTap,
    this.onFavorite,
  });

  Color _getSpecialtyColor() {
    switch (doctor.specialty.toLowerCase()) {
      case 'tim mạch':
        return AppColors.cardiology;
      case 'da liễu':
        return AppColors.dermatology;
      case 'thần kinh':
        return AppColors.neurology;
      case 'nhi khoa':
        return AppColors.pediatrics;
      case 'chỉnh hình':
        return AppColors.orthopedics;
      case 'tâm thần':
        return AppColors.psychiatry;
      case 'nha khoa':
        return AppColors.dentistry;
      case 'tổng quát':
        return AppColors.general;
      default:
        return AppColors.general;
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
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: AppConstants.avatarL,
                height: AppConstants.avatarL,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  border: Border.all(color: _getSpecialtyColor(), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  child: CachedNetworkImage(
                    imageUrl: doctor.avatar,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Center(child: CupertinoActivityIndicator()),
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

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            doctor.name,
                            style: const TextStyle(
                              fontSize: AppConstants.fontL,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (onFavorite != null)
                          GestureDetector(
                            onTap: onFavorite,
                            child: Icon(
                              doctor.isFavorite
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: doctor.isFavorite
                                  ? AppColors.error
                                  : AppColors.textTertiary,
                              size: AppConstants.iconM,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingXS),

                    // Specialty badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingS,
                        vertical: AppConstants.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: _getSpecialtyColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusS,
                        ),
                      ),
                      child: Text(
                        doctor.specialty,
                        style: TextStyle(
                          fontSize: AppConstants.fontXS,
                          fontWeight: FontWeight.w600,
                          color: _getSpecialtyColor(),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingS),

                    // Rating and experience
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.star_fill,
                          size: AppConstants.iconS,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Formatters.formatRating(doctor.rating),
                          style: const TextStyle(
                            fontSize: AppConstants.fontS,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${Formatters.formatReviewCount(doctor.reviewCount)})',
                          style: const TextStyle(
                            fontSize: AppConstants.fontXS,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingM),
                        const Icon(
                          CupertinoIcons.briefcase_fill,
                          size: AppConstants.iconS,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${doctor.experience} năm',
                          style: const TextStyle(
                            fontSize: AppConstants.fontS,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingS),

                    // Hospital
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.building_2_fill,
                          size: AppConstants.iconS,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            doctor.hospital,
                            style: const TextStyle(
                              fontSize: AppConstants.fontS,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingS),

                    // Fee
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.money_dollar_circle_fill,
                          size: AppConstants.iconS,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Formatters.formatCurrency(doctor.consultationFee),
                          style: const TextStyle(
                            fontSize: AppConstants.fontM,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
