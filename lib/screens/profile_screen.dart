import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/appointment_provider.dart';
import '../widgets/profile_header.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _handleLogout(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context); // Đóng dialog
              
              // Clear user và appointments
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
              
              await userProvider.logout();
              appointmentProvider.clearAppointments();
              
              // Navigate về login screen
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false, // Xóa tất cả routes trước đó
                );
              }
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

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
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
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
                    'Thông tin cá nhân',
                    style: TextStyle(
                      fontSize: AppConstants.fontXL,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  _buildInfoCard(
                    icon: CupertinoIcons.phone_fill,
                    title: 'Điện thoại',
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
                    title: 'Địa chỉ',
                    value: user.address,
                    color: AppColors.accent,
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  _buildInfoCard(
                    icon: CupertinoIcons.calendar,
                    title: 'Ngày sinh',
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
                      'Tiền sử bệnh',
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
                    'Cài đặt',
                    style: TextStyle(
                      fontSize: AppConstants.fontXL,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  _buildSettingItem(
                    icon: CupertinoIcons.bell_fill,
                    title: 'Thông báo',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: CupertinoIcons.lock_fill,
                    title: 'Quyền riêng tư & Bảo mật',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: CupertinoIcons.question_circle_fill,
                    title: 'Trợ giúp & Hỗ trợ',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: CupertinoIcons.info_circle_fill,
                    title: 'Về ứng dụng',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: CupertinoIcons.arrow_right_square_fill,
                    title: 'Đăng xuất',
                    isDestructive: true,
                    onTap: () => _handleLogout(context),
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
