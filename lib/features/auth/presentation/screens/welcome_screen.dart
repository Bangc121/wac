import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              const Text(
                'We Are Church\n우리의 교회 공동체가\n되어주셔서 감사하고\n환영합니다!',
                style: AppTextStyles.displayMedium,
              ),
              const SizedBox(height: 32),
              const Text(
                '우리 교회 소식을 빠르게 접하고 게시판에서 자유롭게\n활동하기 위해 섬기는 교회를 등록해주세요.',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '섬기는 교회가 없으시거나 등록하지 않은 경우, 새신\n자로 간주됩니다. 새신자는 여러 교회의 게시판을 탐\n색하고, 나와 잘 맞는 교회를 찾아 섬기는 교회로 선택\n할 수 있습니다. 여러 교회를 탐색할 수 있는 대신 게시\n글의 열람만 가능하고, 게시글 작성 등의 활동은 섬기\n는 교회로 등록 후 가능합니다.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 64),
              ElevatedButton(
                onPressed: () => context.push('/church_search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text('교회등록', style: AppTextStyles.labelLarge),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => context.go('/'), // Go home as New Believer
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '다음에 등록하기 (새신자)',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
