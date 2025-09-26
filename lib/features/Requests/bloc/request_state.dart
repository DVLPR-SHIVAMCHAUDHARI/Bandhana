import 'package:bandhana/features/Home/models/home_user_model.dart';

abstract class RequestState {}

class InitialState extends RequestState {}

class RecievedRequestsLoadingState extends RequestState {}

class RecievedRequestsLoadedState extends RequestState {
  final List<HomeUserModel> users;
  RecievedRequestsLoadedState(this.users);
}

class RecievedRequestsErrorState extends RequestState {
  final String error;
  RecievedRequestsErrorState(this.error);
}
