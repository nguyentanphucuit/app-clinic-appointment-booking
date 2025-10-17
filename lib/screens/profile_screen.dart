import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/profile_header.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    if (user == null) {
      return const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: CustomScrollView(
        slivers: [
          // Profile Header
          SliverToBoxAdapter(
            child: ProfileHeader(
              user: user,
              onEdit: () {
                // Navigate to edit profile
              },
            ),
          ),

          // Personal Information Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: AppConstants.fontXL,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  _buildInfoCard(
                    icon: CupertinoIcons.phone_fill,
                    title: 'Phone',
                    value: Formatters.formatPhoneNumber(user.phone),
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  _buildInfoCard(
                    icon: CupertinoIcons.mail_solid,
                    title: 'Email',
                    value: user.email,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  _buildInfoCard(
                    icon: CupertinoIcons.location_solid,
                    title: 'Address',
                    value: user.address,
                    color: AppColors.accent,
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  _buildInfoCard(
                    icon: CupertinoIcons.calendar,
                    title: 'Date of Birth',
                    value: Formatters.formatDate(user.dateOfBirth),
                    color: AppColors.info,
                  ),
                ],
              ),
            ),
          ),

          // Medical History Section
          if (user.medicalHistory.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Medical History',
                      style: TextStyle(
                        fontSize: AppConstants.fontXL,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingM),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusL,
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
                        children: user.medicalHistory.asMap().entries.map((
                          entry,
                        ) {
                          final isLast =
                              entry.key == user.medicalHistory.length - 1;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.error,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: AppConstants.paddingM),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: const TextStyle(
                                        fontSize: AppConstants.fontM,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (!isLast)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppConstants.paddingS,
                                  ),
                                  child: Container(
                                    height: 1,
                                    color: AppColors.divider,
                                  ),
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Settings Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: AppConstants.fontXL,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  _buildSettingItem(
                    icon: CupertinoIcons.bell_fill,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: CupertinoIcons.lock_fill,
                    title: 'Privacy & Security',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: CupertinoIcons.question_circle_fill,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: CupertinoIcons.info_circle_fill,
                    title: 'About',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: CupertinoIcons.arrow_right_square_fill,
                    title: 'Logout',
                    isDestructive: true,
                    onTap: () {},
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
    );
  }

  Widget _buildInfoCard({
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

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
        padding: const EdgeInsets.all(AppConstants.paddingM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppColors.error : AppColors.primary,
              size: AppConstants.iconM,
            ),
            const SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppConstants.fontM,
                  fontWeight: FontWeight.w600,
                  color:
                      isDestructive ? AppColors.error : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: AppColors.textTertiary,
              size: AppConstants.iconM,
            ),
          ],
        ),
      ),
    );
  }
}
