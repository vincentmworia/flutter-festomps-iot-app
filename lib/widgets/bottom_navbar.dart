import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  //todo provider to alter accordingly from server
  @override
  Widget build(BuildContext context) {
    const plcConn = true;
    const wifiConn = false;
    const internetConn = true;
    const phoneConn = wifiConn || internetConn ? true : false;
    const connUsers = 3;
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      unselectedItemColor: Theme.of(context).primaryColor,
      selectedItemColor: Theme.of(context).primaryColor,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(plcConn
              ? Icons.check_box_outlined
              : Icons.indeterminate_check_box_outlined),
          tooltip: 'PLC CONNECTION:\t${plcConn ? 'ON' : 'OFF'}',
          label: 'PLC CONN:\t${plcConn ? 'ON' : 'OFF'}',
        ),
        BottomNavigationBarItem(
          icon: Icon(wifiConn
              ? Icons.wifi
              : internetConn
                  ? Icons.signal_cellular_alt_rounded
                  : Icons.cancel),
          label: 'PHONE CONN:\t${phoneConn ? 'ON' : 'OFF'}',
          tooltip: 'PHONE CONNECTION:\t${phoneConn ? 'ON' : 'OFF'}',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'CONN USERS:\t$connUsers',
          tooltip: 'CONNECTED USERS:\t$connUsers',
        ),
      ],
    );
  }
}
