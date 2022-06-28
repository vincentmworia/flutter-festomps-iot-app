import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './screens/all_stations_screen.dart';
import './screens/home_screen.dart';
import './screens/station_1_screen.dart';
import './screens/station_2_screen.dart';
import './screens/input_output_page.dart';
import './screens/user_authentication_screen.dart';
import './screens/settings_screen.dart';
import './screens/about_screen.dart';
import './screens/admin_screen.dart';
import './widgets/splash_screen.dart';
import './providers/entry_authentication.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _appName = 'Flutter Demo';
  static const MaterialColor _appPrimaryColor = Colors.blue;
  static const MaterialColor _appSecondaryColor = Colors.cyan;
  static const _defaultScreen = UserAuthenticationScreen();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FirebaseAuthenticationHandler(),
        )
      ],
      child: Consumer<FirebaseAuthenticationHandler>(
        builder: (_, firebaseAuth, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: MyApp._appName,
          theme: ThemeData(
              primaryColor: MyApp._appPrimaryColor,
              errorColor: Colors.red,
              colorScheme:
                  ColorScheme.fromSwatch(primarySwatch: MyApp._appPrimaryColor)
                      .copyWith(secondary: MyApp._appSecondaryColor),
              appBarTheme: AppBarTheme(
                  toolbarHeight: 70.0,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  iconTheme:
                      IconThemeData(color: Theme.of(context).primaryColor),
                  titleTextStyle: const TextStyle(
                    color: MyApp._appPrimaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5.0,
                  ),
                  actionsIconTheme: const IconThemeData(color: Colors.yellow))),
          home: firebaseAuth.isAuthenticated
              ? const HomeScreen()
              : FutureBuilder(
                  future: firebaseAuth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : _defaultScreen),
          routes: {
            HomeScreen.routeName: (_) => const HomeScreen(),
            AllStationsScreen.routeName: (_) => const AllStationsScreen(),
            Station1Screen.routeName: (_) => const Station1Screen(),
            Station2Screen.routeName: (_) => const Station2Screen(),
            InputOutputScreen.routeName: (_) => const InputOutputScreen(),
            SettingsScreen.routeName: (_) => const SettingsScreen(),
            AboutScreen.routeName: (_) => const AboutScreen(),
            AdminScreen.routeName: (_) => const AdminScreen(),
          },
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (_) => MyApp._defaultScreen,
          ),
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (_) => MyApp._defaultScreen,
          ),
        ),
      ),
    );
  }
}
