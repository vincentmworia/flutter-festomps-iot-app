import 'package:flutter/material.dart';

import '../widgets/main_page_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home_screen';
  static bool inScreen = false;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;

  @override
  void dispose() {
    super.dispose();
    HomeScreen.inScreen = false;
  }

  @override
  void initState() {
    super.initState();
    HomeScreen.inScreen = true;
    _pageController = PageController(initialPage: 1, viewportFraction: 1);
  }

  @override
  Widget build(BuildContext context) {
    return  PageCarousel(
        pageController: _pageController,
      );

  }
}
