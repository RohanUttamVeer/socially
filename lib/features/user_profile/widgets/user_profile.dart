import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/features/auth/controller/auth_controller.dart';
import 'package:socially/features/user_profile/controller/user_profile_controller.dart';
import 'package:socially/features/user_profile/view/edit_profile_view.dart';
import 'package:socially/theme/pallete.dart';
import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../constants/appwrite_constants.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../post/controller/post_controller.dart';
import '../../post/widgets/post_card.dart';
import 'follow_count.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: ((context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: user.bannerPic.isEmpty
                            ? Container(
                                color: Pallete.blueColor,
                              )
                            : Image.network(
                                user.bannerPic,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            user.profilePic,
                          ),
                          radius: 45,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () {
                            if (currentUser.uid == user.uid) {
                              Navigator.push(
                                context,
                                EditProfileView.route(),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Pallete.whiteColor,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                          ),
                          child: Text(
                            currentUser.uid == user.uid
                                ? 'Edit Profile'
                                : 'Follow',
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@${user.name}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Pallete.greyColor,
                          ),
                        ),
                        Text(
                          user.bio,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            FollowCount(
                              count: user.following.length - 1,
                              text: 'Following',
                            ),
                            const SizedBox(width: 15),
                            FollowCount(
                              count: user.followers.length - 1,
                              text: 'Followers',
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Divider(
                          color: Pallete.whiteColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            }),
            body: ref.watch(getUserPostsProvider(user.uid)).when(
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
                            if (!isPostAlreadyPresent) {
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
                ),
          );
  }
}
