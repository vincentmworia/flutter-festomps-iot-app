import 'package:flutter/material.dart';

import './home_screen.dart';

enum AuthenticationMode {
  login,
  signup,
}

class UserAuthenticationScreen extends StatefulWidget {
  const UserAuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<UserAuthenticationScreen> createState() =>
      _UserAuthenticationScreenState();
}

class _UserAuthenticationScreenState extends State<UserAuthenticationScreen> {
  late AuthenticationMode _authenticationMode;

  // AuthenticationMode _authenticationMode = AuthenticationMode.login;

  Widget _spacing(BoxConstraints constrains) => SizedBox(
        height: constrains.maxHeight * 0.035,
      );

  Widget _inputField(
      {required String hintText,
      required IconData icon,
      required bool obscureText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            prefixIcon: Icon(
              icon,
              size: 30.0,
            )),
        obscureText: obscureText,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _authenticationMode = AuthenticationMode.login;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: double.infinity,
          height: mediaQuery.size.height -
              mediaQuery.padding.top -
              mediaQuery.padding.bottom,
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: <Widget>[
                if ((_authenticationMode == AuthenticationMode.signup))
                  _spacing(constraints),
                if ((_authenticationMode == AuthenticationMode.login))
                  // ClipPath(clipper: CurveClipper(), child:
                  Image(
                    image: const AssetImage('assets/images/background_2.jpg'),
                    width: double.infinity,
                    height: constraints.maxHeight * 0.35,
                    fit: BoxFit.cover,
                  ),
                // ),
                _spacing(constraints),
                Text(
                  'FESTO MPS',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 24.0,
                      letterSpacing: 10.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: ''),
                ),
                _spacing(constraints),
                SingleChildScrollView(
                  child: SizedBox(
                    height: (_authenticationMode == AuthenticationMode.login)
                        ? constraints.maxHeight * 0.5
                        : constraints.maxHeight * 0.8,
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          _inputField(
                              hintText: 'Email',
                              icon: Icons.account_box,
                              obscureText: false),
                          if ((_authenticationMode ==
                              AuthenticationMode.signup))
                            _inputField(
                                hintText: 'First Name',
                                icon: Icons.lock,
                                obscureText: true),
                          if ((_authenticationMode ==
                              AuthenticationMode.signup))
                            _inputField(
                                hintText: 'Last Name',
                                icon: Icons.account_box,
                                obscureText: false),
                          _inputField(
                              hintText: 'Password',
                              icon: Icons.lock,
                              obscureText: true),
                          if ((_authenticationMode ==
                              AuthenticationMode.signup))
                            _inputField(
                                hintText: 'Confirm Password',
                                icon: Icons.lock,
                                obscureText: true),
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed(HomeScreen.routeName),
                            child: Container(
                              height: 45.0,
                              margin: const EdgeInsets.only(
                                  left: 60, right: 60, top: 40),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                ((_authenticationMode ==
                                        AuthenticationMode.signup))
                                    ? 'Sign Up'
                                    : 'Login',
                                style: const TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Align(
                            alignment: FractionalOffset.center,
                            child: GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    (_authenticationMode ==
                                            AuthenticationMode.signup)
                                        ? _authenticationMode =
                                            AuthenticationMode.login
                                        : _authenticationMode =
                                            AuthenticationMode.signup;
                                  },
                                );
                              },
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      (_authenticationMode ==
                                              AuthenticationMode.login)
                                          ? 'Don\'t have an account? '
                                          : 'Already have an account? ',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      '\tClick here ',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    ));
  }
}
