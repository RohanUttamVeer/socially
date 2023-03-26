import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/features/auth/controller/auth_controller.dart';
import '../../../models/notification_model.dart' as model;
import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../constants/appwrite_constants.dart';
import '../controller/notification_controller.dart';
import '../widget/notification_tile.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationProvider(currentUser.uid)).when(
                data: (notification) {
                  return ref.watch(getLatestNotificationProvider).when(
                        data: (data) {
                          if (data.events.contains(
                              'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.notificationCollection}.documents.*.create')) {
                            final latestNotification =
                                model.Notification.fromMap(data.payload);
                            if (latestNotification.uid == currentUser.uid) {
                              notification.insert(0, latestNotification);
                            }
                          }

                          return ListView.builder(
                            itemCount: notification.length,
                            itemBuilder: (BuildContext context, int index) {
                              return NotificationTile(
                                notification: notification[index],
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          errorText: error.toString(),
                        ),
                        loading: () {
                          return ListView.builder(
                            itemCount: notification.length,
                            itemBuilder: (BuildContext context, int index) {
                              return NotificationTile(
                                notification: notification[index],
                              );
                            },
                          );
                        },
                      );
                },
                error: (error, stackTrace) => ErrorText(
                  errorText: error.toString(),
                ),
                loading: () => const Loader(),
              ),
    );
  }
}
