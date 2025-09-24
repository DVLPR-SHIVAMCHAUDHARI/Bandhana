import 'package:bandhana/features/Home/models/home_user_model.dart';
import 'package:equatable/equatable.dart';

abstract class DiscoverState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends DiscoverState {}

class FetchUsersLoadingState extends DiscoverState {}

class FetchUserLoadedState extends DiscoverState {
  List<HomeUserModel> list = [];

  FetchUserLoadedState(this.list);

  @override
  List<Object?> get props => [list];
}

class FetchUserFailureState extends DiscoverState {
  final String? message;

  FetchUserFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
