// lib/features/Chat/bloc/chat_system_state.dart

import 'package:equatable/equatable.dart';
import 'package:MilanMandap/features/Chat/models/messagemodel.dart';

abstract class ChatSystemState extends Equatable {
  final bool isConnected;
  final int currentUserId;

  final Map<int, List<Messagemodel>> allMessages;
  final Map<int, int> unreadCounts;
  final Map<int, Messagemodel> latestMessages;

  const ChatSystemState({
    this.isConnected = false,
    this.currentUserId = 0,
    this.allMessages = const {},
    this.unreadCounts = const {},
    this.latestMessages = const {},
  });

  ChatSystemState copyWith({
    bool? isConnected,
    int? currentUserId,
    Map<int, List<Messagemodel>>? allMessages,
    Map<int, int>? unreadCounts,
    Map<int, Messagemodel>? latestMessages,
  });

  @override
  List<Object> get props => [
    isConnected,
    currentUserId,
    allMessages,
    unreadCounts,
    latestMessages,
  ];
}

class ChatSystemInitial extends ChatSystemState {
  const ChatSystemInitial();

  @override
  ChatSystemInitial copyWith({
    bool? isConnected,
    int? currentUserId,
    Map<int, List<Messagemodel>>? allMessages,
    Map<int, int>? unreadCounts,
    Map<int, Messagemodel>? latestMessages,
  }) {
    return const ChatSystemInitial();
  }
}

class ChatSystemReady extends ChatSystemState {
  const ChatSystemReady({
    required super.isConnected,
    required super.currentUserId,
    required super.allMessages,
    required super.unreadCounts,
    required super.latestMessages,
  });

  @override
  ChatSystemReady copyWith({
    bool? isConnected,
    int? currentUserId,
    Map<int, List<Messagemodel>>? allMessages,
    Map<int, int>? unreadCounts,
    Map<int, Messagemodel>? latestMessages,
  }) {
    return ChatSystemReady(
      isConnected: isConnected ?? this.isConnected,
      currentUserId: currentUserId ?? this.currentUserId,
      allMessages: allMessages ?? this.allMessages,
      unreadCounts: unreadCounts ?? this.unreadCounts,
      latestMessages: latestMessages ?? this.latestMessages,
    );
  }
}
