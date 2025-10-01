import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch all notifications
class FetchNotificationsEvent extends NotificationEvent {}

/// Mark a notification as read
class MarkAsReadEvent extends NotificationEvent {
  final int notificationId;
  const MarkAsReadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// Mark a notification as unread
class MarkAsUnreadEvent extends NotificationEvent {
  final int notificationId;
  const MarkAsUnreadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// Delete a notification
class DeleteNotificationEvent extends NotificationEvent {
  final int notificationId;
  const DeleteNotificationEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}
