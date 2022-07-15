import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './providers/activate_button.dart';
import './providers/logged_in_user.dart';
import './screens/admin_detailed_screen.dart';
import './screens/home_screen.dart';
import './screens/input_output_page.dart';
import './screens/user_authentication_screen.dart';
import './screens/profile_screen.dart';
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
        ),
        ChangeNotifierProvider(
          create: (context) => ActivateBn(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoggedInUser(),
        )
      ],
      child: Consumer<FirebaseAuthenticationHandler>(
          builder: (_, firebaseAuth, __) {
        return MaterialApp(
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
            InputOutputScreen.routeName: (_) => const InputOutputScreen(),
            ProfileScreen.routeName: (_) => const ProfileScreen(),
            AboutScreen.routeName: (_) => const AboutScreen(),
            AdminScreen.routeName: (_) => const AdminScreen(),
            AdminUserDetailsScreen.routeName: (_) =>
                const AdminUserDetailsScreen(),
          },
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (_) => MyApp._defaultScreen,
          ),
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (_) => MyApp._defaultScreen,
          ),
        );
      }),
    );
  }
}
