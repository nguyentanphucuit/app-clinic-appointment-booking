import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  final VoidCallback? onEdit;

  const ProfileHeader({super.key, required this.user, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.radiusXL),
          bottomRight: Radius.circular(AppConstants.radiusXL),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  if (onEdit != null)
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: onEdit,
                      child: Container(
                        padding: const EdgeInsets.all(AppConstants.paddingS),
                        decoration: BoxDecoration(
                          color: AppColors.textOnPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusM,
                          ),
                        ),
                        child: const Icon(
                          CupertinoIcons.pencil,
                          color: AppColors.textOnPrimary,
                          size: AppConstants.iconM,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingS),

              // Avatar
              Container(
                width: AppConstants.avatarXL,
                height: AppConstants.avatarXL,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.textOnPrimary, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.avatar,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.textOnPrimary.withOpacity(0.2),
                      child: const Center(
                        child: CupertinoActivityIndicator(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.textOnPrimary.withOpacity(0.2),
                      child: const Icon(
                        CupertinoIcons.person_fill,
                        size: 48,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingM),

              // Name
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: AppConstants.fontXXL,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textOnPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.paddingXS),

              // Email
              Text(
                user.email,
                style: TextStyle(
                  fontSize: AppConstants.fontM,
                  color: AppColors.textOnPrimary.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: AppConstants.paddingL),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('Age', '${user.age} years'),
                  _buildDivider(),
                  _buildStatItem('Blood Type', user.bloodType),
                  _buildDivider(),
                  _buildStatItem('Gender', user.gender),
                ],
              ),
              const SizedBox(height: AppConstants.paddingM),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: AppConstants.fontL,
            fontWeight: FontWeight.w700,
            color: AppColors.textOnPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: AppConstants.fontXS,
            color: AppColors.textOnPrimary.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.textOnPrimary.withOpacity(0.3),
    );
  }
}
