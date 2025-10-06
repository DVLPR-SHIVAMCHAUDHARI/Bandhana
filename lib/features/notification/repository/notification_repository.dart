import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/repository/repository.dart';

class NotificationRepository extends Repository {
  /// Fetch all notifications
  Future<Map<String, dynamic>> fetchNotifications() async {
    try {
      final response = await dio.get("/matched/get-notifications");
      if (response.data['Response']['Status']['StatusCode'] == "0") {
        return {
          "status": "success",
          "data": response.data['Response']['ResponseData']['list'],
        };
      } else {
        return {
          "status": "failure",
          "message": response.data['Response']['Status']['DisplayText'],
        };
      }
    } catch (e) {
      logger.e(e);
      return {"status": "error", "message": "An error occurred: $e"};
    }
  }

  //// Mark a notification as read
  Future<Map<String, dynamic>> markAsRead(int notificationId) async {
    try {
      final response = await dio.post(
        "/matched/viewed-notifications",
        queryParameters: {"notifications_id": notificationId},
      );

      if (response.data['Response']['Status']['StatusCode'] == "0") {
        return {"status": "success"};
      } else {
        return {
          "status": "failure",
          "message": response.data['Response']['Status']['DisplayText'],
        };
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> markAsUnread(int notificationId) async {
    try {
      final response = await dio.post(
        "/matched/unread-notifications",
        queryParameters: {"notifications_id": notificationId},
      );

      if (response.data['Response']['Status']['StatusCode'] == "0") {
        return {"status": "success"};
      } else {
        return {
          "status": "failure",
          "message": response.data['Response']['Status']['DisplayText'],
        };
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Delete notification
  Future<Map<String, dynamic>> deleteNotification(int notificationId) async {
    try {
      final response = await dio.post(
        "/matched/delete-notifications",
        queryParameters: {"notifications_id": notificationId},
      );

      if (response.data['Response']['Status']['StatusCode'] == "0") {
        return {"status": "success"};
      } else {
        return {
          "status": "failure",
          "message": response.data['Response']['Status']['DisplayText'],
        };
      }
    } catch (e) {
      rethrow;
    }
  }
}
