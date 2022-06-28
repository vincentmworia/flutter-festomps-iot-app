import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/custom_drawer.dart';
import '../models/user.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);
  static const routeName = '/admin_screen';

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late User loggedInUser;
  late List<User> userData;
  var _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      final adminData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      loggedInUser = adminData['current_user'] as User;
      userData = adminData['users_data'] as List<User>;
      _hasInitialized = true;
    }
  }

  // todo StreamBuilder to monitor new users, LOGGED IN USERS, ONLINE USERS, TIME SPENT, DELETE USERS

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('ADMIN'),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: Text('''
        USER DATA:
      ID:  ${loggedInUser.localId}
      FIRST NAME:  ${loggedInUser.localId}
      LAST NAME:  ${loggedInUser.firstname}
     IS ADMIN:  ${loggedInUser.isAdmin}
     IS ALLOWED IN APP:  ${loggedInUser.isAllowedInApp}
     IS ONLINE:  ${loggedInUser.isOnline} 
      LOGIN TIME:  ${loggedInUser.loggedInTime} 
      LOGIN DETAILS: ${loggedInUser.loginDetails.map((e) =>  '''
    {Login Time: ${DateFormat.yMMMd().format((DateTime.parse(e['login'])))}
     Logout Time: ${DateFormat.yMMMd().format((DateTime.parse(e['logout'])))}''').toList()} }
        '''),
      ),
    ));
  }
}
