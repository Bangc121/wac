import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ChurchSearchPage extends StatefulWidget {
  const ChurchSearchPage({super.key});

  @override
  State<ChurchSearchPage> createState() => _ChurchSearchPageState();
}

class _ChurchSearchPageState extends State<ChurchSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedTabIndex = 0; // 0: 교회 이름찾기, 1: 근처 교회찾기
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 페이지 열리면 자동으로 키보드 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        '교회검색',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 28), // 균형을 위한 공간
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 탭 버튼
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _selectedTabIndex == 0
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '교회 이름찾기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: _selectedTabIndex == 0
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: _selectedTabIndex == 0
                                  ? Colors.black
                                  : Colors.grey[500],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _selectedTabIndex == 1
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '근처 교회찾기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: _selectedTabIndex == 1
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: _selectedTabIndex == 1
                                  ? Colors.black
                                  : Colors.grey[500],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 검색 입력 필드
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: _selectedTabIndex == 0
                    ? '교회를 찾아보세요'
                    : '지역을 입력하세요',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
                onChanged: (value) {
                  // 검색 로직
                },
              ),
            ),

            // 검색 결과 영역
            Expanded(
              child: Center(
                child: _searchController.text.isEmpty
                    ? Text(
                        _selectedTabIndex == 0
                          ? '교회 이름을 검색해보세요'
                          : '근처 교회를 찾아보세요',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: 0, // 검색 결과 개수
                        itemBuilder: (context, index) {
                          return Container(); // 검색 결과 아이템
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}