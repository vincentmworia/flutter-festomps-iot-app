import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './screens/home_screen.dart';
import './screens/user_authentication_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/about_screen.dart';
import '../screens/admin_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _appName = 'Flutter Demo';
  static const MaterialColor _appPrimaryColor = Colors.blue;
  static const MaterialColor _appSecondaryColor = Colors.teal;
  static const _defaultScreen = UserAuthenticationScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _appName,
      theme: ThemeData(
          primaryColor: _appPrimaryColor,
          errorColor: Colors.red,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: _appPrimaryColor)
              .copyWith(secondary: _appSecondaryColor),
          appBarTheme: AppBarTheme(toolbarHeight: 70.0,
              backgroundColor: Colors.white,
              centerTitle: true,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              titleTextStyle: const TextStyle(
                color: _appPrimaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 10.0,
              ),
              actionsIconTheme: const IconThemeData(color: Colors.yellow))),
      home: _defaultScreen,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
        AboutScreen.routeName: (_) => const AboutScreen(),
        AdminScreen.routeName: (_) => const AdminScreen(),
      },
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => _defaultScreen,
      ),
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => _defaultScreen,
      ),
    );
  }
}
