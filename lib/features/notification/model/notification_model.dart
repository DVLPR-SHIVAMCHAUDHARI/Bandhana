class NotificationModel {
  final int notificationsId;
  final int fromUserId;
  final String fromUserFullname;
  final String notification;
  final int isViewed;
  final DateTime createdAt;

  NotificationModel({
    required this.notificationsId,
    required this.fromUserId,
    required this.fromUserFullname,
    required this.notification,
    required this.isViewed,
    required this.createdAt,
  });

  /// Factory constructor to create model from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationsId: json['notifications_id'] ?? 0,
      fromUserId: json['from_user_id'] ?? 0,
      fromUserFullname: json['from_user_fullname'] ?? '',
      notification: json['notification'] ?? '',
      isViewed: json['is_viewed'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'notifications_id': notificationsId,
      'from_user_id': fromUserId,
      'from_user_fullname': fromUserFullname,
      'notification': notification,
      'is_viewed': isViewed,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
