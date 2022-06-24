import 'package:flutter/material.dart';

import '../widgets/custom_drawer.dart';

class InputOutputScreen extends StatelessWidget {
  const InputOutputScreen({Key? key}) : super(key: key);
  static const routeName = '/input_output_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('I/O PAGE'),
          ),
          drawer: const CustomDrawer(),
          body: const Center(
            child: Text('I/O SCREEN'),
          ),
        ));
  }
}
