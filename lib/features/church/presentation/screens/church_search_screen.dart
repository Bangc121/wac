import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ChurchSearchScreen extends StatefulWidget {
  const ChurchSearchScreen({super.key});

  @override
  State<ChurchSearchScreen> createState() => _ChurchSearchScreenState();
}

class _ChurchSearchScreenState extends State<ChurchSearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock Data
  final List<Map<String, String>> _allChurches = [
    {
      'name': '분당우리교회',
      'denomination': '대한예수교장로회(합동)',
      'address': '경기도 성남시 분당구 미애동 378',
    },
    {
      'name': '서현교회',
      'denomination': '대한예수교장로회(합동)',
      'address': '서울특별 마포구 잔다리로7길 31',
    },
    {
      'name': '행복교회',
      'denomination': '대한예수교장로회(합동)',
      'address': '경기도 성남시 분당구 미애동 378',
    },
    {
      'name': '마음사랑교회',
      'denomination': '대한예수교장로회(합동)',
      'address': '경기도 성남시 분당구 미애동 378',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('교회검색', style: AppTextStyles.bodyLarge),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.textPrimary,
          labelStyle: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: '교회 이름찾기'),
            Tab(text: '근처 교회찾기'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildNameSearchTab(), _buildNearbySearchTab()],
      ),
    );
  }

  Widget _buildNameSearchTab() {
    final filteredChurches = _searchQuery.isEmpty
        ? []
        : _allChurches
              .where((church) => church['name']!.contains(_searchQuery))
              .toList();

    final showEmptyState = _searchQuery.isNotEmpty && filteredChurches.isEmpty;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '교회를 찾아보세요',
              filled: true,
              fillColor: AppColors.surface,
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ), // Placeholder icon
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (showEmptyState)
            _buildEmptyState()
          else
            Expanded(
              child: ListView.separated(
                itemCount: filteredChurches.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final church = filteredChurches[index];
                  return _buildChurchListItem(church);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNearbySearchTab() {
    return const Center(
      child: Text('지도 뷰 구현 예정', style: AppTextStyles.bodyMedium),
    );
  }

  Widget _buildChurchListItem(Map<String, String> church) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        ), // Placeholder for Image
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                church['name']!,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                church['denomination']!,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                church['address']!,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 24),
        // Form inputs placeholders like in design 761:2211 - wait, 761:2211 is a separate "submit" action often?
        // Ah, the thumbnail 761:2211 shows inputs embedded? Or is it a separate screen?
        // Thumbnail 761:2211 shows inputs: Church Name, Address, Pastor. And a Submit button.
        // It looks like if search fails, it Shows these inputs IN LINE.
        // Let's implement them in line here or link to a separate screen if complex.
        // Thumbnail 761:2211 header says "교회검색". It seems it's the SAME screen, just state change.
        // But implementation plan says "Implement ChurchRequestScreen (Node 761:2211)".
        // I'll put a button "제출하기" that navigates to `ChurchRequestScreen` OR I can implement it in-line.
        // Figma Node 761:2211 seems to be the state *after* empty search where you fill info.
        // I will make it a button to navigate to a dedicated REQUEST screen for cleaner code,
        // OR if the design implies inline, I can do inline.
        // Looking at 761:2211, it has the same "교회검색" header. It looks like the same screen.
        // However, typically "Church Request" is a distinct form.
        // I'll make a button "교회 추가 신청하기" (or just "제출하기" as in design)
        // Wait, design 761:2211 HAS inputs. "교회명", "교회주소", "담임목사". AND "제출하기" button.
        // So I should render these inputs here in the Empty State.
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.push('/church_request'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text('제출하기'),
          ),
        ),
        // Wait, if I navigate to /church_request, that screen should look like 761:2211.
        // So I'll just put the explanation text here and a button "직접 입력하기" or similar?
        // No, design 761:2211 shows the inputs are visible.
        // So I should probably just implement `ChurchRequestScreen` separately and navigate to it?
        // Or show the form here.
        // To stick to the "Screens" plan: I'll make `ChurchRequestScreen` separate and maybe `ChurchSearchScreen` empty state just says "No results" and has a big button "Register New Church".
        // Actually, looking at 761:2211, it has the same header "교회검색". It's likely an *Empty State Mode* of Search Screen.
        // BUT for simplicity and modularity, I'll direct to `/church_request`.
        // The previous design `761:2211` thumbnail shows the inputs `교회명`, `교회주소`, `담임목사`.
        // I will implement `ChurchRequestScreen` matching that node.
      ],
    );
  }
}
