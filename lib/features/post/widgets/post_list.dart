import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/common/common.dart';
import 'package:socially/features/post/controller/post_controller.dart';

import '../../../constants/appwrite_constants.dart';
import '../../../models/post_model.dart';
import 'post_card.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getPostProvider).when(
          data: (posts) {
            return ref.watch(getLatestPostProvider).when(
                  data: (data) {
                    if (data.events.contains(
                        'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.postCollection}.documents.*.create')) {
                      posts.insert(0, Post.fromMap(data.payload));
                    }
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PostCard(post: posts[index]);
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    errorText: error.toString(),
                  ),
                  loading: () {
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PostCard(post: posts[index]);
                      },
                    );
                  },
                );
          },
          error: (error, stackTrace) => ErrorText(
            errorText: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
