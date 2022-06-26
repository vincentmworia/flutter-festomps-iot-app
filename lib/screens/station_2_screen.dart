import 'package:flutter/material.dart';

import '../widgets/bottom_navbar.dart';
import '../global/enum_data.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/station.dart';

class Station2Screen extends StatelessWidget {
  const Station2Screen({Key? key}) : super(key: key);
  static const routeName = '/station_2_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        centerTitle: true,
        title: const Text(
          'SORTING STATION',
        ),
      ),
      drawer: const CustomDrawer(),
      body: const StationPage(Station.sorting),
      bottomNavigationBar: const BottomNavBar(),
    ));
  }
}
