import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {}

class FetchUsersEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}
