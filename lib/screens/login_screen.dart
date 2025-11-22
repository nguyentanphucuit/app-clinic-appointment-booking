import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../main.dart';
import '../providers/user_provider.dart';
import '../providers/appointment_provider.dart';
import '../services/firestore_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập email');
      return;
    }

    if (_passwordController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập mật khẩu');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Kiểm tra user trong Firestore theo email
      final firestore = FirestoreService.instance;
      final user = await firestore.getUserByEmail(_emailController.text.trim());

      if (user == null) {
        // Không tìm thấy user, hiển thị lỗi
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog('Email không tồn tại trong hệ thống');
        }
        return;
      }

      // Kiểm tra mật khẩu
      if (user.password != _passwordController.text.trim()) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog('Mật khẩu không đúng');
        }
        return;
      }

      // Tìm thấy user và mật khẩu đúng, cập nhật vào UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateUser(user);

      // Load appointments của user sau khi login
      final appointmentProvider = Provider.of<AppointmentProvider>(
        context,
        listen: false,
      );
      appointmentProvider.setUserProvider(userProvider);
      await appointmentProvider.loadAppointments();

      setState(() {
        _isLoading = false;
      });

      // Navigate to home screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      }
    } catch (e) {
      // Xử lý lỗi
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Lỗi kết nối: ${e.toString()}');
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
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingXL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Logo/Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.heart_fill,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingXL),

                // Welcome Text
                const Text(
                  'Chào mừng trở lại',
                  style: TextStyle(
                    fontSize: AppConstants.fontXXL,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingS),
                const Text(
                  'Đăng nhập để tiếp tục',
                  style: TextStyle(
                    fontSize: AppConstants.fontM,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingXL),

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
                const SizedBox(height: AppConstants.paddingM),

                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _rememberMe = !_rememberMe;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _rememberMe
                                  ? AppColors.primary
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _rememberMe
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: _rememberMe
                                ? const Icon(
                                    CupertinoIcons.check_mark,
                                    size: 14,
                                    color: AppColors.textOnPrimary,
                                  )
                                : null,
                          ),
                          const SizedBox(width: AppConstants.paddingS),
                          const Text(
                            'Ghi nhớ đăng nhập',
                            style: TextStyle(
                              fontSize: AppConstants.fontS,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // Navigate to forgot password
                      },
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(
                          fontSize: AppConstants.fontS,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingXL),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingM,
                    ),
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const CupertinoActivityIndicator(
                            color: AppColors.textOnPrimary,
                          )
                        : const Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: AppConstants.fontL,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingL),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Chưa có tài khoản? ',
                      style: TextStyle(
                        fontSize: AppConstants.fontM,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Đăng ký',
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

