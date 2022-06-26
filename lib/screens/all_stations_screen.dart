import 'package:flutter/material.dart';

import '../global/enum_data.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/station.dart';

class AllStationsScreen extends StatelessWidget {
  const AllStationsScreen({Key? key}) : super(key: key);
  static const routeName = '/all_stations_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          centerTitle: true,
          title: Text(
            'FESTO MPS',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 10.0,
            ),
          ),
        ),
        drawer: const CustomDrawer(),
        body: const StationPage(Station.all),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
