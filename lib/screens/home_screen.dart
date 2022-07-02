import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global/enum_data.dart';
import '../providers/activate_button.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/station.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home_screen';
  static bool inScreen = false;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _stationName = 'ALL STATIONS';

  @override
  void dispose() {
    super.dispose();
    HomeScreen.inScreen = false;
  }

  @override
  void initState() {
    super.initState();
    HomeScreen.inScreen = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          centerTitle: true,
          title: Text(
            _stationName,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 5.0,
            ),
          ),
          actions: [
            Consumer<ActivateBn>(
              builder: (context, activeBn, child) => !(activeBn.bnStatus)
                  ? const Center()
                  : SizedBox(
                      width: 40.0,
                      child: Align(
                        alignment: FractionalOffset.centerLeft,
                        child: PopupMenuButton(
                          onSelected: (Station station) {
                            setState(
                              () {
                                switch (station) {
                                  case Station.distribution:
                                    _stationName = 'DISTRIBUTION STATION';
                                    break;
                                  case Station.sorting:
                                    _stationName = 'SORTING STATION';
                                    break;
                                  case Station.all:
                                    _stationName = 'ALL STATIONS';
                                    break;
                                }
                              },
                            );
                          },
                          child: Icon(Icons.more_vert,
                              color: Theme.of(context).primaryColor),
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: Station.all,
                              child: Text('Show All Stations'),
                            ),
                            PopupMenuItem(
                              value: Station.distribution,
                              child: Text('Distribution Station'),
                            ),
                            PopupMenuItem(
                              value: Station.sorting,
                              child: Text('Sorting Station'),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
        drawer: const CustomDrawer(),
        body: StationPage(_stationName == 'DISTRIBUTION STATION'
            ? Station.distribution
            : _stationName == 'SORTING STATION'
                ? Station.sorting
                : Station.all),
        // bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
