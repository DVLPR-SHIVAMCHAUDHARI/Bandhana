import 'package:equatable/equatable.dart';

abstract class ProfileDetailApprovedEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SwitchImageEvent extends ProfileDetailApprovedEvent {
  final int selectedIndex;
  final List<Map<String, dynamic>> avatars;

  SwitchImageEvent(this.selectedIndex, this.avatars);
  @override
  List<Object?> get props => [avatars, selectedIndex];
}

class ToggleFavoriteEvent extends ProfileDetailApprovedEvent {}

class GetUserDetailById extends ProfileDetailApprovedEvent {
  final String id;
  GetUserDetailById(this.id);
  @override
  List<Object?> get props => [id];
}

class SendRequestEvent extends ProfileDetailApprovedEvent {
  final String id;
  SendRequestEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class AcceptRequestEvent extends ProfileDetailApprovedEvent {
  final String id;
  AcceptRequestEvent(this.id);
  @override
  List<Object?> get props => [id];
}
