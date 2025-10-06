import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/features/notification/bloc/notification_bloc.dart';
import 'package:MilanMandap/features/notification/bloc/notification_event.dart';
import 'package:MilanMandap/features/notification/bloc/notification_state.dart';
import 'package:MilanMandap/features/notification/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hr ago";
    } else {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationBloc()..add(FetchNotificationsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is NotificationActionSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));

              // Refresh notifications after an action
              context.read<NotificationBloc>().add(FetchNotificationsEvent());
            }
          },
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              List<NotificationModel> notifications = state.notifications;

              // Sort by latest first
              notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

              if (notifications.isEmpty) {
                return const Center(child: Text("No notifications"));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<NotificationBloc>().add(
                    FetchNotificationsEvent(),
                  );
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notif = notifications[index];
                    return Dismissible(
                      key: Key(notif.notificationsId.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        context.read<NotificationBloc>().add(
                          DeleteNotificationEvent(notif.notificationsId),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: notif.isViewed == 0
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(notif.fromUserFullname[0]),
                          ),
                          title: Text(
                            notif.notification,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              fontFamily: Typo.semiBold,
                            ),
                          ),
                          subtitle: Text(timeAgo(notif.createdAt)),
                          trailing: notif.isViewed == 0
                              ? const Icon(
                                  Icons.circle,
                                  color: Colors.blue,
                                  size: 12,
                                )
                              : null,
                          onLongPress: () {
                            if (notif.isViewed == 1) {
                              context.read<NotificationBloc>().add(
                                MarkAsUnreadEvent(notif.notificationsId),
                              );
                            }
                          },
                          onTap: () {
                            if (notif.isViewed == 0) {
                              context.read<NotificationBloc>().add(
                                MarkAsReadEvent(notif.notificationsId),
                              );
                            }
                            router.goNamed("request");
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is NotificationError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
