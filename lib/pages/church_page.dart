import 'package:flutter/material.dart';

class ChurchPage extends StatelessWidget {
  const ChurchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '교회',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}