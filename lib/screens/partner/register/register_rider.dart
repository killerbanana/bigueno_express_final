import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:biguenoexpress/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RegisterRider extends StatefulWidget {
  static String routeName = "/register_rider";
  @override
  _RegisterRiderState createState() => _RegisterRiderState();
}

class _RegisterRiderState extends State<RegisterRider> {
  TextEditingController _riderNameController;
  TextEditingController _riderAddressController;
  TextEditingController _riderOpenHourController;

  final _formKey = GlobalKey<FormState>();
  final RegExp _emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final FirebaseServices _firebaseServices = FirebaseServices();

  Users user;

  CollectionReference merchant =
      FirebaseFirestore.instance.collection('partner');

  final List<String> errors = [];
  bool loading = false;

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
    _riderNameController = TextEditingController();
    _riderAddressController = TextEditingController();
    _riderOpenHourController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _riderNameController.dispose();
    _riderAddressController.dispose();
    _riderOpenHourController.dispose();
    super.dispose();
  }

  Future<void> addRider() {
    return merchant
        .doc(user.uid)
        .set({
          'rider name': _riderNameController.text,
          'address': _riderAddressController.text,
          'available hours': _riderOpenHourController.text,
          'category': 'Rider'
        })
        .then((value) => print("Rider Added"))
        .catchError((error) => print("Failed to add Rider: $error"));
  }

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Register as Rider'),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextFormField(
                controller: _riderNameController,
                style: TextStyle(color: Colors.black87),
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
                        const BorderSide(color: Colors.black87, width: 0.0),
                  ),
                  hintText: "Enter your name",
                  hintStyle: TextStyle(color: Colors.black87),
                  prefixIcon: Icon(
                    FontAwesomeIcons.shopify,
                    color: Colors.black87,
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
                controller: _riderAddressController,
                style: TextStyle(color: Colors.black87),
                validator: (value) {
                  if (value.isNotEmpty) {
                    removeError();
                  }
                  return null;
                },
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        const BorderSide(color: Colors.black87, width: 0.0),
                  ),
                  hintText: "Enter your address",
                  hintStyle: TextStyle(color: Colors.black87),
                  prefixIcon: Icon(
                    FontAwesomeIcons.mapMarker,
                    color: Colors.black87,
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
                controller: _riderOpenHourController,
                style: TextStyle(color: Colors.black87),
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
                        const BorderSide(color: Colors.black87, width: 0.0),
                  ),
                  hintText: "Enter Start Time",
                  hintStyle: TextStyle(color: Colors.black87),
                  prefixIcon: Icon(
                    FontAwesomeIcons.clock,
                    color: Colors.black87,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            loading
                ? CircularProgressIndicator()
                : RoundedButton(
                    btnText: 'REGISTER',
                    press: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        setState(() {
                          loading = true;
                        });

                        await _firebaseServices.addRiders(user.uid, _riderNameController.text, _riderAddressController.text, _riderOpenHourController.text);
                        Navigator.pop(context);
                        setState(() {
                          loading = false;
                          addError(error: 'Invalid Username or Pass');
                        });
                      }
                    },
                  ),
          ],
        ),
      )),
    );
  }
}
