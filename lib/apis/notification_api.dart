import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:socially/core/providers.dart';
import 'package:socially/models/notification_model.dart';

import '../constants/appwrite_constants.dart';
import '../core/core.dart';

final notificationAPIProvider = Provider((ref) {
  return NotificationAPI(
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class INotificationAPI {
  FutureEitherVoid createNotification(Notification notification);
}

class NotificationAPI implements INotificationAPI {
  final Databases _db;
  NotificationAPI({
    required Databases db,
  }) : _db = db;

  @override
  FutureEitherVoid createNotification(Notification notification) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.notificationCollection,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? "Unexpected Error", stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}
