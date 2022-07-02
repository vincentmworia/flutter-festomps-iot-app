import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:testapp/providers/logged_in_user.dart';
import 'package:testapp/screens/admin_detailed_screen.dart';
import 'package:testapp/widgets/user_data.dart';

import '../global/global_data.dart';
import '../widgets/custom_drawer.dart';
import '../models/user.dart';
import '../widgets/splash_screen.dart';

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

  late StreamController _allUsersStream;

  @override
  void initState() {
    super.initState();
    _allUsersStream = StreamController();

    Timer.periodic(const Duration(milliseconds: GlobalData.iotUpdateTime),
        (timer) {
      _getServerData();
    });
  }

  Future<void> _getServerData() async {
    final response =
        await http.get(Uri.parse('${GlobalData.mainEndpointUrl}/Users.json'));
    final usersData = json.decode(response.body) as Map<String, dynamic>;

    final allUsers = usersData.entries
        .map((e) => {
              'localId': e.key,
              ...e.value,
            })
        .toList();

    _allUsersStream.sink.add(allUsers);
  }

  @override
  void dispose() {
    super.dispose();
    // _allUsersStream.close();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      final adminData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      loggedInUser = adminData['current_user'] as User;
      Provider.of<LoggedInUser>(context,listen: false).setLoggedInUser(loggedInUser);
      userData = adminData['users_data'] as List<User>;
      _hasInitialized = true;
    }
  }

  Widget _title(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 4.0,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      );

  List<User> _usersDataList({
    required List<dynamic> allUsersData,
    required String targetMap,
    required bool condition,
  }) {
    final onlineUsers = allUsersData.map((e) {
      if (targetMap == 'isAllowedInApp') {
        if ((e[targetMap] as bool == condition)) {
          return e;
        }
      }
      if (targetMap != 'isAllowedInApp') {
        if ((e[targetMap] as bool == condition) &&
            (e['isAllowedInApp'] == true)) {
          return e;
        }
      }
    }).toList();
    onlineUsers.removeWhere((element) => element == null);
    List<User> onlineUsersList = onlineUsers
        .map((user) => User(
            localId: user['localId'],
            email: user['email'],
            firstname: user['firstname'],
            lastname: user['lastname'],
            isAdmin: user['isAdmin'],
            isAllowedInApp: user['isAllowedInApp'],
            isOnline: user['isOnline'],
            loginDetails: user['loginDetails']))
        .toList();
    return onlineUsersList;
  }

  void openUserPage(User user) {
    Navigator.of(context)
        .pushNamed(AdminUserDetailsScreen.routeName, arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('ADMIN SCREEN'),
            ),
            drawer: const CustomDrawer(),
            body: StreamBuilder(
                stream: _allUsersStream.stream,
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting) {
                    return const SplashScreen();
                  }
                  List<dynamic> allUsers = snapShot.data as List<dynamic>;

                  final onlineUsers = _usersDataList(
                      allUsersData: allUsers,
                      targetMap: 'isOnline',
                      condition: true);
                  final offlineUsers = _usersDataList(
                      allUsersData: allUsers,
                      targetMap: 'isOnline',
                      condition: false);
                  List<User> verifiedUsers = [...offlineUsers, ...onlineUsers];
                  verifiedUsers.sort((user1, user2) =>
                      user1.firstname.compareTo(user2.firstname));

                  final unverifiedUsers = _usersDataList(
                      allUsersData: allUsers,
                      targetMap: 'isAllowedInApp',
                      condition: false);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title('ONLINE\t[${onlineUsers.length}]'),
                        SizedBox(
                            height: 90.0,
                            // color: Colors.red,
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 25,
                              ),
                              padding: const EdgeInsets.only(left: 10.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: onlineUsers.length,
                              itemBuilder: (builder, index) {
                                return GestureDetector(
                                    onTap: () =>
                                        openUserPage(onlineUsers[index]),
                                    child: FittedBox(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(10.0),
                                            width: 80.0,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(0, 2),
                                                    blurRadius: 6.0,
                                                  )
                                                ]),
                                            child: Center(
                                                child: CircleAvatar(
                                              radius: 32,
                                              child: FittedBox(
                                                  child: Text(
                                                onlineUsers[index]
                                                    .firstname
                                                    .substring(0, 1),
                                                style: const TextStyle(
                                                  fontSize: 24.0,
                                                ),
                                              )),
                                            )),
                                          ),
                                          Text(
                                              '${onlineUsers[index].firstname}\t${onlineUsers[index].lastname}'),
                                        ],
                                      ),
                                    ));
                              },
                            )),
                        if (unverifiedUsers.isNotEmpty)
                          _title('VERIFY\t[${unverifiedUsers.length}]'),
                        if (unverifiedUsers.isNotEmpty)
                          Expanded(
                            flex: unverifiedUsers.length == 1 ? 1 : 2,
                            child: ListView.builder(
                                padding: const EdgeInsets.only(left: 10.0),
                                scrollDirection: Axis.vertical,
                                itemCount: unverifiedUsers.length,
                                itemBuilder: (builder, index) {
                                  return UserData(
                                      unverifiedUsers[index], openUserPage);
                                }),
                          ),
                        _title('ALL USERS\t[${verifiedUsers.length}]'),
                        Expanded(
                          flex: 3,
                          child: ListView.builder(
                              padding: const EdgeInsets.only(left: 10.0),
                              scrollDirection: Axis.vertical,
                              itemCount: verifiedUsers.length,
                              itemBuilder: (builder, index) {
                                return Container(
                                  color: verifiedUsers[index].localId ==
                                          loggedInUser.localId
                                      ? Theme.of(context).primaryColor
                                      : null,
                                  child: UserData(
                                      verifiedUsers[index], openUserPage),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                })));
  }
}
