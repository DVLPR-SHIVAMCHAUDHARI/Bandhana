import 'package:equatable/equatable.dart';

abstract class RequestEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRecievedRequests extends RequestEvent {}

class GetSentRequests extends RequestEvent {}

// Reject received request
class RejectRecievedRequest extends RequestEvent {
  final int userId;

  RejectRecievedRequest({required this.userId});

  @override
  List<Object?> get props => [userId];
}
