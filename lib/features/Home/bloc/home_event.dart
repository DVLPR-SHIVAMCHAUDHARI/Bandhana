import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {}

class FetchUsersEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

// home_event.dart
class SkipUserEvent extends HomeEvent {
  final String userId;

  SkipUserEvent({required this.userId});
  @override
  List<Object?> get props => [userId];
}
