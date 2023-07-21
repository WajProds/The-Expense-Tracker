import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/category_screen/category_fetcher.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    super.key,
    required NotchBottomBarController controller,
    required PageController pageController,
  })  : _controller = controller,
        _pageController = pageController;

  final NotchBottomBarController _controller;
  final PageController _pageController;

  static const name = '/category_screen';
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [Colors.black54, Color.fromARGB(255, 31, 5, 66)])),
        child: CategoryFetcher(
            controller: _controller, pageController: _pageController));
  }
}
