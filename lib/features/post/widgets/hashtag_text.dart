import 'package:flutter/material.dart';
import 'package:socially/theme/pallete.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpan = [];
    text.split(' ').forEach(
      (element) {
        if (element.startsWith('#')) {
          textSpan.add(
            TextSpan(
              text: '$element ',
              style: const TextStyle(
                color: Pallete.blueColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (element.startsWith('www.') ||
            element.startsWith('https://')) {
          textSpan.add(
            TextSpan(
              text: '$element ',
              style: const TextStyle(
                color: Pallete.blueColor,
                fontSize: 18,
              ),
            ),
          );
        } else {
          textSpan.add(
            TextSpan(
              text: '$element ',
              style: const TextStyle(
                fontSize: 18,
                // color: Pallete.whiteColor,
              ),
            ),
          );
        }
      },
    );
    return RichText(
      text: TextSpan(
        children: textSpan,
      ),
    );
  }
}
