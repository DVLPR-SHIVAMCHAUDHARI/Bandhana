import 'package:bandhana/features/notification/model/notification_model.dart';
import 'package:bandhana/features/notification/repository/notification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository = NotificationRepository();

  NotificationBloc() : super(NotificationInitial()) {
    // Fetch notifications
    on<FetchNotificationsEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final res = await repository.fetchNotifications();
        if (res['status'] == 'success') {
          final List<NotificationModel> notifications = (res['data'] as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList();
          emit(NotificationLoaded(notifications));
        } else {
          emit(
            NotificationError(
              res['message'] ?? "Failed to fetch notifications",
            ),
          );
        }
      } catch (e) {
        emit(NotificationError("Error: $e"));
      }
    });

    // Mark as read
    on<MarkAsReadEvent>((event, emit) async {
      try {
        final res = await repository.markAsRead(event.notificationId);
        if (res['status'] == 'success') {
          emit(NotificationActionSuccess("Marked as read"));
          add(FetchNotificationsEvent()); // refresh list
        } else {
          emit(NotificationError(res['message'] ?? "Failed to mark as read"));
        }
      } catch (e) {
        emit(NotificationError("Error: $e"));
      }
    });

    // Mark as unread
    on<MarkAsUnreadEvent>((event, emit) async {
      try {
        final res = await repository.markAsUnread(event.notificationId);
        if (res['status'] == 'success') {
          emit(NotificationActionSuccess("Marked as unread"));
          add(FetchNotificationsEvent()); // refresh list
        } else {
          emit(NotificationError(res['message'] ?? "Failed to mark as unread"));
        }
      } catch (e) {
        emit(NotificationError("Error: $e"));
      }
    });

    // Delete notification
    on<DeleteNotificationEvent>((event, emit) async {
      try {
        final res = await repository.deleteNotification(event.notificationId);
        if (res['status'] == 'success') {
          emit(NotificationActionSuccess("Notification deleted"));
          add(FetchNotificationsEvent()); // refresh list
        } else {
          emit(
            NotificationError(
              res['message'] ?? "Failed to delete notification",
            ),
          );
        }
      } catch (e) {
        emit(NotificationError("Error: $e"));
      }
    });
  }
}
