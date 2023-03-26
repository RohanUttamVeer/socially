import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../apis/notification_api.dart';
import '../../../core/enums/notification_type_enum.dart';
import '../../../models/notification_model.dart' as model;

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  return NotificationController(
      notificationAPI: ref.watch(notificationAPIProvider));
});

final getLatestNotificationProvider = StreamProvider((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);
  return notificationAPI.getLatestNotification();
});

final getNotificationProvider = FutureProvider.family((ref, String uid) async {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return notificationController.getNotification(uid);
});

class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;
  NotificationController({
    required NotificationAPI notificationAPI,
  })  : _notificationAPI = notificationAPI,
        super(false);

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
  }) async {
    final notification = model.Notification(
      text: text,
      postId: postId,
      notificationType: notificationType,
      id: '',
      uid: uid,
    );
    final res = await _notificationAPI.createNotification(notification);
    res.fold((l) => null, (r) => null);
  }

  Future<List<model.Notification>> getNotification(String uid) async {
    final notifications = await _notificationAPI.getNotification(uid);
    return notifications
        .map(
          (e) => model.Notification.fromMap(e.data),
        )
        .toList();
  }
}
