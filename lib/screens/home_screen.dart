import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/specialty.dart';
import '../providers/user_provider.dart';
import '../providers/doctor_provider.dart';
import '../providers/appointment_provider.dart';
import '../widgets/specialty_card.dart';
import '../widgets/doctor_card.dart';
import '../widgets/stats_card.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'doctor_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Specialty> _specialties = [
    Specialty(
      id: '1',
      name: 'Tim mạch',
      icon: CupertinoIcons.heart_fill,
      doctorCount: 12,
      description: 'Chăm sóc tim & mạch máu',
    ),
    Specialty(
      id: '2',
      name: 'Da liễu',
      icon: CupertinoIcons.sparkles,
      doctorCount: 8,
      description: 'Chuyên khoa da',
    ),
    Specialty(
      id: '3',
      name: 'Nhi khoa',
      icon: CupertinoIcons.smiley_fill,
      doctorCount: 15,
      description: 'Chăm sóc trẻ em',
    ),
    Specialty(
      id: '4',
      name: 'Thần kinh',
      icon: CupertinoIcons.bolt_fill,
      doctorCount: 10,
      description: 'Não & hệ thần kinh',
    ),
    Specialty(
      id: '5',
      name: 'Chỉnh hình',
      icon: CupertinoIcons.bandage_fill,
      doctorCount: 14,
      description: 'Chăm sóc xương & khớp',
    ),
    Specialty(
      id: '6',
      name: 'Nha khoa',
      icon: CupertinoIcons.heart_circle_fill,
      doctorCount: 11,
      description: 'Chăm sóc răng miệng',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final user = userProvider.currentUser;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingL),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chào mừng trở lại,',
                            style: TextStyle(
                              fontSize: AppConstants.fontM,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.name ?? 'Khách',
                            style: const TextStyle(
                              fontSize: AppConstants.fontXXL,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: Container(
                        padding: const EdgeInsets.all(AppConstants.paddingS),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusM,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.bell_fill,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Stats Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingL,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        icon: CupertinoIcons.calendar_today,
                        title: 'Sắp tới',
                        value: '${appointmentProvider.upcomingCount}',
                        color: AppColors.upcoming,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingM),
                    Expanded(
                      child: StatsCard(
                        icon: CupertinoIcons.check_mark_circled_solid,
                        title: 'Hoàn thành',
                        value: '${appointmentProvider.completedCount}',
                        color: AppColors.completed,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Specialties Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppConstants.paddingL,
                  top: AppConstants.paddingXL,
                  bottom: AppConstants.paddingM,
                ),
                child: const Text(
                  'Chuyên khoa',
                  style: TextStyle(
                    fontSize: AppConstants.fontXL,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 140,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingL,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: _specialties.length,
                  itemBuilder: (context, index) {
                    return SpecialtyCard(
                      specialty: _specialties[index],
                      onTap: () {
                        // Navigate to doctors filtered by specialty
                      },
                    );
                  },
                ),
              ),
            ),

            // Today's Appointments Section
            if (appointmentProvider.todayAppointments.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppConstants.paddingL,
                    top: AppConstants.paddingXL,
                    bottom: AppConstants.paddingM,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Lịch hẹn hôm nay',
                        style: TextStyle(
                          fontSize: AppConstants.fontXL,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingS,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusRound,
                          ),
                        ),
                        child: Text(
                          '${appointmentProvider.todayAppointments.length}',
                          style: const TextStyle(
                            fontSize: AppConstants.fontXS,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Top Rated Doctors Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppConstants.paddingL,
                  top: AppConstants.paddingXL,
                  bottom: AppConstants.paddingM,
                  right: AppConstants.paddingL,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bác sĩ được đánh giá cao',
                      style: TextStyle(
                        fontSize: AppConstants.fontXL,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // Navigate to all doctors
                      },
                      child: const Text(
                        'Xem tất cả',
                        style: TextStyle(
                          fontSize: AppConstants.fontM,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Top Rated Doctors List
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingL,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final doctor = doctorProvider.topRatedDoctors[index];
                  return DoctorCard(
                    doctor: doctor,
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) =>
                              DoctorDetailScreen(doctor: doctor),
                        ),
                      );
                    },
                    onFavorite: () async {
                      await doctorProvider.toggleFavorite(doctor.id);
                    },
                  );
                }, childCount: doctorProvider.topRatedDoctors.length),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppConstants.paddingXL),
            ),
          ],
        ),
      ),
    );
  }
}
