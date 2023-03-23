import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/error_page.dart';
import '../../../constants/appwrite_constants.dart';
import '../../../models/user_model.dart';
import '../controller/user_profile_controller.dart';
import '../widgets/user_profile.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
        builder: (context) => UserProfileView(
          userModel: userModel,
        ),
      );
  final UserModel userModel;
  const UserProfileView({
    super.key,
    required this.userModel,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyOfUser = userModel;
    return Scaffold(
      body: ref.watch(getLatestUserProfileDataProvider).when(
            data: (data) {
              if (data.events.contains(
                'databases.*.collections.${AppwriteConstants.usersCollection}.documents.${copyOfUser.uid}.update',
              )) {
                copyOfUser = UserModel.fromMap(data.payload);
              }
              return UserProfile(user: copyOfUser);
            },
            error: (error, stackTrace) => ErrorText(
              errorText: error.toString(),
            ),
            loading: () {
              return UserProfile(user: copyOfUser);
            },
          ),
    );
  }
}
