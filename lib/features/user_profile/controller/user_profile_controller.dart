import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/core/core.dart';
import 'package:socially/features/notifications/controller/notification_controller.dart';
import 'package:socially/models/user_model.dart';
import '../../../apis/post_api.dart';
import '../../../apis/storage_api.dart';
import '../../../apis/user_api.dart';
import '../../../core/enums/notification_type_enum.dart';
import '../../../models/post_model.dart';
import 'dart:io';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    postAPI: ref.watch(postAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    userAPI: ref.watch(userAPIProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

final getUserPostsProvider = FutureProvider.family((ref, String uid) async {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserPosts(uid);
});

final getLatestUserProfileDataProvider = StreamProvider((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  final NotificationController _notificationController;
  UserProfileController({
    required PostAPI postAPI,
    required StorageAPI storageAPI,
    required UserAPI userAPI,
    required NotificationController notificationController,
  })  : _postAPI = postAPI,
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        _notificationController = notificationController,
        super(false);

  Future<List<Post>> getUserPosts(String uid) async {
    final posts = await _postAPI.getUserPosts(uid);
    return posts.map((e) => Post.fromMap(e.data)).toList();
  }

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageAPI.uploadImage([bannerFile]);
      userModel = userModel.copyWith(
        bannerPic: bannerUrl[0],
      );
    }
    if (profileFile != null) {
      final profileUrl = await _storageAPI.uploadImage([profileFile]);
      userModel = userModel.copyWith(
        profilePic: profileUrl[0],
      );
    }
    final result = await _userAPI.updatedUserData(userModel);
    state = false;
    result.fold(
      (l) => showSnackBar(
        context,
        l.message,
      ),
      (r) {
        Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.push(
        //   context,
        //   UserProfileView.route(userModel),
        // );
      },
    );
  }

  void followUser({
    required UserModel user,
    required BuildContext context,
    required UserModel currentUser,
  }) async {
    // already following
    if (currentUser.following.contains(user.uid)) {
      user.followers.remove(currentUser.uid);
      currentUser.following.remove(user.uid);
    } else {
      user.followers.add(currentUser.uid);
      currentUser.following.add(user.uid);
    }

    user = user.copyWith(followers: user.followers);
    currentUser = currentUser.copyWith(
      following: currentUser.following,
    );

    final response = await _userAPI.followUser(user);

    response.fold(
      (l) => showSnackBar(
        context,
        l.message,
      ),
      (r) async {
        final res = await _userAPI.addToFollowing(currentUser);
        response.fold(
          (l) => showSnackBar(
            context,
            l.message,
          ),
          (r) {
            _notificationController.createNotification(
              text: '${currentUser.name} followed you !',
              postId: '',
              notificationType: NotificationType.follow,
              uid: user.uid,
            );
          },
        );
      },
    );
  }
}
