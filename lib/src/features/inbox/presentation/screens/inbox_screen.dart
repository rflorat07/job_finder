import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Inbox Screen!'),
      ),
    );
  }
}
