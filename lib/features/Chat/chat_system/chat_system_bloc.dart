// // lib/features/Chat/bloc/chat_system_bloc.dart

// import 'dart:developer';
// import 'package:MilanMandap/features/Chat/chat_system/chat_system_event.dart';
// import 'package:MilanMandap/features/Chat/chat_system/chat_system_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:MilanMandap/core/services/local_db_sevice.dart';

// import 'package:MilanMandap/features/Chat/models/messagemodel.dart';

// // 🔑 ASSUMPTION: You have a class for socket handling
// // import 'package:MilanMandap/services/socket_service.dart';

// class ChatSystemBloc extends Bloc<ChatSystemEvent, ChatSystemState> {
//   final LocalDbService _localDbService;
//   // final SocketService _socketService; // If needed for external listeners

//   ChatSystemBloc({
//     required LocalDbService localDbService,
//     /* required SocketService socketService */
//   }) : _localDbService = localDbService,
//        // , _socketService = socketService
//        super(const ChatSystemInitial()) {
//     on<ConnectSocketEvent>(_onConnectSocket);
//     on<NewMessageReceivedEvent>(_onNewMessageReceived);
//     on<LoadChatHistoryEvent>(_onLoadChatHistory);
//     on<SendChatMessageEvent>(_onSendChatMessage);
//     on<MarkChatReadEvent>(_onMarkChatRead);

//     // 🔑 SOCKET LISTENER INTEGRATION:
//     // _socketService.onNewMessage((message) => add(NewMessageReceivedEvent(message: message)));
//   }

//   int _getPartnerId(Messagemodel message) {
//     return message.senderId == state.currentUserId
//         ? message.receiverId
//         : message.senderId;
//   }

//   void _onConnectSocket(
//     ConnectSocketEvent event,
//     Emitter<ChatSystemState> emit,
//   ) {
//     // 🔑 Replace 123 with actual logged-in user ID fetched from MasterBloc/AuthService
//     const int currentUserId = 123;

//     emit(
//       ChatSystemReady(
//         isConnected: true,
//         currentUserId: currentUserId,
//         allMessages: const {},
//         unreadCounts: const {},
//         latestMessages: const {},
//       ),
//     );
//     log("✅ ChatSystemBloc Ready. User ID: $currentUserId");
//     // _socketService.connect(); // Start the actual socket connection
//   }

//   void _onNewMessageReceived(
//     NewMessageReceivedEvent event,
//     Emitter<ChatSystemState> emit,
//   ) {
//     if (state is! ChatSystemReady) return;

//     final message = event.message;
//     final partnerId = _getPartnerId(message);
//     final currentUserId = state.currentUserId;

//     final updatedAllMessages = Map<int, List<Messagemodel>>.from(
//       state.allMessages,
//     );
//     updatedAllMessages.update(
//       partnerId,
//       (messages) => List.from(messages)..add(message),
//       ifAbsent: () => [message],
//     );

//     final updatedUnreadCounts = Map<int, int>.from(state.unreadCounts);
//     updatedUnreadCounts.update(
//       partnerId,
//       (count) => count + 1,
//       ifAbsent: () => 1,
//     );

//     final updatedLatestMessages = Map<int, Messagemodel>.from(
//       state.latestMessages,
//     );
//     updatedLatestMessages[partnerId] = message;

//     emit(
//       (state as ChatSystemReady).copyWith(
//         allMessages: updatedAllMessages,
//         unreadCounts: updatedUnreadCounts,
//         latestMessages: updatedLatestMessages,
//       ),
//     );

//     // 💾 PERSISTENCE: Save the entire updated list to Hive
//     final messagesToSave = updatedAllMessages[partnerId] ?? [];
//     _localDbService.saveChatMessages(currentUserId, partnerId, messagesToSave);
//   }

//   void _onLoadChatHistory(
//     LoadChatHistoryEvent event,
//     Emitter<ChatSystemState> emit,
//   ) {
//     if (state is! ChatSystemReady) return;

//     final partnerId = event.partnerId;
//     final currentUserId = state.currentUserId;

//     // 💾 PERSISTENCE: Load messages from local database
//     final List<Messagemodel> messages = _localDbService.getChatMessages(
//       currentUserId,
//       partnerId,
//     );

//     final updatedAllMessages = Map<int, List<Messagemodel>>.from(
//       state.allMessages,
//     )..[partnerId] = messages;

//     final updatedLatestMessages = Map<int, Messagemodel>.from(
//       state.latestMessages,
//     );
//     if (messages.isNotEmpty) {
//       updatedLatestMessages[partnerId] = messages.last;
//     } else {
//       updatedLatestMessages.remove(partnerId);
//     }

//     final updatedUnreadCounts = Map<int, int>.from(state.unreadCounts)
//       ..remove(partnerId);

//     emit(
//       (state as ChatSystemReady).copyWith(
//         allMessages: updatedAllMessages,
//         unreadCounts: updatedUnreadCounts,
//         latestMessages: updatedLatestMessages,
//       ),
//     );
//   }

//   void _onSendChatMessage(
//     SendChatMessageEvent event,
//     Emitter<ChatSystemState> emit,
//   ) {
//     if (state is! ChatSystemReady) return;

//     // 1. Prepare message with temporary details
//     final sentMessage = event.message.copyWith(
//       id: DateTime.now().millisecondsSinceEpoch,
//       time: 'Just now',
//     );
//     final partnerId = sentMessage.receiverId;
//     final currentUserId = state.currentUserId;

//     // 2. Update state optimistically
//     final updatedAllMessages = Map<int, List<Messagemodel>>.from(
//       state.allMessages,
//     );
//     updatedAllMessages.update(
//       partnerId,
//       (messages) => List.from(messages)..add(sentMessage),
//       ifAbsent: () => [sentMessage],
//     );

//     final updatedLatestMessages = Map<int, Messagemodel>.from(
//       state.latestMessages,
//     );
//     updatedLatestMessages[partnerId] = sentMessage;

//     emit(
//       (state as ChatSystemReady).copyWith(
//         allMessages: updatedAllMessages,
//         latestMessages: updatedLatestMessages,
//       ),
//     );

//     // 3. 💾 PERSISTENCE: Save the new list locally
//     final messagesToSave = updatedAllMessages[partnerId] ?? [];
//     _localDbService.saveChatMessages(currentUserId, partnerId, messagesToSave);

//     // 4. 🔑 SOCKET ACTION: Send the message via the socket service
//     // _socketService.sendMessage(sentMessage);
//   }

//   void _onMarkChatRead(MarkChatReadEvent event, Emitter<ChatSystemState> emit) {
//     if (state is! ChatSystemReady) return;

//     final updatedUnreadCounts = Map<int, int>.from(state.unreadCounts)
//       ..remove(event.partnerId);

//     emit(
//       (state as ChatSystemReady).copyWith(unreadCounts: updatedUnreadCounts),
//     );
//   }
// }
