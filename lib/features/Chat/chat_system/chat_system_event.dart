// lib/features/Chat/bloc/chat_system_event.dart

import 'package:equatable/equatable.dart';
import 'package:MilanMandap/features/Chat/models/messagemodel.dart';

abstract class ChatSystemEvent extends Equatable {
  const ChatSystemEvent();
  @override
  List<Object> get props => [];
}

class ConnectSocketEvent extends ChatSystemEvent {}

class NewMessageReceivedEvent extends ChatSystemEvent {
  final Messagemodel message;
  const NewMessageReceivedEvent({required this.message});
  @override
  List<Object> get props => [message];
}

class LoadChatHistoryEvent extends ChatSystemEvent {
  final List<Messagemodel> messages;
  final int partnerId;
  const LoadChatHistoryEvent({required this.messages, required this.partnerId});
  @override
  List<Object> get props => [messages, partnerId];
}

class SendChatMessageEvent extends ChatSystemEvent {
  final Messagemodel message;
  const SendChatMessageEvent({required this.message});
  @override
  List<Object> get props => [message];
}

class MarkChatReadEvent extends ChatSystemEvent {
  final int partnerId;
  const MarkChatReadEvent({required this.partnerId});
  @override
  List<Object> get props => [partnerId];
}

// Add other events like FetchInitialUnreadCountsEvent, DisconnectSocketEvent, etc.
