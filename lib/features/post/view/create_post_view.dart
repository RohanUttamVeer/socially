import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socially/common/common.dart';
import 'package:socially/constants/assets_constants.dart';
import 'package:socially/core/core.dart';
import 'package:socially/features/auth/controller/auth_controller.dart';
import 'package:socially/features/post/controller/post_controller.dart';
import 'package:socially/theme/pallete.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      );
  const CreatePostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final postController = TextEditingController();
  late List<File> images = [];
  @override
  void dispose() {
    super.dispose();
    postController.dispose();
  }

  void sharePost() {
    ref.read(postControllerProvider.notifier).sharePost(
          images: images,
          text: postController.text,
          context: context,
          repliedTo: '',
          repliedToUserId: '',
        );
    Navigator.pop(context);
  }

  onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = ref.watch(currentUserDetailsProvider).value;
    var isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        actions: [
          RoundedSmallButton(
            onTap: sharePost,
            label: 'Post',
            bgColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          ),
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        CircleAvatar(
                          backgroundImage: NetworkImage(currentUser.profilePic),
                          radius: 30,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: postController,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: const InputDecoration(
                              hintText: "What are you up to ?!",
                              hintStyle: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                    images.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CarouselSlider(
                              items: images.map(
                                (file) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: Image.file(
                                        file,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              options: CarouselOptions(
                                height: 170,
                                enableInfiniteScroll: false,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15.0,
                right: 15.0,
              ),
              child: GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(
                  AssetsConstants.galleryIcon,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15.0,
                right: 15.0,
              ),
              child: SvgPicture.asset(
                AssetsConstants.gifIcon,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15.0,
                right: 15.0,
              ),
              child: SvgPicture.asset(
                AssetsConstants.emojiIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
