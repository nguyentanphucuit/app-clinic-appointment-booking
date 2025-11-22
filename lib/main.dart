import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/user_provider.dart';
import 'providers/doctor_provider.dart';
import 'providers/appointment_provider.dart';
import 'screens/home_screen.dart';
import 'screens/doctors_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/profile_screen.dart';
import 'utils/app_colors.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi_VN', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ],
      child: Builder(
        builder: (context) {
          // Initialize appointments after providers are available
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final doctorProvider = Provider.of<DoctorProvider>(
              context,
              listen: false,
            );
            final appointmentProvider = Provider.of<AppointmentProvider>(
              context,
              listen: false,
            );

            // Load appointments from database
            await appointmentProvider.loadAppointments();

            // If no appointments, load sample data
            if (appointmentProvider.appointments.isEmpty &&
                doctorProvider.doctors.isNotEmpty) {
              await appointmentProvider.loadSampleAppointments(
                doctorProvider.doctors,
              );
            }
          });

          return const CupertinoApp(
            title: 'Đặt lịch khám',
            debugShowCheckedModeBanner: false,
            theme: CupertinoThemeData(
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: AppColors.background,
              barBackgroundColor: AppColors.surface,
              textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(
                  fontFamily: '.SF Pro Text',
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            home: MainNavigationScreen(),
          );
        },
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    DoctorsScreen(),
    AppointmentsScreen(),
    ProfileScreen(),
  ];

  final List<_NavItem> _navItems = const [
    _NavItem(icon: CupertinoIcons.house_fill, label: 'Trang chủ'),
    _NavItem(icon: CupertinoIcons.person_2_fill, label: 'Bác sĩ'),
    _NavItem(icon: CupertinoIcons.calendar_today, label: 'Lịch hẹn'),
    _NavItem(icon: CupertinoIcons.person_fill, label: 'Hồ sơ'),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          Expanded(
            child: IndexedStack(index: _currentIndex, children: _screens),
          ),

          // Custom Bottom Navigation Bar
          Container(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingL,
                  vertical: AppConstants.paddingS,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    _navItems.length,
                    (index) => _buildNavItem(
                      item: _navItems[index],
                      index: index,
                      isSelected: _currentIndex == index,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required _NavItem item,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppConstants.durationMedium,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected
              ? AppConstants.paddingM
              : AppConstants.paddingS,
          vertical: AppConstants.paddingS,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : CupertinoColors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: AppConstants.iconM,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                item.label,
                style: const TextStyle(
                  fontSize: AppConstants.fontM,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
