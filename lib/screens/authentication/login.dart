import 'package:biguenoexpress/components/pallete.dart';
import 'package:biguenoexpress/screens/home/home_screen.dart';
import 'package:biguenoexpress/services/wrapper.dart';
import 'package:biguenoexpress/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:biguenoexpress/services/auth.dart';

import 'register.dart';

class LogInScreen extends StatefulWidget {
  static String routeName = "/log_in";

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _displayNameController;

  final RegExp _emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool remember = false;
  final List<String> errors = [];
  bool loading = false;

  final AuthService _auth = AuthService();

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _displayNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _loginWithFacebook() async {
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      print(facebookLoginResult);
      final userData = await FacebookAuth.instance.getUserData();

      print(facebookLoginResult);

      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken.token);
      var result = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      print(result.user.uid);

      await firestore.collection("Users").doc(result.user.uid).set({
        'email': userData['email'],
        'imgUrl': userData['picture']['data']['url'],
        'name': userData['name'],
      }, SetOptions(merge: true));
    } catch (ex) {
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/img/bg.jpg',
                  ),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black45, BlendMode.darken)),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Flexible(
                  child: Center(
                    child: Text(
                      'Bigueño \nExpress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value.isNotEmpty) {
                        removeError();
                      } else if (_emailValidatorRegExp.hasMatch(value)) {
                        removeError();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                      ),
                      hintText: "Enter your email",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        CupertinoIcons.mail,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value.isNotEmpty) {
                        removeError();
                      } else if (_emailValidatorRegExp.hasMatch(value)) {
                        removeError();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                      ),
                      hintText: "Enter your password",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        CupertinoIcons.lock,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: kBodyText,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                loading
                    ? CircularProgressIndicator()
                    : RoundedButton(
                        btnText: 'LOG IN',
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setState(() {
                              loading = true;
                            });
                            dynamic result =
                                await _auth.signInWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text);

                            if (result == null) {
                              setState(() {
                                loading = false;
                                addError(error: 'Invalid Username or Pass');
                              });
                            } else {
                              Navigator.popAndPushNamed(
                                  context, Wrapper.routeName);
                            }
                          }
                        },
                      ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text(
                    'Don`t have account? REGISTER',
                    style: kBodyText,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
