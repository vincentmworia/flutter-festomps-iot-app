import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../widgets/http_exception.dart';
import '../global/global_data.dart';

class FirebaseAuthenticationHandler with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  String? _userEmail;
  Timer? _authTimer;
  String? _userFullName;

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token!;
    }
    return null;
  }

  String? get userEmail => _userEmail;

  String? get userId => _userId;

  String? get userFullName => _userFullName;

  void setUserName({required String firstname, required String lastName}) {
    _userFullName = '$firstname $lastName';
  }

  bool get isAuthenticated => token != null;

  Future<void> _authenticate(String firstName, String lastName, String email,
      String password, String operation) async {
    final uri = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:${operation}key=AIzaSyDz7iwV4d9mZGrQvrbO7mY1MEkoZb34Dv0',
    );
    final response = await http.post(uri,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }));
    final responseData = json.decode(response.body);

    if (responseData['error'] != null) {
      throw HttpException(responseData['error']['message']);
    } else {
      if (operation == 'signUp?') {
        await http.put(Uri.parse('${GlobalData.mainEndpointUrl}/Users.json'),
            body: json.encode({
              "${responseData['localId']}": {
                "email": email,
                "firstname": firstName,
                "lastname": lastName,
                "isAdmin": false,
                "isAllowedInApp": false,
              }
            }));
        return;
      }
      if (operation == 'signInWithPassword?') {
        //todo check whether the user is isALlowedInApp to attach the token to them
        //todo  Access api and ifAllowed, give token else throw HttpError AND RETURN
        print('signing in');
        final userDataMain = await http.get(Uri.parse(
            '${GlobalData.mainEndpointUrl}/Users/${responseData['localId']}.json'));
        final usrData = json.decode(userDataMain.body);
        setUserName(
            firstname: usrData['firstname'], lastName: usrData['lastname']);
        print('here');
        if ((usrData["isAllowedInApp"] as bool) == false) {
          throw HttpException('NOT_ALLOWED');
          return;
        }
        _token =
            usrData["isAllowedInApp"] as bool ? responseData['idToken'] : null;
        _userId = responseData['localId'];
        _userEmail = responseData['email'];
        _expiryDate = DateTime.now().add(Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ));
        // if (_token != null && _userId != null && _expiryDate != null) {
        //   _autoLogout();
        // }
      }
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate?.toIso8601String(),
      'userEmail': _userEmail,
    }) /*as String*/;
    prefs.setString('userData', userData);
  }

  Future<void> signup(
      String firstName, String lastName, String email, String password) async {
    return _authenticate(firstName, lastName, email, password, 'signUp?');
  }

  Future<void> login(
      String firstName, String lastName, String email, String password) async {
    return _authenticate(
        firstName, lastName, email, password, 'signInWithPassword?');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
// TODO CHECK WHETHER IS ALLOWED TO THE SERVER
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    _userEmail = extractedUserData['userEmail'];
    // _autoLogout();

    notifyListeners();
    return true;
  }

  void logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.remove(
        'userData'); // - Removes specific item in the shared preferences API
  }

// void _autoLogout() {
//   if (_authTimer != null) {
//     _authTimer!.cancel(); // Cancels the previous timer and re-initializes it
//   }
//   final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
//   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
// }
}
