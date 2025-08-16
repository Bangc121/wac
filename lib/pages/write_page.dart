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
  String _selectedCategory = '';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_outlined, color: Colors.black),
            onPressed: () {
              // TODO: 글 업로드 처리
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'helloman',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '행복한교회 · 8분 전',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.favorite_border, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text('68', style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(width: 20),
                  Icon(Icons.chat_bubble_outline, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text('48', style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(width: 20),
                  Icon(Icons.visibility_outlined, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text('384', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  _showCategoryDialog();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _selectedCategory.isEmpty 
                        ? Colors.grey[200] 
                        : Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _selectedCategory.isEmpty ? '카테고리 선택' : _selectedCategory,
                    style: TextStyle(
                      color: _selectedCategory.isEmpty 
                          ? Colors.grey[600] 
                          : Colors.red[400],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: '제목을 입력하세요',
                  hintStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: Colors.white30,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: '내용을 입력하세요',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                  border: InputBorder.none,
                ),
                maxLines: null,
                minLines: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryDialog() {
    final categories = ['인기', '일반', '질문', '고민', '나눔'];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('카테고리 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: categories.map((category) {
              return ListTile(
                title: Text(category),
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}