import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/core/core.dart';
import 'package:socially/features/auth/controller/auth_controller.dart';
import 'package:socially/features/user_profile/controller/user_profile_controller.dart';
import 'dart:io';
import '../../../common/loading_page.dart';
import '../../../theme/pallete.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EditProfileView(),
      );
  const EditProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  File? bannerImageFile;
  File? profileImageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final bannerImage = await pickImage();
    if (bannerImage != null) {
      setState(() {
        bannerImageFile = bannerImage;
      });
    }
  }

  void selectProfileImage() async {
    final profileImage = await pickImage();
    if (profileImage != null) {
      setState(() {
        profileImageFile = profileImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);
    nameController = TextEditingController(
        text: ref.watch(currentUserDetailsProvider).value?.name ?? '');
    bioController = TextEditingController(
        text: ref.watch(currentUserDetailsProvider).value?.bio ?? '');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              ref
                  .read(userProfileControllerProvider.notifier)
                  .updateUserProfile(
                    userModel: user!.copyWith(
                      name: nameController.text,
                      bio: bioController.text,
                    ),
                    context: context,
                    bannerFile: bannerImageFile,
                    profileFile: profileImageFile,
                  );
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: isLoading || user == null
          ? const Loader()
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: bannerImageFile != null
                              ? Image.file(
                                  bannerImageFile!,
                                  fit: BoxFit.fitWidth,
                                )
                              : user.bannerPic.isEmpty
                                  ? Container(
                                      color: Pallete.blueColor,
                                    )
                                  : Image.network(
                                      user.bannerPic,
                                      fit: BoxFit.fitWidth,
                                    ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: selectProfileImage,
                          child: profileImageFile != null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(
                                    profileImageFile!,
                                  ),
                                  radius: 40,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    user.profilePic,
                                  ),
                                  radius: 40,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    contentPadding: EdgeInsets.all(18),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(
                    hintText: 'Bio',
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
    );
  }
}
