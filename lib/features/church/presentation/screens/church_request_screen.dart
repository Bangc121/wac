import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ChurchRequestScreen extends StatefulWidget {
  const ChurchRequestScreen({super.key});

  @override
  State<ChurchRequestScreen> createState() => _ChurchRequestScreenState();
}

class _ChurchRequestScreenState extends State<ChurchRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _pastorController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _pastorController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('교회 등록 신청이 완료되었습니다.')));
      // Navigate back or home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '교회검색',
          style: AppTextStyles.bodyLarge,
        ), // Title stays '교회검색' as per design 761:2211
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '검색 결과가 없습니다.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D40), // Dark Teal
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '찾으시는 교회가 검색되지 않는 경우 교회 정보를 입\n력해주시면 빠른 시일 내 검토 후 반영해드리도록 하\n겠습니다.',
                  style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 32),

                _buildTextField(controller: _nameController, hint: '교회명'),
                const SizedBox(height: 16),
                _buildTextField(controller: _addressController, hint: '교회주소'),
                const SizedBox(height: 16),
                _buildTextField(controller: _pastorController, hint: '담임목사'),

                const SizedBox(height: 32),
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
                  child: const Text('제출하기', style: AppTextStyles.labelLarge),
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
  }) {
    return TextFormField(
      controller: controller,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hint을(를) 입력해주세요';
        }
        return null;
      },
    );
  }
}
