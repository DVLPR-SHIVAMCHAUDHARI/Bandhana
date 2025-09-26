import 'package:equatable/equatable.dart';

abstract class ProfileDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SwitchImageEvent extends ProfileDetailEvent {
  final int selectedIndex;
  final List<Map<String, dynamic>> avatars;

  SwitchImageEvent(this.selectedIndex, this.avatars);
  @override
  List<Object?> get props => [avatars, selectedIndex];
}

class ToggleFavoriteEvent extends ProfileDetailEvent {}

class GetUserDetailById extends ProfileDetailEvent {
  final String id;
  GetUserDetailById(this.id);
  @override
  List<Object?> get props => [id];
}

class SendRequestEvent extends ProfileDetailEvent {
  final String id;
  SendRequestEvent(this.id);
  @override
  List<Object?> get props => [id];
}
