import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/core/enums/notification_type_enum.dart';
import 'package:socially/features/notifications/controller/notification_controller.dart';

import '../../../apis/post_api.dart';
import '../../../apis/storage_api.dart';
import '../../../core/enums/post_type_enum.dart';
import '../../../core/utils.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../auth/controller/auth_controller.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    ref: ref,
    postAPI: ref.watch(postAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

final getPostProvider = FutureProvider((ref) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPosts();
});
final getRepliesToPostProvider = FutureProvider.family((ref, Post post) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getRepliesToPost(post);
});

final getLatestPostProvider = StreamProvider((ref) {
  final postAPI = ref.watch(postAPIProvider);
  return postAPI.getLatestPost();
});

final getPostByIdProvider = FutureProvider.family((ref, String id) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(id);
});

class PostController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final StorageAPI _storageAPI;
  final NotificationController _notificationController;
  final Ref _ref;

  PostController({
    required Ref ref,
    required PostAPI postAPI,
    required StorageAPI storageAPI,
    required NotificationController notificationController,
  })  : _ref = ref,
        _postAPI = postAPI,
        _storageAPI = storageAPI,
        _notificationController = notificationController,
        super(false);

  Future<List<Post>> getPosts() async {
    final postList = await _postAPI.getPost();
    return postList.map((post) => Post.fromMap(post.data)).toList();
  }

  Future<Post> getPostById(String id) async {
    final post = await _postAPI.getPostById(id);
    return Post.fromMap(post.data);
  }

  void likePost(Post post, UserModel user) async {
    List<String> likes = post.likes;

    if (post.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    post = post.copyWith(likes: likes);

    final res = await _postAPI.likeTweet(post);
    res.fold((l) {
      print(l.message);
    }, (r) {
      _notificationController.createNotification(
        text: '${user.name} liked your post !',
        postId: post.id,
        notificationType: NotificationType.like,
        uid: post.uid,
      );
    });
  }

  void resharePost(
    Post post,
    UserModel currentUser,
    BuildContext context,
  ) async {
    post = post.copyWith(
      rePostedBy: currentUser.name,
      likes: [],
      commentId: [],
      reshareCount: post.reshareCount + 1,
    );

    final res = await _postAPI.updateReshareCount(post);
    res.fold(
      (l) {
        showSnackBar(
          context,
          l.message,
        );
      },
      (r) async {
        post = post.copyWith(
          id: ID.unique(),
          reshareCount: 0,
          postedAt: DateTime.now(),
        );
        final res2 = await _postAPI.sharePost(post);
        res2.fold(
          (l) {
            showSnackBar(
              context,
              l.message,
            );
          },
          (r) {
            _notificationController.createNotification(
              text: '${currentUser.name} re-posted your post !',
              postId: post.id,
              notificationType: NotificationType.repost,
              uid: post.uid,
            );
            showSnackBar(
              context,
              "Re-Posted",
            );
          },
        );
      },
    );
  }

  void sharePost({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text');
      return;
    }
    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    } else {
      _shareTextTweet(
        context: context,
        text: text,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    }
  }

  Future<List<Post>> getRepliesToPost(Post post) async {
    final document = await _postAPI.getRepliesToPost(post);
    return document.map((post) => Post.fromMap(post.data)).toList();
  }

  _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);
    final Post post = Post(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      postType: PostType.image,
      postedAt: DateTime.now(),
      likes: const [],
      commentId: const [],
      id: '',
      reshareCount: 0,
      rePostedBy: '',
      repliedTo: repliedTo,
    );
    final response = await _postAPI.sharePost(post);
    response.fold(
      (l) => showSnackBar(
        context,
        l.message,
      ),
      (r) {
        if (repliedToUserId.isNotEmpty) {
          _notificationController.createNotification(
            text: '${user.name} replied to your post !',
            postId: r.$id,
            notificationType: NotificationType.reply,
            uid: repliedToUserId,
          );
        }
      },
    );
    state = false;
  }

  _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Post post = Post(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      postType: PostType.text,
      postedAt: DateTime.now(),
      likes: const [],
      commentId: const [],
      id: '',
      reshareCount: 0,
      rePostedBy: '',
      repliedTo: repliedTo,
    );
    final response = await _postAPI.sharePost(post);
    response.fold(
      (l) => showSnackBar(
        context,
        l.message,
      ),
      (r) {
        if (repliedToUserId.isNotEmpty) {
          _notificationController.createNotification(
            text: '${user.name} replied to your post !',
            postId: r.$id,
            notificationType: NotificationType.reply,
            uid: repliedToUserId,
          );
        }
      },
    );
    state = false;
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
