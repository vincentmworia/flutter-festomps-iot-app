import 'package:flutter/material.dart';

import '../widgets/custom_drawer.dart';
import '../models/user.dart';
import '../widgets/profile_clipper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/settings_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  Widget _addRow(String title, String data) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '$title:',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 22.0,
            ),
          ),
          const SizedBox(
            height: 2.0,
          ),
          Text(
            data, //todo
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
                overflow: TextOverflow.fade),
          ),
        ],
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

// todo Change First and Last Name, unnecessary,  DELETE ACCOUNT<DEAUTHENTICATE AND DELETE IN USER CONSOLE>
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipPath(
                clipper: ProfileClipper(),
                child: const Image(
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/background_2.jpg'),
                ),
              ),
              Positioned(
                top: 50.0,
                left: 20.0,
                child: IconButton(
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).primaryColor,
                    size: 30.0,
                  ),
                ),
              ),
              Positioned(
                bottom: 10.0,
                child: Container(
                  decoration:
                      const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ]),
                  child: const ClipOval(
                    child: Image(
                      height: 120.0,
                      width: 120.0,
                      image: AssetImage(
                        'assets/images/distribution.PNG',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              '${loggedInUser.firstname}\t${loggedInUser.lastname}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                // defaultVerticalAlignment:
                // TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  _tableRowHeader('Email:', loggedInUser.email),
                  _tableRowHeader('First Name:', loggedInUser.firstname),
                  _tableRowHeader('Last Name:', loggedInUser.lastname),
                  _tableRowHeader('Role:',
                      loggedInUser.isAdmin ? 'Administrator' : 'Operator'),
                  _tableRowHeader(
                      'Status:', loggedInUser.isOnline ? 'Online' : 'Offline'),
                ]),
          )
        ],
      )),
    ));
  }
}
/*

            '''
        USER DATA:
      ID:  ${loggedInUser.localId}

      FIRST NAME:  ${loggedInUser.firstname}
      LAST NAME:  ${loggedInUser.lastname}
     IS ADMIN:  ${loggedInUser.isAdmin}
     IS ALLOWED IN APP:  ${loggedInUser.isAllowedInApp}
     IS ONLINE:  ${loggedInUser.isOnline}
      LOGIN TIME:  ${loggedInUser.loggedInTime}
        '''
*/
