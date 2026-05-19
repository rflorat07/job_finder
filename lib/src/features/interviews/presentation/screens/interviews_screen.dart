import 'package:flutter/material.dart';

class InterviewsScreen extends StatelessWidget {
  const InterviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interviews Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Interviews Screen!'),
      ),
    );
  }
}
