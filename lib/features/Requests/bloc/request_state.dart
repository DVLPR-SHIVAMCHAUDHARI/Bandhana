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

class SentRequestsLoadingState extends RequestState {}

class SentRequestsLoadedState extends RequestState {
  final List<HomeUserModel> users;
  SentRequestsLoadedState(this.users);
}

class SentRequestsErrorState extends RequestState {
  final String error;
  SentRequestsErrorState(this.error);
}

// Reject Request
class RejectRequestLoadingState extends RequestState {}

class RejectRequestSuccessState extends RequestState {
  final String message;
  RejectRequestSuccessState(this.message);
}

class RejectRequestErrorState extends RequestState {
  final String error;
  RejectRequestErrorState(this.error);
}
