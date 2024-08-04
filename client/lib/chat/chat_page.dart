import 'package:client/chat/chat_bubble.dart';
import 'package:client/chat/chat_loader.dart';
import 'package:client/home/home_page.dart';
import 'package:client/utils/back_widget.dart';
import 'package:client/utils/ellipse_painter.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late WebSocketChannel _channel;

  List<String> messagesSent = [];
  List<Widget> messagesReceived = [
    const ChatBubble(
      message:
          'Hello I\'m OKO. Your personal farming assitant. I can help you with any questions you have about farming. How can I be of service today?',
      axisAlignment: MainAxisAlignment.start,
      color: Color(0xFFDAF2E7),
      textAlign: TextAlign.start,
      margin: EdgeInsets.only(right: 50.0),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _channel = IOWebSocketChannel.connect(Uri.parse('ws://10.0.2.2:3000'));
    _channel.stream.listen((message) {
      setState(() {
        if (messagesReceived.last is ChatLoader) {
          messagesReceived.removeLast();
        }
        messagesReceived.add(
          ChatBubble(
            message: message,
            axisAlignment: MainAxisAlignment.start,
            color: const Color(0xFFDAF2E7),
            textAlign: TextAlign.start,
            margin: const EdgeInsets.only(right: 50.0),
          ),
        );
      });
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  List<Widget> _buildMessageHistory(List<String> messagesSent, List<Widget> messagesReceived) {
    List<Widget> messageHistory = [];

    for (int i = 0; i < messagesReceived.length; i++) {
      messageHistory.add(messagesReceived[i]);

      if (i < messagesSent.length) {
        messageHistory.add(
          ChatBubble(
            message: messagesSent[i],
            axisAlignment: MainAxisAlignment.end,
            color: const Color(0xFFF2F2F2),
            textAlign: TextAlign.end,
            margin: const EdgeInsets.only(left: 50.0),
          ),
        );
      }
    }

    return messageHistory;
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 25.0;
    final double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: padding, right: padding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 150),
                      ..._buildMessageHistory(messagesSent, messagesReceived),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(300, 200),
              painter: EllipsePainter(
                title: 'Ask OKO',
                screenWidth: screenWidth,
                theme: theme,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 25),
              decoration: const BoxDecoration(
                color: Color(0xFFF2F2F2),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF999999),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      child: TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(labelText: 'Send a message'),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                    color: const Color(0xFF0A5C36),
                  ),
                ],
              ),
            ),
          ),
          BackWidget(page: HomePage()),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messagesSent.add(_controller.text);
        messagesReceived.add(const ChatLoader());
      });
      _channel.sink.add(_controller.text);
      _controller.clear();
      _scrollToBottom();
    }
  }
}
