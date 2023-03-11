import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/core/enums/post_type_enum.dart';
import 'package:socially/features/auth/controller/auth_controller.dart';
import 'package:socially/features/post/widgets/hashtag_text.dart';
import 'package:socially/features/post/widgets/post_icon_button.dart';
import 'package:socially/theme/pallete.dart';
import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../constants/assets_constants.dart';
import '../../../models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'carousel_image.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(post.uid)).when(
          data: (user) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic),
                        radius: 35,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // retweeted
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
                          // replied to
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  onTap: () {},
                                ),
                                PostIconButton(
                                  pathName: AssetsConstants.likeOutlinedIcon,
                                  text: post.likes.length.toString(),
                                  onTap: () {},
                                ),
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
            );
          },
          error: (error, stackTrace) => ErrorText(
            errorText: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
