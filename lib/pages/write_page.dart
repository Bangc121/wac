import 'package:flutter/material.dart';
import '../constants/colors.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
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

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _pollQuestion1Controller.dispose();
    _pollQuestion2Controller.dispose();
    _pollQuestion3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '글쓰기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 탭 선택
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildTabButton('게시글', 0),
                const SizedBox(width: 16),
                _buildTabButton('설문', 1),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 컨텐츠 영역
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _selectedTabIndex == 0
                    ? _buildPostContent()
                    : _buildPollContent(),
              ),
            ),
          ),
          // 하단 버튼
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
        // 주제 선택 드롭다운
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTopic,
              hint: Text(
                '주제 선택',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
              ),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              items: _topics.map((String topic) {
                return DropdownMenuItem<String>(
                  value: topic,
                  child: Text(
                    topic,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTopic = newValue;
                });
              },
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
          minLines: 15,
        ),
      ],
    );
  }

  Widget _buildPollContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 설문 제목
        TextField(
          controller: _titleController,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: '항목입력',
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

        const SizedBox(height: 24),

        // 설문 항목들
        _buildPollOption(_pollQuestion1Controller, '항목입력'),
        const SizedBox(height: 12),
        _buildPollOption(_pollQuestion2Controller, '항목입력'),
        const SizedBox(height: 12),
        _buildPollOption(_pollQuestion3Controller, '항목입력'),

        const SizedBox(height: 24),

        // 항목 추가 버튼
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
        ),

        const SizedBox(height: 32),

        // 복수응답 허용
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

        const SizedBox(height: 100), // 하단 여백
      ],
    );
  }

  Widget _buildPollOption(TextEditingController controller, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
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
}