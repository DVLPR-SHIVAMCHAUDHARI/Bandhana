import 'package:bandhana/features/notification/model/notification_model.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

/// Initial / loading states
class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

/// Loaded state with list
class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;

  const NotificationLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

/// Error state
class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Optional single action states
class NotificationActionSuccess extends NotificationState {
  final String message;
  const NotificationActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
