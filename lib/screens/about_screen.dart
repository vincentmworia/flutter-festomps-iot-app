import 'package:flutter/material.dart';

import '../widgets/custom_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  static const routeName = '/about_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('ABOUT'),
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text('ABOUT SCREEN'),
      ),
    ));
  }
}
