import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

class NavigationingBar extends StatefulWidget {
  const NavigationingBar({
    super.key,
    required NotchBottomBarController controller,
    required PageController pageController,
  })  : _controller = controller,
        _pageController = pageController;

  final NotchBottomBarController _controller;
  final PageController _pageController;

  @override
  State<NavigationingBar> createState() => _NavigationingBarState();
}

class _NavigationingBarState extends State<NavigationingBar> {
  @override
  void initState() {
    PageController;

    super.initState();
  }

  @override
  void dispose() {
    PageController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedNotchBottomBar(
      notchBottomBarController: widget._controller,
      color: Colors.white,
      showLabel: false,
      notchColor: Colors.black87,
      removeMargins: false,
      bottomBarWidth: 500,
      durationInMilliSeconds: 200,
      bottomBarItems: const [
        BottomBarItem(
          inActiveItem: Icon(
            Icons.home_filled,
            color: Colors.blueGrey,
          ),
          activeItem: Icon(
            Icons.home_filled,
            color: Colors.deepPurple,
          ),
          itemLabel: 'Category Screen',
        ),
        BottomBarItem(
            inActiveItem: Icon(
              Icons.add_box,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.add_box,
              color: Colors.deepPurple,
            ),
            itemLabel: 'Add Expense'),
        BottomBarItem(
            inActiveItem: Icon(
              Icons.align_horizontal_left_rounded,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.align_horizontal_left_rounded,
              color: Colors.deepPurple,
            ),
            itemLabel: 'All Expenses'),
      ],
      onTap: (index) {
        widget._pageController.animateToPage(index,
            duration: const Duration(milliseconds: 100),
            curve: Curves.bounceInOut);
      },
    );
  }
}
