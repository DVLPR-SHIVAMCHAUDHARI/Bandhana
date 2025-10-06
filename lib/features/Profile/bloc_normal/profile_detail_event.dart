import 'package:equatable/equatable.dart';

abstract class ProfileDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// 🔹 Event for switching main image
class SwitchImageEvent extends ProfileDetailEvent {
  final int selectedIndex;
  final List<Map<String, dynamic>> avatars;

  SwitchImageEvent(this.selectedIndex, this.avatars);

  @override
  List<Object?> get props => [selectedIndex, avatars];
}

// 🔹 Event for toggling favorite
class ToggleFavoriteEvent extends ProfileDetailEvent {
  final String userId;
  final bool add; // true to add, false to remove

  ToggleFavoriteEvent({required this.userId, this.add = true});
} // 🔹 Event to get user details (unused if loading from HomeBloc)

class GetUserDetailById extends ProfileDetailEvent {
  final String id;
  GetUserDetailById(this.id);
  @override
  List<Object?> get props => [id];
}

// 🔹 Events for request handling
class SendRequestEvent extends ProfileDetailEvent {
  final String id;
  SendRequestEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class AcceptRequestEvent extends ProfileDetailEvent {
  final String id;
  AcceptRequestEvent(this.id);
  @override
  List<Object?> get props => [id];
}
