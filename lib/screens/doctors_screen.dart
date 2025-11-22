import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../widgets/doctor_card.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'doctor_detail_screen.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final filteredDoctors = doctorProvider.filteredDoctors;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
        middle: Text(
          'Tìm bác sĩ',
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
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Tìm bác sĩ, chuyên khoa...',
                style: const TextStyle(
                  fontSize: AppConstants.fontM,
                  color: AppColors.textPrimary,
                ),
                placeholderStyle: const TextStyle(
                  fontSize: AppConstants.fontM,
                  color: AppColors.textTertiary,
                ),
                backgroundColor: AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                onChanged: (value) {
                  doctorProvider.setSearchQuery(value);
                },
              ),
            ),

            // Specialty Filter
            SizedBox(
              height: 36,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingL,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: doctorProvider.allSpecialties.length,
                itemBuilder: (context, index) {
                  final specialty = doctorProvider.allSpecialties[index];
                  final isSelected =
                      doctorProvider.selectedSpecialty == specialty;

                  return GestureDetector(
                    onTap: () {
                      doctorProvider.setSelectedSpecialty(specialty);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: AppConstants.paddingS,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingM,
                        vertical: AppConstants.paddingS,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusRound,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          specialty,
                          style: TextStyle(
                            fontSize: AppConstants.fontM,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.textOnPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppConstants.paddingM),

            // Results Count
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingL,
              ),
              child: Row(
                children: [
                  Text(
                    'Tìm thấy ${filteredDoctors.length} bác sĩ',
                    style: const TextStyle(
                      fontSize: AppConstants.fontM,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingM),

            // Doctors List
            Expanded(
              child: filteredDoctors.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.search,
                            size: 64,
                            color: AppColors.textTertiary.withOpacity(0.5),
                          ),
                          const SizedBox(height: AppConstants.paddingM),
                          const Text(
                            'Không tìm thấy bác sĩ',
                            style: TextStyle(
                              fontSize: AppConstants.fontL,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingS),
                          const Text(
                            'Thử điều chỉnh tìm kiếm hoặc bộ lọc',
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
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        final doctor = filteredDoctors[index];
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
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
