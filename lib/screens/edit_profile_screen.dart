import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late DateTime _selectedDate;
  String _selectedGender = 'Nam';
  String _selectedBloodType = 'O+';
  bool _isLoading = false;
  List<String> _medicalHistory = [];

  final List<String> _bloodTypes = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];
  final List<String> _genders = ['Nam', 'Nữ', 'Khác'];

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (user != null) {
      _nameController = TextEditingController(text: user.name);
      _emailController = TextEditingController(text: user.email);
      _phoneController = TextEditingController(text: user.phone);
      _addressController = TextEditingController(text: user.address);
      _selectedDate = user.dateOfBirth;
      _selectedGender = user.gender;
      _selectedBloodType = user.bloodType;
      _medicalHistory = List<String>.from(user.medicalHistory);
    } else {
      _nameController = TextEditingController();
      _emailController = TextEditingController();
      _phoneController = TextEditingController();
      _addressController = TextEditingController();
      _selectedDate = DateTime(1990, 1, 1);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: AppColors.surface,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Hủy',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                  const Text(
                    'Chọn ngày sinh',
                    style: TextStyle(
                      fontSize: AppConstants.fontL,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context, _selectedDate);
                    },
                    child: const Text(
                      'Xong',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                maximumDate: DateTime.now(),
                minimumDate: DateTime(1900, 1, 1),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập tên');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập email');
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập số điện thoại');
      return;
    }
    if (_addressController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập địa chỉ');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        dateOfBirth: _selectedDate,
        gender: _selectedGender,
        bloodType: _selectedBloodType,
        medicalHistory: _medicalHistory,
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.pop(context);
        _showSuccessDialog();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        _showErrorDialog('Có lỗi xảy ra khi cập nhật thông tin: ${e.toString()}');
      }
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Thành công'),
        content: const Text('Cập nhật thông tin thành công!'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.back, color: AppColors.primary),
        ),
        middle: const Text(
          'Chỉnh sửa hồ sơ',
          style: TextStyle(
            fontSize: AppConstants.fontL,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: _isLoading
            ? const CupertinoActivityIndicator()
            : CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _saveProfile,
                child: const Text(
                  'Lưu',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              _buildTextField(
                label: 'Họ và tên',
                controller: _nameController,
                icon: CupertinoIcons.person_fill,
              ),
              const SizedBox(height: AppConstants.paddingM),

              // Email
              _buildTextField(
                label: 'Email',
                controller: _emailController,
                icon: CupertinoIcons.mail_solid,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppConstants.paddingM),

              // Phone
              _buildTextField(
                label: 'Số điện thoại',
                controller: _phoneController,
                icon: CupertinoIcons.phone_fill,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppConstants.paddingM),

              // Address
              _buildTextField(
                label: 'Địa chỉ',
                controller: _addressController,
                icon: CupertinoIcons.location_solid,
                maxLines: 2,
              ),
              const SizedBox(height: AppConstants.paddingM),

              // Date of Birth
              _buildDatePicker(),
              const SizedBox(height: AppConstants.paddingM),

              // Gender
              _buildPicker(
                label: 'Giới tính',
                icon: CupertinoIcons.person_2_fill,
                value: _selectedGender,
                options: _genders,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: AppConstants.paddingM),

              // Blood Type
              _buildPicker(
                label: 'Nhóm máu',
                icon: CupertinoIcons.heart_fill,
                value: _selectedBloodType,
                options: _bloodTypes,
                onChanged: (value) {
                  setState(() {
                    _selectedBloodType = value;
                  });
                },
              ),
              const SizedBox(height: AppConstants.paddingM),

              // Medical History
              _buildMedicalHistorySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tiền sử bệnh',
              style: TextStyle(
                fontSize: AppConstants.fontM,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _addMedicalHistory,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.add_circled,
                    color: AppColors.primary,
                    size: AppConstants.iconM,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Thêm',
                    style: TextStyle(
                      fontSize: AppConstants.fontM,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingS),
        if (_medicalHistory.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'Chưa có tiền sử bệnh',
              style: TextStyle(
                fontSize: AppConstants.fontM,
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          ..._medicalHistory.asMap().entries.map((entry) {
            final index = entry.key;
            final history = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: AppConstants.paddingS),
              padding: const EdgeInsets.all(AppConstants.paddingM),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      history,
                      style: const TextStyle(
                        fontSize: AppConstants.fontM,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        _medicalHistory.removeAt(index);
                      });
                    },
                    child: const Icon(
                      CupertinoIcons.delete,
                      color: AppColors.error,
                      size: AppConstants.iconM,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  void _addMedicalHistory() {
    final controller = TextEditingController();
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Thêm tiền sử bệnh'),
        content: Padding(
          padding: const EdgeInsets.only(top: AppConstants.paddingM),
          child: CupertinoTextField(
            controller: controller,
            placeholder: 'Nhập tiền sử bệnh',
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(color: AppColors.border),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _medicalHistory.add(controller.text.trim());
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppConstants.fontM,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingS),
        CupertinoTextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          padding: const EdgeInsets.all(AppConstants.paddingM),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            border: Border.all(color: AppColors.border),
          ),
          placeholder: 'Nhập $label',
          prefix: Padding(
            padding: const EdgeInsets.only(left: AppConstants.paddingM),
            child: Icon(icon, color: AppColors.primary, size: AppConstants.iconM),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ngày sinh',
          style: TextStyle(
            fontSize: AppConstants.fontM,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingS),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.calendar,
                  color: AppColors.primary,
                  size: AppConstants.iconM,
                ),
                const SizedBox(width: AppConstants.paddingM),
                Text(
                  Formatters.formatDate(_selectedDate),
                  style: const TextStyle(
                    fontSize: AppConstants.fontM,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                const Icon(
                  CupertinoIcons.chevron_right,
                  color: AppColors.textTertiary,
                  size: AppConstants.iconS,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPicker({
    required String label,
    required IconData icon,
    required String value,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppConstants.fontM,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingS),
        GestureDetector(
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) => CupertinoActionSheet(
                title: Text('Chọn $label'),
                actions: options.map((option) {
                  return CupertinoActionSheetAction(
                    onPressed: () {
                      onChanged(option);
                      Navigator.pop(context);
                    },
                    child: Text(
                      option,
                      style: TextStyle(
                        color: option == value
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: option == value
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: AppConstants.iconM),
                const SizedBox(width: AppConstants.paddingM),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: AppConstants.fontM,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                const Icon(
                  CupertinoIcons.chevron_right,
                  color: AppColors.textTertiary,
                  size: AppConstants.iconS,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

