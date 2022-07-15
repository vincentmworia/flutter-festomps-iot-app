import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global/global_data.dart';
import '../models/user.dart';

class UserData extends StatelessWidget {
  const UserData(
    this.userMain,
    this.openUserPage, {
    Key? key,
  }) : super(key: key);
  final User userMain;
  final void Function(User user) openUserPage;

  void _showDialog(
      {required String title,
      required String content,
      required BuildContext ctx,
      required bool addUser}) async {
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
                      if (addUser) {
                        userMain.isAllowedInApp = true;
                        await http
                            .patch(
                              Uri.parse(
                                  '${GlobalData.mainEndpointUrl}/Users/${userMain.localId}.json'),
                              body: json.encode(
                                {'isAllowedInApp': true},
                              ),
                            )
                            .then((_) => Navigator.of(ctx).pop());
                      }
                      //todo attach token
                      if (!addUser) {
                        userMain.isAllowedInApp = false;
                        await http
                            .delete(Uri.parse(
                                '${GlobalData.mainEndpointUrl}/Users/${userMain.localId}.json'))
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 90,
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                child:
                    FittedBox(child: Text(userMain.firstname.substring(0, 1))),
              ),
              title: Text('${userMain.firstname}\t${userMain.lastname}'),
              subtitle: Text(userMain.email),
              trailing: userMain.isAllowedInApp && userMain.isAdmin
                  ? const Icon(Icons.admin_panel_settings)
              // const Text('⭐⭐')
                  : userMain.isAllowedInApp && !userMain.isAdmin
                      ?null
                      : !userMain.isAllowedInApp
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => _showDialog(
                                      title:
                                          'Remove ${userMain.firstname} from the app?',
                                      content:
                                          'Email:  ${userMain.email}\nFirst Name:  ${userMain.firstname}\nLast Name:  ${userMain.lastname}',
                                      addUser: false,
                                      ctx: context,
                                    ),
                                    child: const Text(
                                      '❌',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 20),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => _showDialog(
                                      title:
                                          'Allow ${userMain.firstname} into the app?',
                                      content:
                                          'Email:  ${userMain.email}\nFirst Name:  ${userMain.firstname}\nLast Name:  ${userMain.lastname}',
                                      addUser: true,
                                      ctx: context,
                                    ),
                                    child: const Text(
                                      '✔',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 24),
                                    ),
                                  ),
                                ],
                              ))
                          : const Text(''),
              onTap: !userMain.isAllowedInApp
                  ? null
                  : () => openUserPage(userMain),
            ),
          ),
        ));
  }
}
