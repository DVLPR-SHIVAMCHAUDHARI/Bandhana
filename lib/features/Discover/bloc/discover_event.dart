import 'package:equatable/equatable.dart';

abstract class DiscoverEvent extends Equatable {}

class FetchUsersEvent extends DiscoverEvent {
  @override
  List<Object?> get props => [];
}
