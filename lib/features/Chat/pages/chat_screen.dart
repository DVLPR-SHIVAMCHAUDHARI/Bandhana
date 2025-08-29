import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final List<Map<String, dynamic>> _messages = [
    {
      "isMe": true,
      "text":
          "Hi Ananya, good to connect with you here 😊\nI really liked your profile – especially your passion for fitness and reading.\nHow's your week going?",
      "time": "09:41",
    },
    {
      "isMe": false,
      "text":
          "Hi John, thank you 😊\nGlad to connect as well. My week’s been good so far – just the usual work hustle.\nHow about yours?",
      "time": "09:41",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => router.goNamed(Routes.chatList.name),
        ),
        centerTitle: false,
        title: const Text(
          "Ananya Pandey",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg["isMe"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: msg["isMe"]
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: msg["isMe"]
                            ? const Radius.circular(16)
                            : Radius.zero,
                        bottomRight: msg["isMe"]
                            ? Radius.zero
                            : const Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          msg["text"],
                          style: TextStyle(
                            color: msg["isMe"] ? Colors.white : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg["time"],
                          style: TextStyle(
                            fontSize: 11,
                            color: msg["isMe"]
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Input bar
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.pink.shade200, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // IconButton(
                  //   icon: const Icon(
                  //     Icons.emoji_emotions_outlined,
                  //     color: Colors.grey,
                  //   ),
                  //   onPressed: () {

                  //   },
                  // ),
                  Expanded(
                    child: TextField(
                      // controller: _controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type a message ...",
                      ),
                    ),
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.attach_file, color: Colors.grey),
                  //   onPressed: () {},
                  // ),
                  // IconButton(
                  //   icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  //   onPressed: () {},
                  // ),
                  10.widthBox,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
