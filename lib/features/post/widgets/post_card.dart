import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:socially/core/enums/post_type_enum.dart';
import 'package:socially/features/auth/controller/auth_controller.dart';
import 'package:socially/features/post/controller/post_controller.dart';
import 'package:socially/features/post/widgets/hashtag_text.dart';
import 'package:socially/features/post/widgets/post_icon_button.dart';
import 'package:socially/features/user_profile/view/user_profile_view.dart';
import 'package:socially/theme/pallete.dart';
import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../constants/assets_constants.dart';
import '../../../models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../view/reply_view.dart';
import 'carousel_image.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : ref.watch(userDetailsProvider(post.uid)).when(
              data: (user) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      ReplyScreen.route(post),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  UserProfileView.route(user),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                                radius: 35,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (post.rePostedBy.isNotEmpty)
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AssetsConstants.retweetIcon,
                                        color: Pallete.greyColor,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${post.rePostedBy} reposted',
                                        style: const TextStyle(
                                          color: Pallete.greyColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '@${user.name} . ${timeago.format(
                                        post.postedAt,
                                        locale: 'en_short',
                                      )}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Pallete.greyColor,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                                if (post.repliedTo.isNotEmpty)
                                  ref
                                      .watch(
                                          getPostByIdProvider(post.repliedTo))
                                      .when(
                                        data: (repliedToPost) {
                                          final replyingToUser = ref
                                              .watch(userDetailsProvider(
                                                  repliedToPost.uid))
                                              .value;
                                          return RichText(
                                            text: TextSpan(
                                              text: 'Replying to',
                                              style: const TextStyle(
                                                color: Pallete.greyColor,
                                                fontSize: 16,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '\t@${replyingToUser?.name}',
                                                  style: const TextStyle(
                                                    color: Pallete.blueColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        error: (error, st) => ErrorText(
                                          errorText: error.toString(),
                                        ),
                                        loading: () => const SizedBox(),
                                      ),
                                HashtagText(text: post.text),
                                if (post.postType == PostType.image)
                                  CarouselImage(imageLinks: post.imageLinks),
                                if (post.link.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  AnyLinkPreview(
                                    link: 'https://${post.link}',
                                    displayDirection:
                                        UIDirection.uiDirectionHorizontal,
                                  ),
                                ],
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 10,
                                    right: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      PostIconButton(
                                        pathName: AssetsConstants.viewsIcon,
                                        text: (post.commentId.length +
                                                post.reshareCount +
                                                post.likes.length)
                                            .toString(),
                                        onTap: () {},
                                      ),
                                      PostIconButton(
                                        pathName: AssetsConstants.commentIcon,
                                        text: post.commentId.length.toString(),
                                        onTap: () {},
                                      ),
                                      PostIconButton(
                                        pathName: AssetsConstants.retweetIcon,
                                        text: post.reshareCount.toString(),
                                        onTap: () {
                                          ref
                                              .read(postControllerProvider
                                                  .notifier)
                                              .resharePost(
                                                post,
                                                currentUser,
                                                context,
                                              );
                                        },
                                      ),
                                      LikeButton(
                                        size: 25,
                                        onTap: (isLiked) async {
                                          ref
                                              .read(postControllerProvider
                                                  .notifier)
                                              .likePost(post, currentUser);
                                          return !isLiked;
                                        },
                                        isLiked: post.likes
                                            .contains(currentUser.uid),
                                        likeCount: post.likes.length,
                                        likeBuilder: (isLiked) {
                                          return isLiked
                                              ? SvgPicture.asset(
                                                  AssetsConstants
                                                      .likeFilledIcon,
                                                  color: Pallete.redColor,
                                                )
                                              : SvgPicture.asset(
                                                  AssetsConstants
                                                      .likeOutlinedIcon,
                                                  color: Pallete.greyColor,
                                                );
                                        },
                                        countBuilder:
                                            (likeCount, isLiked, text) {
                                          return Text(
                                            text,
                                            style: TextStyle(
                                              color: isLiked
                                                  ? Pallete.redColor
                                                  : Pallete.whiteColor,
                                              fontSize: 16,
                                            ),
                                          );
                                        },
                                        likeCountPadding:
                                            const EdgeInsets.all(6),
                                      ),
                                      // PostIconButton(
                                      //   pathName: AssetsConstants.likeOutlinedIcon,
                                      //   text: post.likes.length.toString(),
                                      //   onTap: () {},
                                      // ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.share_outlined,
                                          size: 25,
                                          color: Pallete.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Pallete.greyColor,
                      ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(
                errorText: error.toString(),
              ),
              loading: () => const Loader(),
            );
  }
}
