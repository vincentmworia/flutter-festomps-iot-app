import 'package:flutter/foundation.dart';

import '../models/user.dart';

class LoggedInUser with ChangeNotifier{
  late User _loggedInUser ;
  User get loggedInUser=>_loggedInUser;

void setLoggedInUser(User user){
     _loggedInUser=user;
  }
}