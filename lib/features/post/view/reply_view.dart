import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/features/post/controller/post_controller.dart';
import 'package:socially/features/post/widgets/post_card.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../constants/constants.dart';
import '../../../models/post_model.dart';

class ReplyScreen extends ConsumerWidget {
  static route(Post post) => MaterialPageRoute(
        builder: (context) => ReplyScreen(
          post: post,
        ),
      );
  final Post post;
  const ReplyScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: Column(
        children: [
          PostCard(post: post),
          ref.watch(getRepliesToPostProvider(post)).when(
                data: (posts) {
                  return ref.watch(getLatestPostProvider).when(
                        data: (data) {
                          final latestPost = Post.fromMap(data.payload);
                          bool isPostAlreadyPresent = false;
                          for (final postModel in posts) {
                            if (postModel.id == latestPost.id) {
                              isPostAlreadyPresent = true;
                              break;
                            }
                          }
                          if (!isPostAlreadyPresent &&
                              latestPost.repliedTo == post.id) {
                            if (data.events.contains(
                                'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.postCollection}.documents.*.create')) {
                              posts.insert(0, Post.fromMap(data.payload));
                            } else if (data.events.contains(
                                'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.postCollection}.documents.*.update')) {
                              posts.insert(0, Post.fromMap(data.payload));
                              // get id of post
                              final startingPoint =
                                  data.events[0].lastIndexOf('documents.');
                              final endPoint =
                                  data.events[0].lastIndexOf('.update');
                              final postId = data.events[0]
                                  .substring(startingPoint + 10, endPoint);

                              var post = posts
                                  .where((element) => element.id == postId)
                                  .first;

                              final postIndex = posts.indexOf(post);
                              posts.removeWhere(
                                  (element) => element.id == postId);

                              post = Post.fromMap(data.payload);
                              posts.insert(postIndex, post);
                            }
                          }

                          return Expanded(
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return PostCard(post: posts[index]);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          errorText: error.toString(),
                        ),
                        loading: () {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return PostCard(post: posts[index]);
                              },
                            ),
                          );
                        },
                      );
                },
                error: (error, stackTrace) => ErrorText(
                  errorText: error.toString(),
                ),
                loading: () => const Loader(),
              ),
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) {
          ref.read(postControllerProvider.notifier).sharePost(
            images: [],
            text: value,
            context: context,
            repliedTo: post.id,
            repliedToUserId: post.uid,
          );
        },
        decoration: const InputDecoration(
          hintText: "Post your reply",
        ),
      ),
    );
  }
}
