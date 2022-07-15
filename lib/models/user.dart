class User {
  final String localId;
  final String email;
  final String firstname;
  final String lastname;
   bool isAdmin;
  bool isAllowedInApp;
  bool isOnline;
  DateTime? loggedInTime;
  DateTime? loggedOutTime;
  List<dynamic>? loginDetails;

  User({
    required this.localId,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.isAdmin,
    required this.isAllowedInApp,
    required this.isOnline,
    this.loggedInTime,
    this.loggedOutTime,
    required this.loginDetails,
  });

  Map<String, dynamic> toMap() => {
        "localId": localId,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "isAdmin": isAdmin,
        "isAllowedInApp": isAllowedInApp,
        "isOnline": isOnline,
        "loginDetails": [addLoginDetails()],
      };

  static User fromMap(Map<String, dynamic> user) => User(
        localId: user['localId'] as String,
        email: user['email'] as String,
        firstname: user['firstname'] as String,
        lastname: user['lastname'] as String,
        isAdmin: user['isAdmin'] as bool,
        isAllowedInApp: user['isAllowedInApp'] as bool,
        isOnline: user['isOnline'] as bool,
        loginDetails: user['loginDetails'] as List<dynamic>,
      );

  Map<String, String> addLoginDetails() => {
        "login": loggedInTime == null
            ? DateTime.now().toIso8601String()
            : (loggedInTime!.toIso8601String()),
        "logout": loggedOutTime == null
            ? DateTime.now().toIso8601String()
            : loggedOutTime!.toIso8601String(),
      };
}
