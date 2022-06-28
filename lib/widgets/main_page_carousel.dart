import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/screens/all_stations_screen.dart';
import 'package:testapp/screens/station_1_screen.dart';

import '../screens/station_2_screen.dart';
import '../widgets/station.dart';
import '../global/enum_data.dart';
import './custom_drawer.dart';
import '../widgets/bottom_navbar.dart';

class PageCarousel extends StatelessWidget {
  const PageCarousel({Key? key, required this.pageController})
      : super(key: key);
  final PageController pageController;

  Widget _buildPosts(BuildContext context, int index) {
    return AnimatedBuilder(
        animation: pageController,
        builder: (BuildContext ctx, Widget? widget) {
          var value = 1.0;
          if (pageController.position.haveDimensions) {
            value = pageController.page! - index;

            value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
          }
          return Center(child: widget);
        },
        child: index == 0
            ? const Station1Screen()
            : index == 1
                ? const AllStationsScreen()
                : const Station2Screen());
  }

  @override
  Widget build(BuildContext context) => PageView.builder(
        controller: pageController,
        itemCount: 3,
        itemBuilder: ((BuildContext ctx, i) {
          return _buildPosts(ctx, i);
        }),
      );
}
