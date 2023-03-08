import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:socially/core/core.dart';
import 'package:socially/core/providers.dart';
import '../constants/appwrite_constants.dart';
import '../models/post_model.dart';

final postAPIProvider = Provider((ref) {
  return PostAPI(
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class IPostAPI {
  FutureEither<Document> sharePost(Post post);
}

class PostAPI implements IPostAPI {
  final Databases _db;
  PostAPI({required Databases db}) : _db = db;
  @override
  FutureEither<Document> sharePost(Post post) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postCollection,
        documentId: ID.unique(),
        data: post.toMap(),
      );
      return right(document);
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
