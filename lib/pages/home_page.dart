import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'write_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: SizedBox(
        width: 44,  
        height: 44, 
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WritePage()),
            );
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
                  _buildFeedItem(
                    username: 'helloman',
                    school: '행복한교회',
                    timeAgo: '8분 전',
                    category: '인기',
                    title: '교회 사람들과 거리 두고 싶은 마음',
                    content: '교회에서 만나는 사람들은 좋지만, 때로 너무 사적인 얘기까지 물어보거나 기대를 해서 부담스러울 때가 있어요..그냥 편하게 신앙생활 하고 싶은데... 다들 이런 경험 없으신가요?',
                    likes: '좋아요',
                    comments: '댓글',
                    views: '조회수',
                  ),
                  _buildFeedItem(
                    username: 'helloman',
                    school: '은혜감리교회',
                    timeAgo: '36분 전',
                    category: '',
                    title: '믿음 좋은 척, 솔직히 지치지 않나요?',
                    content: '솔직히 요즘 주일 예배드 가기 싫고, 믿음도 잘 안 들어와요..주변에선 다들 은혜 받았다고 하는데, 나는 왜 이렇게 공허하기만 한지 모르겠어요..혹시 저만 이런가요? 같은 고민 있으신 분들 얘기...',
                    likes: '68',
                    comments: '48',
                    views: '384',
                  ),
                  _buildFeedItem(
                    username: 'anonymous',
                    school: '소망교회',
                    timeAgo: '1시간 전',
                    category: '',
                    title: '기도 응답 받으신 분들 계신가요?',
                    content: '정말 간절히 기도하고 있는데 응답이 없는 것 같아요. 다른 분들은 어떻게 기도하시나요? 기도 응답 경험 있으신 분들 조언 부탁드려요.',
                    likes: '45',
                    comments: '32',
                    views: '256',
                  ),
                  _buildFeedItem(
                    username: 'believer',
                    school: '평안교회',
                    timeAgo: '2시간 전',
                    category: '인기',
                    title: '교회 봉사, 의무감으로 하게 되는 것 같아요',
                    content: '처음엔 기쁜 마음으로 시작했는데 이제는 의무감으로 하게 되는 것 같아요. 봉사를 그만두고 싶은데 주변 시선이 신경 쓰입니다.',
                    likes: '89',
                    comments: '56',
                    views: '512',
                  ),
                  _buildFeedItem(
                    username: 'seeker',
                    school: '빛과소금교회',
                    timeAgo: '3시간 전',
                    category: '',
                    title: '성경 읽기가 너무 어려워요',
                    content: '성경을 읽으려고 하는데 너무 어렵고 이해가 안 돼요. 어떻게 하면 성경을 잘 읽을 수 있을까요? 추천하는 방법이나 순서가 있나요?',
                    likes: '34',
                    comments: '28',
                    views: '198',
                  ),
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
}