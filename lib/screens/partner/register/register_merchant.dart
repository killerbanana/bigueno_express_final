import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:biguenoexpress/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RegisterMerchant extends StatefulWidget {
  static String routeName = "/register_merchant";

  @override
  _RegisterMerchantState createState() => _RegisterMerchantState();
}

class _RegisterMerchantState extends State<RegisterMerchant> {
  TextEditingController _shopNameController;
  TextEditingController _shopAddressController;
  TextEditingController _shopOpenHourController;

  FirebaseServices _firebaseServices  = FirebaseServices();

  Users user;

  CollectionReference merchant =
      FirebaseFirestore.instance.collection('partner');

  final _formKey = GlobalKey<FormState>();
  final RegExp _emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

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
    _shopNameController = TextEditingController();
    _shopAddressController = TextEditingController();
    _shopOpenHourController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _shopAddressController.dispose();
    _shopOpenHourController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Register as Merchant'),
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
                  controller: _shopNameController,
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
                    hintText: "Enter store name",
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
                  controller: _shopAddressController,
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
                    hintText: "Enter shop address",
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
                  controller: _shopOpenHourController,
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
                    hintText: "Enter Opening Hours",
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
                          await _firebaseServices.addMerchants(user.uid, _shopNameController.text, _shopAddressController.text, _shopOpenHourController.text);
                          Navigator.pop(context);
                          setState(() {
                            loading = false;
                            addError(error: 'Error');
                          });
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
