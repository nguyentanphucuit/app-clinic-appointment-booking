import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../main.dart';
import '../providers/user_provider.dart';
import '../providers/appointment_provider.dart';
import '../services/firestore_service.dart';
import '../models/user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // Validation
    if (_nameController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập họ tên');
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập email');
      return;
    }

    if (!_emailController.text.trim().contains('@')) {
      _showErrorDialog('Email không hợp lệ');
      return;
    }

    if (_passwordController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập mật khẩu');
      return;
    }

    if (_passwordController.text.trim().length < 6) {
      _showErrorDialog('Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập số điện thoại');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final firestore = FirestoreService.instance;
      
      // Kiểm tra email đã tồn tại chưa
      final existingUser = await firestore.getUserByEmail(_emailController.text.trim());
      if (existingUser != null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog('Email này đã được sử dụng');
        }
        return;
      }

      // Tạo user mới
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(), // Lưu mật khẩu
        phone: _phoneController.text.trim(),
        avatar: 'https://i.pravatar.cc/150?img=${DateTime.now().millisecondsSinceEpoch % 70}',
        dateOfBirth: DateTime(1990, 1, 1), // Default date, có thể chỉnh sau
        gender: 'Nam', // Default, có thể chỉnh sau
        bloodType: 'O+', // Default, có thể chỉnh sau
        address: '', // Có thể để trống, chỉnh sau
        medicalHistory: [],
      );

      // Lưu vào Firestore
      await firestore.createUser(newUser);

      // Cập nhật vào UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateUser(newUser);

      setState(() {
        _isLoading = false;
      });

      // Load appointments của user sau khi đăng ký (sẽ rỗng lúc đầu)
      // Làm trong try-catch riêng để không ảnh hưởng đến navigation
      try {
        final appointmentProvider = Provider.of<AppointmentProvider>(
          context,
          listen: false,
        );
        appointmentProvider.setUserProvider(userProvider);
        await appointmentProvider.loadAppointments();
      } catch (e) {
        // Ignore lỗi khi load appointments, user mới sẽ không có appointments
        print('Error loading appointments: $e');
      }

      // Navigate to home screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Lỗi đăng ký: ${e.toString()}');
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Đăng ký',
          style: TextStyle(
            fontSize: AppConstants.fontL,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Welcome Text
                const Text(
                  'Tạo tài khoản mới',
                  style: TextStyle(
                    fontSize: AppConstants.fontXXL,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingS),
                const Text(
                  'Điền thông tin để đăng ký',
                  style: TextStyle(
                    fontSize: AppConstants.fontM,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingXL),

                // Name Field
                CupertinoTextField(
                  controller: _nameController,
                  placeholder: 'Họ tên',
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    border: Border.all(color: AppColors.border),
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: AppConstants.paddingM),
                    child: Icon(
                      CupertinoIcons.person_fill,
                      color: AppColors.primary,
                      size: AppConstants.iconM,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),

                // Email Field
                CupertinoTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  placeholder: 'Email',
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    border: Border.all(color: AppColors.border),
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: AppConstants.paddingM),
                    child: Icon(
                      CupertinoIcons.mail,
                      color: AppColors.primary,
                      size: AppConstants.iconM,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),

                // Phone Field
                CupertinoTextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  placeholder: 'Số điện thoại',
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    border: Border.all(color: AppColors.border),
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: AppConstants.paddingM),
                    child: Icon(
                      CupertinoIcons.phone_fill,
                      color: AppColors.primary,
                      size: AppConstants.iconM,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),

                // Password Field
                CupertinoTextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  placeholder: 'Mật khẩu',
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    border: Border.all(color: AppColors.border),
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: AppConstants.paddingM),
                    child: Icon(
                      CupertinoIcons.lock,
                      color: AppColors.primary,
                      size: AppConstants.iconM,
                    ),
                  ),
                  suffix: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isPasswordVisible
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye,
                      color: AppColors.textTertiary,
                      size: AppConstants.iconM,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingXL),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingM,
                    ),
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    onPressed: _isLoading ? null : _handleSignUp,
                    child: _isLoading
                        ? const CupertinoActivityIndicator(
                            color: AppColors.textOnPrimary,
                          )
                        : const Text(
                            'Đăng ký',
                            style: TextStyle(
                              fontSize: AppConstants.fontL,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingL),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Đã có tài khoản? ',
                      style: TextStyle(
                        fontSize: AppConstants.fontM,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          fontSize: AppConstants.fontM,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.paddingXL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

