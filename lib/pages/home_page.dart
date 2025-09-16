import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'post_detail_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['전체', '주제별', '지역별'];

  // 주제별 필터 옵션
  final List<String> _topicFilters = ['전체', '우리교회', '간증', '고민상담'];
  String _selectedTopicFilter = '전체';

  // 지역별 필터 옵션
  String _selectedRegion = '서울시';
  String _selectedSubRegion = '서초구';

  // 드롭다운 표시 상태
  bool _showTopicDropdown = false;
  bool _showRegionDropdown = false;

  // 게시글 데이터
  final List<Map<String, dynamic>> _allPosts = [
    {
      'username': 'helloman',
      'school': '행복한교회',
      'timeAgo': '8분 전',
      'category': '우리교회',
      'title': '교회 사람들과 거리 두고 싶은 마음',
      'content': '교회에서 만나는 사람들은 좋지만, 때로 너무 사적인 얘기까지 물어보거나 기대를 해서 부담스러울 때가 있어요..그냥 편하게 신앙생활 하고 싶은데... 다들 이런 경험 없으신가요?',
      'likes': '좋아요',
      'comments': '댓글',
      'views': '조회수',
      'region': '서울시',
      'subRegion': '서초구',
    },
    {
      'username': 'helloman',
      'school': '은혜감리교회',
      'timeAgo': '36분 전',
      'category': '고민상담',
      'title': '믿음 좋은 척, 솔직히 지치지 않나요?',
      'content': '솔직히 요즘 주일 예배드 가기 싫고, 믿음도 잘 안 들어와요..주변에선 다들 은혜 받았다고 하는데, 나는 왜 이렇게 공허하기만 한지 모르겠어요..혹시 저만 이런가요? 같은 고민 있으신 분들 얘기...',
      'likes': '68',
      'comments': '48',
      'views': '384',
      'region': '서울시',
      'subRegion': '강남구',
    },
    {
      'username': 'anonymous',
      'school': '소망교회',
      'timeAgo': '1시간 전',
      'category': '고민상담',
      'title': '기도 응답 받으신 분들 계신가요?',
      'content': '정말 간절히 기도하고 있는데 응답이 없는 것 같아요. 다른 분들은 어떻게 기도하시나요? 기도 응답 경험 있으신 분들 조언 부탁드려요.',
      'likes': '45',
      'comments': '32',
      'views': '256',
      'region': '경기도',
      'subRegion': '성남시',
    },
    {
      'username': 'believer',
      'school': '평안교회',
      'timeAgo': '2시간 전',
      'category': '간증',
      'title': '교회 봉사, 의무감으로 하게 되는 것 같아요',
      'content': '처음엔 기쁜 마음으로 시작했는데 이제는 의무감으로 하게 되는 것 같아요. 봉사를 그만두고 싶은데 주변 시선이 신경 쓰입니다.',
      'likes': '89',
      'comments': '56',
      'views': '512',
      'region': '서울시',
      'subRegion': '서초구',
    },
    {
      'username': 'seeker',
      'school': '빛과소금교회',
      'timeAgo': '3시간 전',
      'category': '우리교회',
      'title': '성경 읽기가 너무 어려워요',
      'content': '성경을 읽으려고 하는데 너무 어렵고 이해가 안 돼요. 어떻게 하면 성경을 잘 읽을 수 있을까요? 추천하는 방법이나 순서가 있나요?',
      'likes': '34',
      'comments': '28',
      'views': '198',
      'region': '인천시',
      'subRegion': '부평구',
    },
    {
      'username': 'grace',
      'school': '샘물교회',
      'timeAgo': '4시간 전',
      'category': '간증',
      'title': '하나님의 은혜로 회복되었습니다',
      'content': '우울증과 불안으로 힘들었는데, 기도와 교회 공동체의 사랑으로 회복되었어요. 아직 완전하진 않지만 매일 나아지고 있습니다.',
      'likes': '126',
      'comments': '89',
      'views': '892',
      'region': '서울시',
      'subRegion': '서초구',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: SizedBox(
        width: 44,
        height: 44,
        child: FloatingActionButton(
          onPressed: () {
            _showWriteBottomSheet(context);
          },
          backgroundColor: AppColors.primaryGreen,
          shape: const CircleBorder(),
          child: const Icon(Icons.edit, color: Colors.white, size: 24), // 아이콘 크기도 조절 가능
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 170,
            pinned: true,
            backgroundColor: AppColors.primaryGreen,
            toolbarHeight: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: _tabs.map((tab) {
                        int index = _tabs.indexOf(tab);
                        bool isSelected = index == _selectedTabIndex;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTabIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 20),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              tab,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white, size: 24),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SearchPage()),
                            );
                          },
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '써니님,',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '환영합니다!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // 필터 버튼 추가
                  if (_selectedTabIndex != 0) // 전체 탭이 아닐 때만 필터 표시
                    _buildFilterSection(),
                  ..._getFilteredPosts(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedItem({
    required String username,
    required String school,
    required String timeAgo,
    required String category,
    required String title,
    required String content,
    required String likes,
    required String comments,
    required String views,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailPage(
              username: username,
              school: school,
              timeAgo: timeAgo,
              category: category,
              title: title,
              content: content,
              likes: likes,
              comments: comments,
              views: views,
            ),
          ),
        );
      },
      child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$school · $timeAgo',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (category.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildActionButton(Icons.favorite_border, likes),
              const SizedBox(width: 16),
              _buildActionButton(Icons.chat_bubble_outline, comments),
              const SizedBox(width: 16),
              _buildActionButton(Icons.visibility_outlined, views),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // 필터링된 게시글 가져오기
  List<Widget> _getFilteredPosts() {
    List<Map<String, dynamic>> filteredPosts = _allPosts;

    // 주제별 필터링
    if (_selectedTabIndex == 1 && _selectedTopicFilter != '전체') {
      filteredPosts = filteredPosts.where((post) {
        return post['category'] == _selectedTopicFilter;
      }).toList();
    }

    // 지역별 필터링
    if (_selectedTabIndex == 2) {
      filteredPosts = filteredPosts.where((post) {
        return post['region'] == _selectedRegion &&
               post['subRegion'] == _selectedSubRegion;
      }).toList();
    }

    // 필터링된 게시글을 위젯으로 변환
    return filteredPosts.map((post) {
      return _buildFeedItem(
        username: post['username'],
        school: post['school'],
        timeAgo: post['timeAgo'],
        category: post['category'] ?? '',
        title: post['title'],
        content: post['content'],
        likes: post['likes'],
        comments: post['comments'],
        views: post['views'],
      );
    }).toList();
  }

  // 필터 섹션 빌드
  Widget _buildFilterSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (_selectedTabIndex == 1) // 주제별 탭
                _buildTopicFilterButtons()
              else if (_selectedTabIndex == 2) // 지역별 탭
                _buildRegionFilterButtons(),
            ],
          ),
        ),
        // 드롭다운 메뉴
        if (_showTopicDropdown && _selectedTabIndex == 1)
          _buildTopicDropdown(),
        if (_showRegionDropdown && _selectedTabIndex == 2)
          _buildRegionDropdown(),
      ],
    );
  }

  // 주제별 필터 버튼
  Widget _buildTopicFilterButtons() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _topicFilters.map((filter) {
            bool isSelected = filter == _selectedTopicFilter;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTopicFilter = filter;
                  _showTopicDropdown = false;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryGreen : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryGreen : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // 지역별 필터 버튼
  Widget _buildRegionFilterButtons() {
    return Expanded(
      child: Row(
        children: [
          // 첫 번째 드롭다운 (시/도)
          GestureDetector(
            onTap: () {
              setState(() {
                _showRegionDropdown = !_showRegionDropdown;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Text(
                    _selectedRegion,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _showRegionDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 두 번째 드롭다운 (구/군)
          GestureDetector(
            onTap: () {
              setState(() {
                _showRegionDropdown = !_showRegionDropdown;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Text(
                    _selectedSubRegion,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _showRegionDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 주제별 드롭다운 메뉴
  Widget _buildTopicDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: _topicFilters.map((filter) {
          return InkWell(
            onTap: () {
              setState(() {
                _selectedTopicFilter = filter;
                _showTopicDropdown = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    filter,
                    style: TextStyle(
                      color: _selectedTopicFilter == filter
                          ? AppColors.primaryGreen
                          : Colors.grey[700],
                      fontSize: 14,
                      fontWeight: _selectedTopicFilter == filter
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  if (_selectedTopicFilter == filter)
                    Icon(
                      Icons.check,
                      color: AppColors.primaryGreen,
                      size: 18,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 지역별 드롭다운 메뉴
  Widget _buildRegionDropdown() {
    List<String> regions = ['서울시', '경기도', '인천시', '부산시', '대구시', '광주시', '대전시', '울산시'];
    List<String> subRegions = ['서초구', '강남구', '송파구', '강동구', '강서구', '마포구', '종로구', '중구'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 시/도 선택
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Column(
                children: regions.map((region) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedRegion = region;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: _selectedRegion == region
                          ? Colors.grey[100]
                          : Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            region,
                            style: TextStyle(
                              color: _selectedRegion == region
                                  ? AppColors.primaryGreen
                                  : Colors.grey[700],
                              fontSize: 14,
                              fontWeight: _selectedRegion == region
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // 구/군 선택
          Expanded(
            child: Column(
              children: subRegions.map((subRegion) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedSubRegion = subRegion;
                      _showRegionDropdown = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: _selectedSubRegion == subRegion
                        ? Colors.grey[100]
                        : Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subRegion,
                          style: TextStyle(
                            color: _selectedSubRegion == subRegion
                                ? AppColors.primaryGreen
                                : Colors.grey[700],
                            fontSize: 14,
                            fontWeight: _selectedSubRegion == subRegion
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 글쓰기 바텀시트 표시
  void _showWriteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const WriteBottomSheet(),
    );
  }
}

// 글쓰기 바텀시트 위젯
class WriteBottomSheet extends StatefulWidget {
  const WriteBottomSheet({super.key});

  @override
  State<WriteBottomSheet> createState() => _WriteBottomSheetState();
}

class _WriteBottomSheetState extends State<WriteBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // 설문 관련 컨트롤러
  final TextEditingController _pollQuestion1Controller = TextEditingController();
  final TextEditingController _pollQuestion2Controller = TextEditingController();
  final TextEditingController _pollQuestion3Controller = TextEditingController();

  // 탭 선택 상태
  int _selectedTabIndex = 0; // 0: 게시글, 1: 설문

  // 주제 선택
  String? _selectedTopic;
  final List<String> _topics = [
    '자유주제',
    '성경말씀',
    '교회',
    '간증',
    '고민상담',
    '이벤트',
  ];

  // 설문 옵션
  bool _allowMultipleAnswers = false;

  // 드롭다운 오버레이
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    _overlayEntry?.remove();
    _titleController.dispose();
    _contentController.dispose();
    _pollQuestion1Controller.dispose();
    _pollQuestion2Controller.dispose();
    _pollQuestion3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 핸들 바
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 헤더
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                const Text(
                  '글쓰기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 24),
                ),
              ],
            ),
          ),
          // 탭 선택
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildTabButton('게시글', 0),
                const SizedBox(width: 16),
                _buildTabButton('설문', 1),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 컨텐츠 영역
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _selectedTabIndex == 0
                  ? _buildPostContent()
                  : _buildPollContent(),
            ),
          ),
          // 하단 버튼
          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: keyboardHeight > 0 ? 16 : 32,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '임시저장',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 등록 처리
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '등록하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPostContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 주제 선택 - 커스텀 드롭다운 (항상 아래로)
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: () {
              if (_overlayEntry == null) {
                _showDropdown();
              } else {
                _hideDropdown();
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _overlayEntry != null
                    ? AppColors.primaryGreen
                    : (_selectedTopic != null ? AppColors.primaryGreen.withOpacity(0.3) : Colors.transparent),
                  width: _overlayEntry != null ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTopic ?? '주제를 선택해주세요',
                    style: TextStyle(
                      color: _selectedTopic != null ? Colors.black87 : Colors.grey[500],
                      fontSize: 16,
                      fontWeight: _selectedTopic != null ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _overlayEntry != null ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _overlayEntry != null ? AppColors.primaryGreen : Colors.grey[600],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 제목 입력
        TextField(
          controller: _titleController,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: '제목',
            hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          maxLines: null,
        ),

        const Divider(height: 32),

        // 내용 입력
        TextField(
          controller: _contentController,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
          decoration: InputDecoration(
            hintText: '여기에 글을 작성해주세요.',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          maxLines: null,
          minLines: 10,
        ),
      ],
    );
  }

  Widget _buildPollContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 설문 항목들
        _buildPollOption(_pollQuestion1Controller, '항목입력'),
        const SizedBox(height: 12),
        _buildPollOption(_pollQuestion2Controller, '항목입력'),
        const SizedBox(height: 12),
        _buildPollOption(_pollQuestion3Controller, '항목입력'),

        const SizedBox(height: 24),

        // 항목 추가 버튼과 복수응답 허용을 같은 줄에
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _allowMultipleAnswers,
                  onChanged: (bool? value) {
                    setState(() {
                      _allowMultipleAnswers = value ?? false;
                    });
                  },
                  activeColor: AppColors.primaryGreen,
                  shape: const CircleBorder(),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Text(
                  '복수응답허용',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
             TextButton.icon(
              onPressed: () {
                // 항목 추가 로직
              },
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                '항목추가하기',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),

        const SizedBox(height: 50), // 하단 여백
      ],
    );
  }

  Widget _buildPollOption(TextEditingController controller, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  void _showDropdown() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 40,
        child: CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 8),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _topics.map((topic) {
                    final isSelected = topic == _selectedTopic;
                    final isLast = topic == _topics.last;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedTopic = topic;
                        });
                        _hideDropdown();
                      },
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryGreen.withOpacity(0.05) : Colors.white,
                          border: !isLast ? Border(
                            bottom: BorderSide(
                              color: Colors.grey[200]!,
                              width: 0.5,
                            ),
                          ) : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              topic,
                              style: TextStyle(
                                fontSize: 15,
                                color: isSelected ? AppColors.primaryGreen : Colors.black87,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_rounded,
                                color: AppColors.primaryGreen,
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
    setState(() {});
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }
}