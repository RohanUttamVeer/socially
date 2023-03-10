import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../apis/post_api.dart';
import '../../../apis/storage_api.dart';
import '../../../core/enums/post_type_enum.dart';
import '../../../core/utils.dart';
import '../../../models/post_model.dart';
import '../../auth/controller/auth_controller.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    ref: ref,
    postAPI: ref.watch(postAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
  );
});

final getPostProvider = FutureProvider((ref) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPosts();
});

final getLatestPostProvider = StreamProvider((ref) {
  final postAPI = ref.watch(postAPIProvider);
  return postAPI.getLatestPost();
});

class PostController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;

  PostController({
    required Ref ref,
    required PostAPI postAPI,
    required StorageAPI storageAPI,
  })  : _ref = ref,
        _postAPI = postAPI,
        _storageAPI = storageAPI,
        super(false);

  Future<List<Post>> getPosts() async {
    final postList = await _postAPI.getPost();
    return postList.map((post) => Post.fromMap(post.data)).toList();
  }

  void sharePost({
    required List<File> images,
    required String text,
    required BuildContext context,
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
      );
    } else {
      _shareTextTweet(
        context: context,
        text: text,
      );
    }
  }

  _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
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
    );
    final response = await _postAPI.sharePost(post);
    state = false;
    response.fold(
      (l) => showSnackBar(
        context,
        l.message,
      ),
      (r) => null,
    );
  }

  _shareTextTweet({
    required String text,
    required BuildContext context,
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
    );
    final response = await _postAPI.sharePost(post);
    state = false;
    response.fold(
      (l) => showSnackBar(
        context,
        l.message,
      ),
      (r) => null,
    );
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
