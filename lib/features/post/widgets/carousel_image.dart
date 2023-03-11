import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:socially/theme/pallete.dart';

class CarouselImage extends StatefulWidget {
  final List<String> imageLinks;
  const CarouselImage({
    super.key,
    required this.imageLinks,
  });

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imageLinks.map(
                (link) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.network(
                        link,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                height: 170,
                enableInfiniteScroll: false,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 300),
                onPageChanged: ((index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageLinks.asMap().entries.map((e) {
                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Pallete.whiteColor
                        .withOpacity(_current == e.key ? 0.9 : 0.4),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
