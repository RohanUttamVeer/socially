import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiver/async.dart';
import 'package:socially/constants/constants.dart';
import 'package:socially/core/utils.dart';
import 'package:socially/features/post/view/create_post_view.dart';
import 'package:socially/theme/pallete.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  final appBar = UiConstants.appBar();
  int _current = 0;

  void onPageChanged(int index) {
    setState(() {
      _page = index;
    });
  }

  void startTimer() {
    CountdownTimer countDownTimer = CountdownTimer(
      const Duration(seconds: 1),
      const Duration(seconds: 1),
    );
    var sub = countDownTimer.listen(null);

    sub.onData((duration) {
      setState(() {
        _current = _current - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      sub.cancel();
    });
  }

  onCreatePost() {
    if (_current == 0) {
      startTimer();
      _current = 86400;
      Navigator.push(context, CreatePostScreen.route());
    } else {
      String strDigits(int n) => n.toString().padLeft(2, '0');
      final myDuration = Duration(seconds: _current);
      // final days = strDigits(myDuration.inDays);
      final hours = strDigits(myDuration.inHours.remainder(24));
      final minutes = strDigits(myDuration.inMinutes.remainder(60));
      final seconds = strDigits(myDuration.inSeconds.remainder(60));
      showSnackBar(
        context,
        '$hours:$minutes:$seconds remaining for next post!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _page == 0 ? appBar : null,
      body: IndexedStack(
        index: _page,
        children: UiConstants.bottomTabBarPages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreatePost,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChanged,
        backgroundColor: Pallete.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 0
                  ? AssetsConstants.homeFilledIcon
                  : AssetsConstants.homeOutlinedIcon,
              color: Pallete.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetsConstants.searchIcon,
              color: Pallete.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 2
                  ? AssetsConstants.notifFilledIcon
                  : AssetsConstants.notifOutlinedIcon,
              color: Pallete.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
