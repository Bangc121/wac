import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  // Terms Checkbox States
  bool _isAllTermsAccepted = false;
  bool _isTermsAccepted = false;
  bool _isPrivacyAccepted = false;
  bool _isPushAccepted = false;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (!_isTermsAccepted || !_isPrivacyAccepted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('필수 약관에 동의해주세요')));
        return;
      }
      // TODO: Implement actual sign up logic
      context.go('/welcome');
    }
  }

  void _toggleAllTerms(bool? value) {
    setState(() {
      _isAllTermsAccepted = value ?? false;
      _isTermsAccepted = _isAllTermsAccepted;
      _isPrivacyAccepted = _isAllTermsAccepted;
      _isPushAccepted = _isAllTermsAccepted;
    });
  }

  void _updateAllTermsState() {
    setState(() {
      _isAllTermsAccepted =
          _isTermsAccepted && _isPrivacyAccepted && _isPushAccepted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'We Are Church\n우리는 모두 교회입니다.',
          style: AppTextStyles.displayMedium,
        ), // Using TextStyles roughly matching the header
        centerTitle: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        toolbarHeight: 80,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                // ID Field with Duplicate Check
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '아이디를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement duplicate check
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('사용 가능한 아이디입니다')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('중복확인'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Password Fields
                _buildTextField(
                  controller: _passwordController,
                  hint: '비밀번호 (영문,숫자,특수문자 조합 8자리 이상)',
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _passwordConfirmController,
                  hint: '비밀번호 확인',
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return '비밀번호가 일치하지 않습니다';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Terms of Service
                const Text(
                  '서비스 이용을 위해 아래 내용에 동의해 주세요.',
                  style: AppTextStyles.bodyLarge, // Adjust style as needed
                ),
                const SizedBox(height: 16),
                _buildCheckboxRow(
                  title: '전체동의',
                  value: _isAllTermsAccepted,
                  onChanged: _toggleAllTerms,
                  isMain: true,
                ),
                _buildCheckboxRow(
                  title: '이용약관 동의(필수)',
                  value: _isTermsAccepted,
                  onChanged: (value) {
                    setState(() {
                      _isTermsAccepted = value ?? false;
                      _updateAllTermsState();
                    });
                  },
                ),
                _buildCheckboxRow(
                  title: '개인정보 수집 및 이용에 대한 동의 (필수)',
                  value: _isPrivacyAccepted,
                  onChanged: (value) {
                    setState(() {
                      _isPrivacyAccepted = value ?? false;
                      _updateAllTermsState();
                    });
                  },
                ),
                _buildCheckboxRow(
                  title: '알림을 위한 앱 푸시 (선택)',
                  value: _isPushAccepted,
                  onChanged: (value) {
                    setState(() {
                      _isPushAccepted = value ?? false;
                      _updateAllTermsState();
                    });
                  },
                ),

                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('회원가입', style: AppTextStyles.labelLarge),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return '필수 입력 항목입니다'; // Simplified validator
            }
            return null;
          },
    );
  }

  Widget _buildCheckboxRow({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    bool isMain = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: AppColors.primary,
              side: const BorderSide(
                color: Colors.grey,
              ), // Customize border color
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: isMain
                ? AppTextStyles.bodyLarge
                : AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
          ),
        ],
      ),
    );
  }
}
