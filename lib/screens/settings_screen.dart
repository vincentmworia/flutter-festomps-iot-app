import 'package:flutter/material.dart';

import '../widgets/custom_drawer.dart';
import '../models/user.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const routeName = '/settings_screen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late User loggedInUser;
  var _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      final adminData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      loggedInUser = adminData['current_user'] as User;
      _hasInitialized = true;
    }
  }
// todo Change First and Last Name, unnecessary,  DELETE ACCOUNT<DEAUTHENTICATE AND DELETE IN USER CONSOLE>
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
      ),
      drawer: const CustomDrawer(),
      body:   Center(
        child: Text('''
        USER DATA:
      ID:  ${loggedInUser.localId}
      FIRST NAME:  ${loggedInUser.localId}
      LAST NAME:  ${loggedInUser.firstname}
     IS ADMIN:  ${loggedInUser.isAdmin}
     IS ALLOWED IN APP:  ${loggedInUser.isAllowedInApp}
     IS ONLINE:  ${loggedInUser.isOnline} 
      LOGIN TIME:  ${loggedInUser.loggedInTime} 
        '''),
      ),
    ));
  }
}
