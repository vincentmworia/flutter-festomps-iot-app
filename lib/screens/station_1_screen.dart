import 'package:flutter/material.dart';

import '../global/enum_data.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/station.dart';

class Station1Screen extends StatelessWidget {
  const Station1Screen({Key? key}) : super(key: key);
static const routeName = '/station_1_screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        centerTitle: true,
        title: const Text(
          'DISTRIBUTION STATION',
        ),
      ),
      drawer: const CustomDrawer(),
      body: const StationPage(Station.distribution),
      bottomNavigationBar:  const BottomNavBar(),
    ));
  }
}
