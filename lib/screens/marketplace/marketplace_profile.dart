import 'package:biguenoexpress/services/auth.dart';
import 'package:biguenoexpress/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarketPlaceProfile extends StatefulWidget {
  static String routeName = "/marketplace_profile";

  @override
  _MarketPlaceProfileState createState() => _MarketPlaceProfileState();
}

class _MarketPlaceProfileState extends State<MarketPlaceProfile> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _displayNameController;

  final RegExp _emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage my Products'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              style: BorderStyle.solid
                          ),
                        ),
                        child: Center(child: Text('Add Photo')),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(thickness: 10),
              Container(
                height: 150,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextFormField(
                        controller: _passwordController,
                        style: TextStyle(color: Colors.black54),
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
                            borderSide: const BorderSide(color: Colors.black54, width: 0.0),
                          ),
                          hintText: "Enter Product Name",
                          hintStyle: TextStyle(color: Colors.black54),
                          prefixIcon: Icon(CupertinoIcons.pencil, color: Colors.black54,),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextFormField(
                        controller: _passwordController,
                        style: TextStyle(color: Colors.black54),
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
                            borderSide: const BorderSide(color: Colors.black54, width: 0.0),
                          ),
                          hintText: "Enter Price",
                          hintStyle: TextStyle(color: Colors.black54),
                          prefixIcon: Icon(CupertinoIcons.money_dollar, color: Colors.black54,),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              RoundedButton(btnText: 'ADD THIS PRODUCT', press: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    loading = true;
                  });
                  dynamic result = await _auth.registerWithEmailAndPassword(
                      _emailController.text, _passwordController.text, _emailController.text);

                  if (result == null || result.uid == null) {
                    setState(() {
                      loading = false;
                      addError(error: 'Invalid Username or Pass');
                    });
                  } else {

                  }
                }
              }, ),
            ],
          ),
      ),
    );
  }
}
