import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socially/constants/assets_constants.dart';
import '../features/explore/view/explore_view.dart';
import '../features/post/widgets/post_list.dart';
import '../theme/pallete.dart';

class UiConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    PostList(),
    ExploreView(),
    Text('Notification Screen '),
  ];
}
