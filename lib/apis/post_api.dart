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
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class IPostAPI {
  FutureEither<Document> sharePost(Post post);
  Future<List<Document>> getPost();
  Stream<RealtimeMessage> getLatestPost();
  FutureEither<Document> likeTweet(Post post);
  FutureEither<Document> updateReshareCount(Post post);
  Future<List<Document>> getRepliesToPost(Post post);
  Future<Document> getPostById(String id);
}

class PostAPI implements IPostAPI {
  final Databases _db;
  final Realtime _realtime;
  PostAPI({
    required Databases db,
    required Realtime realtime,
  })  : _db = db,
        _realtime = realtime;
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

  @override
  Future<List<Document>> getPost() async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postCollection,
      queries: [
        Query.orderDesc('postedAt'),
      ],
    );
    return document.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestPost() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.postCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likeTweet(Post post) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postCollection,
        documentId: post.id,
        data: {
          'likes': post.likes,
        },
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

  @override
  FutureEither<Document> updateReshareCount(Post post) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postCollection,
        documentId: post.id,
        data: {
          'reshareCount': post.reshareCount,
        },
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

  @override
  Future<List<Document>> getRepliesToPost(Post post) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postCollection,
      queries: [
        Query.equal('repliedTo', post.id),
      ],
    );
    return document.documents;
  }

  @override
  Future<Document> getPostById(String id) async {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postCollection,
      documentId: id,
    );
  }
}
