// chat_screen.dart

import 'dart:developer';
import 'package:MilanMandap/core/const/user_model.dart';
import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/numberextension.dart';
import 'package:MilanMandap/core/const/snack_bar.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/core/repository/repository.dart';

import 'package:MilanMandap/core/services/local_db_sevice.dart';
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
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji;

// Global instance of the local database service
final LocalDbService localDb = LocalDbService.instance;

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
  final FocusNode focusNode = FocusNode();
  bool _emojiShowing = false;

  List<Messagemodel> messages = [];
  UserModel user = UserModel();
  late IO.Socket socket;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    context.read<MasterBloc>().add(GetprofileStatus());

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        if (_emojiShowing) {
          setState(() {
            _emojiShowing = false;
          });
        }
      }
    });
  }

  // In _ChatScreenState
  @override
  void dispose() {
    if (_isConnected && user.userId != null) {
      // 1. Remove the listener to prevent memory leaks/setState errors
      socket.off('message');

      // 2. Save and disconnect
      localDb.saveChatMessages(user.userId!, widget.id, messages);
      socket.disconnect();
      _isConnected = false; // Reset connection state
    }

    messageController.dispose();
    _scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // Helper to format time (HH:MM)
  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  /// Loads saved messages from Hive.
  void _loadMessages() {
    if (user.userId == null) return;

    final savedMessages = localDb.getChatMessages(user.userId!, widget.id);

    // Add a simple initial message if history is empty
    if (savedMessages.isEmpty) {
      messages = [
        Messagemodel(
          message: "Welcome! Say hello to ${widget.name}.",
          type: "destination",
          time: _formatTime(DateTime.now()),
        ),
      ];
    } else {
      messages = savedMessages;
    }

    // 💡 FIX 2: Check mounted before calling setState()
    if (!mounted) return;

    setState(() {});

    // Ensure scrolling to the bottom if there are messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  /// Establishes the Socket.IO connection and sets up listeners.
  // In _ChatScreenState
  /// Establishes the Socket.IO connection and sets up listeners.
  void connect() {
    if (user.userId == null) return;

    // 💡 FIX: If the socket object exists (even if not connected) and we are
    // trying to connect again, we must explicitly clean up the previous instance
    // to remove old listeners and avoid message duplication.
    if (_isConnected) {
      log("⚠️ Cleaning up existing socket before reconnecting.");
      // Stop all listeners, disconnect, and reset state.
      socket.off('message');
      socket.disconnect();
      _isConnected = false;
    }

    socket = IO.io(socket, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect(); // Start the connection

    socket.onConnect((data) {
      // Set _isConnected to true only upon successful connection
      _isConnected = true;
      log("Socket Connected. ID: ${socket.id}");
      socket.emit("signin", user.userId);
      log("Emitted signin with UserID: ${user.userId}");

      // 💡 The listener is added here, ensuring it's only set up ONCE per active connection.
      socket.on("message", (msg) {
        log("Message received from server: $msg");
        _handleIncomingMessage(msg);
      });
    });

    socket.onDisconnect((_) {
      log("Socket Disconnected");
      _isConnected = false; // Reset connection state
    });
    socket.onError((err) => log("Socket Error: $err"));
  }

  /// Handles incoming message data from the Socket.IO server.
  void _handleIncomingMessage(dynamic data) {
    // 💡 FIX 3: Check mounted before processing the message
    if (!mounted) return;

    if (data is Map<String, dynamic>) {
      final int? sourceId = data['sourceId'] as int?;
      final String messageText = data['message'] as String? ?? '...';
      final int? currentUserId = user.userId;

      if (currentUserId != null && sourceId == widget.id) {
        setMessage(
          type: "destination",
          message: messageText,
          time: _formatTime(DateTime.now()),
        );
      }
    }
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
        snackbar(
          context,
          message: "Connection not ready.",
          title: "Connection Error",
          type: ContentType.failure,
        );
      }
      return;
    }

    socket.emit("message", {
      "message": text,
      "sourceId": currentUserId,
      "targetId": widget.id,
    });

    log("Message sent to server: $text");

    // Optimistically update the UI
    setMessage(
      type: "source",
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

    // 💡 FIX 4: Check mounted before calling setState() (Crucial fix for line 223)
    if (!mounted) return;

    setState(() {
      messages.add(messageModel);
    });

    // Ensure scrolling happens after the UI updates
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

  // Widget to build the emoji picker
  Widget _buildEmojiContainer() {
    return Offstage(
      offstage: !_emojiShowing,
      child: SizedBox(
        height: 250,
        child: emoji.EmojiPicker(
          textEditingController: messageController,
          config: const emoji.Config(
            checkPlatformCompatibility: true,
            emojiViewConfig: emoji.EmojiViewConfig(
              columns: 7,
              backgroundColor: Color(0xFFFAFAFA),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Light shade of primary color (0xffFC6B85) for sent messages
    const Color primaryLight = Color(0xFFFE98AA);

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (_emojiShowing) {
            setState(() {
              _emojiShowing = false;
            });
            return false;
          }
          return true;
        },
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // BlocListener to fetch user data and initiate connection
              BlocListener<MasterBloc, MasterState>(
                listener: (context, state) {
                  if (state is GetProfileStatusLoadedState) {
                    user = state.user;
                    // LOAD MESSAGES FIRST, THEN CONNECT
                    _loadMessages();
                    connect();
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
                      onTap: () => router.goNamed(Routes.chatList.name),
                    ),
                    10.widthBox,
                    CircleAvatar(
                      maxRadius: 25.r,
                      backgroundImage: CachedNetworkImageProvider(widget.image),
                    ),
                    10.widthBox,
                    Text(
                      widget.name,
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
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isSource = msg.type == "source";

                    return Align(
                      alignment: isSource
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12).w,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                        ),
                        decoration: BoxDecoration(
                          color: isSource
                              ? AppColors
                                    .primaryFC // Use the light shade for sent messages
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
                        child: IntrinsicWidth(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // Align all content to the end for sent messages
                            crossAxisAlignment:
                                //     ? CrossAxisAlignment.end
                                CrossAxisAlignment.start,
                            children: [
                              // The message text itself
                              Text(
                                msg.message,
                                style: TextStyle(
                                  color: isSource
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 15,
                                ),
                              ),

                              // A little space
                              4.verticalSpace,

                              // The time, which will also be aligned by the Column's crossAxisAlignment
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  30.horizontalSpace,
                                  Text(
                                    msg.time,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isSource
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // ...
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ------------------ Input bar ------------------
              Container(
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
                        focusNode: focusNode,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          isDense: true,
                          prefixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _emojiShowing = !_emojiShowing;
                              });
                              if (_emojiShowing) {
                                focusNode.unfocus();
                              } else {
                                focusNode.requestFocus();
                              }
                            },
                            icon: Icon(
                              _emojiShowing
                                  ? Icons.keyboard
                                  : Icons.emoji_emotions,
                              color: AppColors.primary,
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: "Type a message ...",
                        ),
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
                        onPressed: sendMessage,
                      ),
                    ),
                  ],
                ),
              ),

              // ------------------ Emoji Picker ------------------
              _buildEmojiContainer(),

              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
