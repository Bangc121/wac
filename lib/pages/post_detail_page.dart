import 'package:flutter/material.dart';
import '../constants/colors.dart';

class PostDetailPage extends StatefulWidget {
  final String username;
  final String school;
  final String timeAgo;
  final String category;
  final String title;
  final String content;
  final String likes;
  final String comments;
  final String views;

  const PostDetailPage({
    super.key,
    required this.username,
    required this.school,
    required this.timeAgo,
    required this.category,
    required this.title,
    required this.content,
    required this.likes,
    required this.comments,
    required this.views,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
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
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {
              // TODO: 공유 기능
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
                      Text(
                        widget.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.school} · ${widget.timeAgo}',
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
                  Text(widget.likes, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(width: 20),
                  Icon(Icons.chat_bubble_outline, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(widget.comments, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(width: 20),
                  Icon(Icons.visibility_outlined, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(widget.views, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 24),
              if (widget.category.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.category,
                    style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 48,
                    color: Colors.white30,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.8,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 20),
              _buildCommentSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '댓글을 입력하세요',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.send, color: AppColors.primaryGreen),
              onPressed: () {
                // TODO: 댓글 전송
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '댓글 ${widget.comments}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildComment(
          username: 'user1',
          comment: '정말 공감가는 글이네요. 저도 비슷한 경험이 있어요.',
          timeAgo: '5분 전',
        ),
        _buildComment(
          username: 'user2',
          comment: '힘내세요! 모두가 그런 시간을 겪고 있답니다.',
          timeAgo: '10분 전',
        ),
        _buildComment(
          username: 'user3',
          comment: '좋은 글 감사합니다. 위로가 되네요.',
          timeAgo: '15분 전',
        ),
      ],
    );
  }

  Widget _buildComment({
    required String username,
    required String comment,
    required String timeAgo,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}