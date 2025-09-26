import 'package:equatable/equatable.dart';

abstract class RequestEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRecievedRequests extends RequestEvent {}
