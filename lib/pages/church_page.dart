import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'church_search_page.dart';

class ChurchPage extends StatefulWidget {
  const ChurchPage({super.key});

  @override
  State<ChurchPage> createState() => _ChurchPageState();
}

class _ChurchPageState extends State<ChurchPage> {
  // 탭 선택 상태
  int _selectedTabIndex = 0;

  // Drawer 표시 상태
  bool _isDrawerOpen = false;

  // 필터 선택
  String _selectedRegion = '서울시';
  String _selectedSubRegion = '서초구';

  // 교회 데이터
  final List<Map<String, dynamic>> churches = [
    {
      'name': '분당우리교회',
      'address': '대한예수교장로회(합동)',
      'location': '경기도 성남시 분당구 미애동 378',
      'image': 'church1.jpg',
    },
    {
      'name': '서현교회',
      'address': '대한예수교장로회(합동)',
      'location': '서울특별시 마포구 잔다리로7길 31',
      'image': 'church2.jpg',
    },
    {
      'name': '행복교회',
      'address': '대한예수교장로회(합동)',
      'location': '경기도 성남시 분당구 미애동 378',
      'image': 'church3.jpg',
    },
    {
      'name': '마음사랑교회',
      'address': '대한예수교장로회(합동)',
      'location': '서울특별시 강남구 논현로 123',
      'image': 'church4.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
        child: Column(
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showFullScreenDrawer();
                    },
                    child: const Icon(Icons.menu, size: 24),
                  ),
                  const Spacer(),
                  const Icon(Icons.search, size: 24),
                  const SizedBox(width: 16),
                  const Icon(Icons.notifications_outlined, size: 24),
                ],
              ),
            ),

            // 타이틀 섹션
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '써니님만의',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '소속 교회',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const Text(
                        '를 찾아보세요.',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '아직 소속된 교회가 없습니다. 교회 검색을 통해\n다양한 교회 게시판을 둘러보세요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 액션 버튼들
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                '새신자 상태',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '게시글 열람만 가능',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                '소속 교회 등록',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '게시글 작성/댓글 가능',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 교회 찾기 섹션
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '교회 찾기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.more_horiz, color: Colors.grey[600]),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 필터 버튼들
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _selectedRegion,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_drop_down, color: Colors.grey[600], size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _selectedSubRegion,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_drop_down, color: Colors.grey[600], size: 20),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.filter_list, color: Colors.grey[600]),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 교회 리스트
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: churches.length,
                itemBuilder: (context, index) {
                  final church = churches[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        // 교회 이미지
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.church,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 교회 정보
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                church['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                church['address'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                church['location'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }

  void _showFullScreenDrawer() {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => _buildFullScreenDrawer(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        opaque: true,
      ),
    );
  }

  Widget _buildFullScreenDrawer() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            // 상단 흰색 헤더 영역
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 메뉴 아이템들
            _buildDrawerItem('교회검색'),
            _buildDrawerItem('교단소개'),
            _buildDrawerItem('기독교 역사'),
            _buildDrawerItem('교회 추가 신청'),
            _buildDrawerItem('교역자 인증'),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String title) {
    return InkWell(
      onTap: () {
        // 메뉴 아이템 클릭 처리
        Navigator.of(context).pop();

        if (title == '교회검색') {
          // 교회검색 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChurchSearchPage(),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}