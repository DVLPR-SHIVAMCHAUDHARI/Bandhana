import 'package:bandhana/features/Home/models/home_user_model.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends HomeState {}

class FetchUsersLoadingState extends HomeState {}

class FetchUserLoadedState extends HomeState {
  List<HomeUserModel> list = [];

  FetchUserLoadedState(this.list);

  @override
  List<Object?> get props => [list];
}

class FetchUserFailureState extends HomeState {
  final String? message;

  FetchUserFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
