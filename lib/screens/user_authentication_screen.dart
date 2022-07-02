import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';
import '../providers/entry_authentication.dart';
import '../widgets/http_exception.dart';

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
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  var _userEmail = '';
  var _userFirstName = '';
  var _userLastName = '';
  var _userPassword = '';

  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Widget _spacing(BoxConstraints constrains) => SizedBox(
        height: constrains.maxHeight * 0.035,
      );

  Widget _inputField({
    required Key key,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool obscureText,
    required FocusNode? focusNode,
    required bool autoCorrect,
    required bool enableSuggestions,
    required TextCapitalization? textCapitalization,
    required void Function(String)? onFieldSubmitted,
    required TextInputAction? textInputAction,
    required String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        key: key,
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        focusNode: focusNode,
        autocorrect: autoCorrect,
        enableSuggestions: enableSuggestions,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        obscureText: obscureText,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            size: 30.0,
          ),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  void _showDialog(String message) async {
    return await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              // title: const Text(''),
              content: Text(
                message,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Okay'))
              ],
            ));
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState == null || !(_formKey.currentState!.validate())) {
      return;
    }
    _formKey.currentState!.save();

    _userEmail = _userEmail.trim();
    _userFirstName = _userFirstName.trim();
    _userLastName = _userLastName.trim();
    _userPassword = _userPassword.trim();

    setState(() {
      _isLoading = true;
    });
    try {
      if (_authenticationMode == AuthenticationMode.login) {
        await Provider.of<FirebaseAuthenticationHandler>(context, listen: false)
            .login(_userFirstName, _userLastName, _userEmail, _userPassword);
      } else {
        await Provider.of<FirebaseAuthenticationHandler>(context, listen: false)
            .signup(_userFirstName, _userLastName, _userEmail, _userPassword);
        _showDialog('Signup Successful');
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'Email is already in use';
      } else if (error.message.contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.message.contains('NOT_ALLOWED')) {
        errorMessage = 'User needs to be allowed by the admin';
      } else if (error.message.contains('OPERATION_NOT_ALLOWED:')) {
        errorMessage = 'Password sign-in is disabled for this project';
      } else if (error.message.contains('TOO_MANY_ATTEMPTS_TRY_LATER:')) {
        errorMessage =
            'We have blocked all requests from this device due to unusual activity. Try again later.';
      } else if (error.message.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.message.contains('WEAK_PASSWORD')) {
        errorMessage = 'Password must be at least 6 characters';
      } else if (error.message.contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      } else if (error.message.contains('FORCE_LOGIN_SUCCESSFUL')) {
        errorMessage = 'no error';
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } else {
        errorMessage = errorMessage;
      }
      if (errorMessage != 'no error') {
        return _showDialog(errorMessage);
      }
    } catch (error) {
      const errorMessage = 'Could not authenticate you, please try again later';
      return _showDialog(errorMessage);
    } finally {
      setState(() {
        _emailController.text = '';
        _firstNameController.text = '';
        _lastNameController.text = '';
        _confirmPasswordController.text = '';
        _passwordController.text = '';

        // _authenticationMode = AuthenticationMode.login;
        _isLoading = false;
      });
    }
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal:
                    // defaultTargetPlatform==TargetPlatform.windows
                    //     ? MediaQuery.of(context).size.width * 0.3  :
                    0),
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
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            _inputField(
                              key: const ValueKey('email'),
                              controller: _emailController,
                              hintText: 'Email',
                              icon: Icons.account_box,
                              obscureText: false,
                              focusNode: _emailFocusNode,
                              autoCorrect: false,
                              enableSuggestions: false,
                              textCapitalization: TextCapitalization.none,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_authenticationMode ==
                                          AuthenticationMode.signup
                                      ? _firstNameFocusNode
                                      : _passwordFocusNode),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userEmail = value!;
                              },
                            ),
                            if ((_authenticationMode ==
                                AuthenticationMode.signup))
                              _inputField(
                                key: const ValueKey('firstName'),
                                controller: _firstNameController,
                                hintText: 'First Name',
                                icon: Icons.person,
                                obscureText: false,
                                focusNode: _firstNameFocusNode,
                                autoCorrect: false,
                                enableSuggestions: false,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onFieldSubmitted: (_) => FocusScope.of(context)
                                    .requestFocus(_authenticationMode ==
                                            AuthenticationMode.signup
                                        ? _lastNameFocusNode
                                        : _passwordFocusNode),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Last Name';
                                  }
                                  if (value.length < 5) {
                                    return 'Name must be at least 5 characters';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userFirstName = value!;
                                },
                              ),
                            if ((_authenticationMode ==
                                AuthenticationMode.signup))
                              _inputField(
                                key: const ValueKey('lastName'),
                                controller: _lastNameController,
                                hintText: 'Last Name',
                                icon: Icons.person,
                                obscureText: false,
                                focusNode: _lastNameFocusNode,
                                autoCorrect: false,
                                enableSuggestions: false,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onFieldSubmitted: (_) => FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Last Name';
                                  }
                                  if (value.length < 5) {
                                    return 'Name must be at least 5 characters';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userLastName = value!;
                                },
                              ),
                            _inputField(
                              key: const ValueKey('password'),
                              controller: _passwordController,
                              hintText: 'Password',
                              icon: Icons.lock,
                              obscureText: true,
                              focusNode: _passwordFocusNode,
                              autoCorrect: false,
                              enableSuggestions: false,
                              textCapitalization: TextCapitalization.none,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_authenticationMode ==
                                          AuthenticationMode.signup
                                      ? _confirmPasswordFocusNode
                                      : null),
                              textInputAction: _authenticationMode ==
                                      AuthenticationMode.signup
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid password.';
                                }
                                if (value.length < 7) {
                                  return 'Password must be at least 7 characters long';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userPassword = value!;
                              },
                            ),
                            if ((_authenticationMode ==
                                AuthenticationMode.signup))
                              _inputField(
                                key: const ValueKey('confirmPassword'),
                                controller: _confirmPasswordController,
                                hintText: 'Confirm Password',
                                icon: Icons.lock,
                                obscureText: true,
                                focusNode: _confirmPasswordFocusNode,
                                autoCorrect: false,
                                enableSuggestions: false,
                                textCapitalization: TextCapitalization.none,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).requestFocus(null),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a valid password.';
                                  }
                                  if (_passwordController.text !=
                                      _confirmPasswordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            GestureDetector(
                              onTap: _isLoading ? null : _submit,
                              child: Container(
                                height: 45.0,
                                margin: const EdgeInsets.only(
                                    left: 60, right: 60, top: 40),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      )
                                    : Text(
                                        (_authenticationMode ==
                                                AuthenticationMode.signup)
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
                                onTap: _isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          (_authenticationMode ==
                                                  AuthenticationMode.signup)
                                              ? _authenticationMode =
                                                  AuthenticationMode.login
                                              : _authenticationMode =
                                                  AuthenticationMode.signup;
                                        });
                                      },
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: _isLoading
                                      ? const Center()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                  color: Theme.of(context)
                                                      .primaryColor,
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
      ),
    ));
  }
}
