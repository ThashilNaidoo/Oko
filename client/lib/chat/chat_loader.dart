import 'package:flutter/material.dart';

class ChatLoader extends StatefulWidget {
  const ChatLoader({super.key});

  @override
  ChatLoaderState createState() => ChatLoaderState();
}

class ChatLoaderState extends State<ChatLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _animation = IntTween(begin: 0, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        String dots = '.' * (_animation.value + 1);
        return Text(
          dots,
          style: const TextStyle(
            fontSize: 50.0,
            color: Color(0xFF0A5C36),
          ),
        );
      },
    );
  }
}
