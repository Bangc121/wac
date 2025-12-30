import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAutoLogin = false;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            height:
                MediaQuery.of(context).size.height -
                48, // Adjust for SafeArea padding
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  // Header
                  const Text(
                    'We Are Church',
                    style: AppTextStyles.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '우리는 모두 교회입니다.',
                    style: AppTextStyles.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 1),

                  // Inputs
                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      hintText: '아이디',
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: '비밀번호',
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),

                  // Auto Login Checkbox
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _isAutoLogin,
                          onChanged: (value) {
                            setState(() {
                              _isAutoLogin = value ?? false;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          activeColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('자동로그인', style: AppTextStyles.bodyLarge),
                    ],
                  ),

                  // Login Button
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('로그인', style: AppTextStyles.labelLarge),
                  ),

                  // Find Links
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTextLink(context, '회원가입', '/signup'),
                      _buildDivider(),
                      _buildTextLink(context, '아이디 찾기', '/find_id'),
                      _buildDivider(),
                      _buildTextLink(context, '비밀번호 찾기', '/find_password'),
                    ],
                  ),

                  const Spacer(flex: 2),
                  // Social Login
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('간편로그인', style: AppTextStyles.bodyLarge),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSocialButton(
                          label: '카카오톡으로 시작',
                          color: AppColors.kakao,
                          textColor: Colors.black, // Kakao uses black text
                          icon: Icons.chat_bubble, // Placeholder
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSocialButton(
                          label: '네이버로 시작',
                          color: AppColors.naver,
                          textColor: Colors.white,
                          icon: Icons.square, // Placeholder
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextLink(BuildContext context, String text, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Text(text, style: AppTextStyles.link),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: 1,
      height: 12,
      color: AppColors.border,
    );
  }

  Widget _buildSocialButton({
    required String label,
    required Color color,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      height: 50, // Fixed height for alignment
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: textColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
