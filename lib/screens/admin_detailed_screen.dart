import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/logged_in_user.dart';
import '../global/global_data.dart';
import '../models/user.dart';

class AdminUserDetailsScreen extends StatefulWidget {
  const AdminUserDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/admin_user_details_screen';

  @override
  State<AdminUserDetailsScreen> createState() => _AdminUserDetailsScreenState();
}

class _AdminUserDetailsScreenState extends State<AdminUserDetailsScreen> {
  var _hasInitialized = false;
  late User user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      user = ModalRoute.of(context)!.settings.arguments as User;
      user.loginDetails = (user.loginDetails).map((e) => e).toList();
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

  TableRow _tableRowHeader(String key, String value) =>
      TableRow(children: <Widget>[
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              key,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              value,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]);

  TableRow _tableRowLogin({
    required String key,
    required String login,
    required String logout,
    required String timeSpent,
  }) =>
      TableRow(children: <Widget>[
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              key,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              login,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              logout,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              timeSpent,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]);

  void _showDialog({
    required String title,
    required String content,
    required BuildContext ctx,
    required bool deleteUser,
    required bool makeAdmin,
  }) async {
    return await showDialog(
        context: ctx,
        builder: (ctx) => AlertDialog(
              title: Text(title),
              content: Text(
                content,
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (makeAdmin) {
                        user.isAdmin = true;
                        await http
                            .patch(
                              Uri.parse(
                                  '${GlobalData.mainEndpointUrl}/Users/${user.localId}.json'),
                              body: json.encode(
                                {'isAdmin': true},
                              ),
                            )
                            .then((_) => Navigator.of(ctx).pop());
                      }
                      //todo attach token
                      if (deleteUser) {
                        await http
                            .delete(Uri.parse(
                                '${GlobalData.mainEndpointUrl}/Users/${user.localId}.json'))
                            .then((_) {
                          Navigator.of(ctx).pop();
                        });
                      }
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.green, fontSize: 20.0),
                    )),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.red, fontSize: 20.0),
                  ),
                ),
              ],
            ));
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.day, from.hour, from.minute, from.second);
    to = DateTime(to.day, to.hour, to.minute, to.second);
    return (to.difference(from).inHours).round();
  }

  @override
  Widget build(BuildContext context) {
    var i = -1;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text('${user.firstname}\t${user.lastname}')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _title('Profile'),
                Card(
                  child: Table(
                      border: TableBorder.all(),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        _tableRowHeader('Email:', user.email),
                        _tableRowHeader('First Name:', user.firstname),
                        _tableRowHeader('Last Name:', user.lastname),
                        _tableRowHeader('Role:',
                            user.isAdmin ? 'Administrator' : 'Operator'),
                        _tableRowHeader(
                            'Status:', user.isOnline ? 'Online' : 'Offline'),
                      ]),
                ),
                const SizedBox(
                  height: 25,
                ),
                if (Provider.of<LoggedInUser>(context, listen: false)
                        .loggedInUser
                        .localId !=
                    user.localId)
                  Consumer<LoggedInUser>(
                    builder: (_, loggedUser, child) =>
                        loggedUser.loggedInUser.localId == user.localId
                            ? const Center()
                            : Row(
                                mainAxisAlignment: user.isAdmin
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.spaceBetween,
                                children: [
                                  if (!user.isAdmin)
                                    SizedBox(
                                      height: 50,
                                      child: ElevatedButton.icon(
                                        onPressed: () => _showDialog(
                                          title:
                                              'Make ${user.firstname} an admin?',
                                          content:
                                              'Email:  ${user.email}\nFirst Name:  ${user.firstname}\nLast Name:  ${user.lastname}',
                                          deleteUser: false,
                                          makeAdmin: true,
                                          ctx: context,
                                        ),
                                        icon: const Icon(
                                            Icons.admin_panel_settings_rounded),
                                        label: const Text(' Make Admin '),
                                      ),
                                    ),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _showDialog(
                                        title: 'Delete ${user.firstname}?',
                                        content:
                                            'Email:  ${user.email}\nFirst Name:  ${user.firstname}\nLast Name:  ${user.lastname}',
                                        deleteUser: true,
                                        makeAdmin: false,
                                        ctx: context,
                                      ),
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Delete User'),
                                    ),
                                  ),
                                ],
                              ),
                  ),
                _title('Login Details'),
                Expanded(
                  child: ListView(children: [
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(3),
                        3: FlexColumnWidth(2),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        _tableRowLogin(
                            key: 'No',
                            login: 'Login',
                            logout: 'Logout',
                            timeSpent: 'Duration'),
                        ...((user.loginDetails).map((e) {
                          i++;
                          var timeInMin = DateTime.parse(e['logout'])
                              .difference(DateTime.parse(e['login']))
                              .inMinutes
                              .toString();
                          var timeInSec = DateTime.parse(e['logout'])
                              .difference(DateTime.parse(e['login']))
                              .inSeconds
                              .toString();
                          var timeInHrs = DateTime.parse(e['logout'])
                              .difference(DateTime.parse(e['login']))
                              .inHours
                              .toString();
                          return _tableRowLogin(
                            key: i == 0 ? '-' : i.toString(),
                            login:
                                '${DateFormat.yMMMEd().format(DateTime.parse(e['login']))}\n${DateFormat.jm().format(DateTime.parse(e['login']))}',
                            logout:
                                '${DateFormat.yMMMEd().format(DateTime.parse(e['logout']))}\n${DateFormat.jm().format(DateTime.parse(e['logout']))}',
                            timeSpent: (timeInMin == '0' && timeInHrs == '0')
                                ? '$timeInSec sec'
                                : timeInHrs == '0'
                                    ? '$timeInMin min'
                                    : '$timeInSec sec',
                          );
                        }).toList())
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
