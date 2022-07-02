import 'package:flutter/material.dart';

import '../widgets/custom_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  static const routeName = '/about_screen';

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(
      height: 20.0,
    );
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('ABOUT'),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Text(
                  'PROJECT INFORMATION:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    textBaseline: TextBaseline.ideographic,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                spacing,
                const Text(
                  'PROJECT NAME:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    textBaseline: TextBaseline.ideographic,
                  ),
                ),
                const Text(
                  'VIRTUAL COMMISSIONING AND DIGITAL TWINNING OF FESTO MECHATRONICS SYSTEM WITH INTERNET OF THINGS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                spacing,
                const Text(
                  'CREATED ON:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    textBaseline: TextBaseline.ideographic,
                  ),
                ),
                const Text(
                  '23-06-2022',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                spacing,
                const Text(
                  'AUTHOR:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    textBaseline: TextBaseline.ideographic,
                  ),
                ),
                const Text(
                  'Group 4',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                spacing,
                const Text(
                  'DESCRIPTION:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    textBaseline: TextBaseline.ideographic,
                  ),
                ),
                const Text(
                  'This project entails controlling and monitoring the Festo distribution and sorting stations remotely. Thisenables remote access of the system after designing a virtual model of Festo mechatronics system and digital twinning (the integration of the virtual model and the physical Festo mechatronics system). We then monitor the data using Internet of Things by designing a user interface.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                spacing,
                spacing,
                Text(
                  'SYSTEM INFORMATION:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    textBaseline: TextBaseline.ideographic,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Text(
                  'PLC DEVICE TYPE:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    textBaseline: TextBaseline.ideographic,
                  ),
                ),
                const Text(
                  'Simatic S7-1500',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                spacing,
                const Text(
                  'HMI DEVICE TYPE:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    textBaseline: TextBaseline.ideographic,
                  ),
                ),
                const Text(
                  'HMI Basic KTP 700',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                spacing,
                const Text(
                  'CONNECTION TYPE:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    textBaseline: TextBaseline.ideographic,
                  ),
                ),
                const Text(
                  'Profinet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                spacing,
              ],
            ),
          )),
    ));
  }
}
