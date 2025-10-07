import 'dart:developer';

import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/numberextension.dart';
import 'package:MilanMandap/core/const/snack_bar.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/core/const/user_model.dart';
import 'package:MilanMandap/core/repository/repository.dart';
import 'package:MilanMandap/features/Chat/models/messagemodel.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_bloc.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_event.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_state.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  ChatScreen({
    super.key,
    required this.id, // Target User ID (int)
    required this.image,
    required this.name,
  });
  final String name;
  final String image;
  final int id; // The ID of the person we are chatting with
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Initial dummy messages for a better starting experience
  List<Messagemodel> messages = [
    Messagemodel(
      message:
          "Hi Ananya, good to connect with you here 😊\nI really liked your profile – especially your passion for fitness and reading.\nHow's your week going?",
      type: "source", // isMe: true
      time: "09:41",
    ),
    Messagemodel(
      message:
          "Hi John, thank you 😊\nGlad to connect as well. My week’s been good so far – just the usual work hustle.\nHow about yours?",
      type: "destination", // isMe: false
      time: "09:41",
    ),
  ];

  UserModel user = UserModel(); // Holds the current user's data
  late IO.Socket socket;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    // 1. Start fetching the current user's profile status immediately
    context.read<MasterBloc>().add(GetprofileStatus());
  }

  @override
  void dispose() {
    if (_isConnected) {
      socket.disconnect();
    }
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Helper to format time (HH:MM)
  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  /// Establishes the Socket.IO connection and sets up listeners.
  void connect() {
    // Prevent double connection and ensure we have a valid User ID
    if (user.userId == null || _isConnected) return;

    socket = IO.io("http://3.110.183.40:4015", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _isConnected = true;
    socket.connect();

    socket.onConnect((data) {
      log("Socket Connected. ID: ${socket.id}");

      // 1. Sign In / Authenticate the user with their ID
      socket.emit("signin", user.userId);
      log("Emitted signin with UserID: ${user.userId}");

      // 2. Set up listener for incoming messages
      socket.on("message", (msg) {
        log("Message received from server: $msg");
        _handleIncomingMessage(msg);
      });
    });

    socket.onDisconnect((_) => log("Socket Disconnected"));
    socket.onError((err) => log("Socket Error: $err"));
  }

  /// Handles incoming message data from the Socket.IO server.
  void _handleIncomingMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final int? sourceId = data['sourceId'] as int?;
      final String messageText = data['message'] as String? ?? '...';
      final int? currentUserId = user.userId;

      // Ensure the message is from the person we are currently chatting with
      if (currentUserId != null && sourceId == widget.id) {
        setMessage(
          type: "destination", // Incoming message
          message: messageText,
          time: _formatTime(DateTime.now()),
        );
      }
    }
    // Simple string messages could also be handled, but Map is safer.
  }

  /// Sends the message via Socket.IO.
  void sendMessage() {
    final text = messageController.text.trim();
    final int? currentUserId = user.userId;

    if (currentUserId == null || !socket.connected || text.isEmpty) {
      if (text.isEmpty) {
        snackbar(
          context,
          message: "Please write a message first",
          title: "Oops",
          type: ContentType.failure,
        );
      } else {
        log('Cannot send message: User ID not loaded or Socket not connected.');
        snackbar(
          context,
          message: "Connection not ready. Please wait or relogin.",
          title: "Connection Error",
          type: ContentType.failure,
        );
      }
      return;
    }

    // 1. Emit the message to the server
    socket.emit("message", {
      "message": text,
      "sourceId": currentUserId,
      "targetId": widget.id,
    });

    log("Message sent to server: $text");

    // 2. Optimistically update the UI
    setMessage(
      type: "source", // Outgoing message
      message: text,
      time: _formatTime(DateTime.now()),
    );
    messageController.clear();
  }

  /// Updates the message list and triggers auto-scrolling.
  void setMessage({
    required String type,
    required String message,
    String? time,
  }) {
    Messagemodel messageModel = Messagemodel(
      message: message,
      type: type,
      time: time ?? _formatTime(DateTime.now()),
    );

    // Use Future.microtask to delay scrolling until after the next build frame
    // This reliably ensures that the maxScrollExtent has been updated.
    Future.microtask(() {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Update state to add the new message
    setState(() {
      messages.add(messageModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // BlocListener to fetch user data and initiate connection
            BlocListener<MasterBloc, MasterState>(
              listener: (context, state) {
                if (state is GetProfileStatusLoadedState) {
                  user = state.user;
                  connect(); // Connect only after the user ID is safely loaded
                }
              },
              child: const SizedBox.shrink(),
            ),

            // ------------------ Header ------------------
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.w),
              alignment: Alignment.bottomCenter,
              height: 100.h,
              color: AppColors.primary,
              child: Row(
                children: [
                  InkWell(
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    // Use goNamed for navigation back to the chat list
                    onTap: () => router.goNamed(Routes.chatList.name),
                  ),
                  10.widthBox, // Spacing
                  CircleAvatar(
                    maxRadius: 25.r,
                    backgroundImage: CachedNetworkImageProvider(widget.image),
                  ),
                  10.widthBox,
                  Text(
                    widget.name, // Display dynamic name from constructor
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: Typo.bold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ------------------ Message List ------------------
            Expanded(
              child: ListView.builder(
                controller: _scrollController, // Attach the controller
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isSource =
                      msg.type == "source"; // "source" means it's 'Me'

                  return Align(
                    alignment: isSource
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: isSource
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isSource
                              ? const Radius.circular(16)
                              : Radius.zero,
                          bottomRight: isSource
                              ? Radius.zero
                              : const Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            msg.message,
                            style: TextStyle(
                              color: isSource ? Colors.white : Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            msg.time ?? _formatTime(DateTime.now()),
                            style: TextStyle(
                              fontSize: 11,
                              color: isSource ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ------------------ Input bar ------------------
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
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message ...",
                        ),
                        // Allow sending message on pressing 'Enter' on a soft keyboard
                        onFieldSubmitted: (_) => sendMessage(),
                      ),
                    ),
                    10.widthBox,
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: sendMessage, // Call the send function
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
