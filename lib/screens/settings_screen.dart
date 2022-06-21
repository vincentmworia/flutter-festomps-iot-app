import 'package:flutter/material.dart';

import '../widgets/custom_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const routeName = '/settings_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text('SETTINGS SCREEN'),
      ),
    ));
  }
}
