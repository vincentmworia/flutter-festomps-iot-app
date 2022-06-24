import 'package:flutter/material.dart';

import '../global/enum_data.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/station.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
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
          'FESTO MPS',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 10.0,
          ),
        ),
        bottom: TabBar(
            // isScrollable: false, todo
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            labelStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
            indicatorWeight: 3.0,
            unselectedLabelStyle: const TextStyle(fontSize: 18.0),
            tabs: const [
              Tab(
                text: 'DISTRI-\nBUTION',
              ),
              Tab(
                text: '\t\t\t\t\t\tALL\nSTATIONS',
              ),
              Tab(text: 'SORTING'),
            ]),
      ),
      drawer: const CustomDrawer(),
      body: TabBarView(controller: _tabController, children: const [
        StationPage(Station.distribution),
        Center(
          child: Text('ALL STATIONS'),
        ),
        StationPage(Station.sorting),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).primaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.indeterminate_check_box_outlined),
            // icon: Icon(Icons.check_box_outlined),
            tooltip: 'PLC CONNECTION:\tOFF',
            label: 'PLC CONN:\tOFF',
          ),
          BottomNavigationBarItem(
            icon:
                // Icon(Icons.signal_cellular_alt_rounded),
                // Icon(Icons.wifi),
                Icon(Icons.cancel),
            label: 'PHONE CONN:\tOFF',
            tooltip: 'PHONE CONNECTION:\tOFF',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'CONN USERS:\t7',
            tooltip: 'CONNECTED USERS:\t7',
          ),
        ],
      ),
    ));
  }
}
