import 'dart:io';

import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/services/firebase_api.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:biguenoexpress/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterFoodDelivery extends StatefulWidget {
  static String routeName = "/register_food";

  @override
  State<RegisterFoodDelivery> createState() => _RegisterFoodDeliveryState();
}

class _RegisterFoodDeliveryState extends State<RegisterFoodDelivery> {
  TextEditingController _shopNameController;
  TextEditingController _shopAddressController;
  TextEditingController _shopOpenHourController;
  TextEditingController _shopDescriptionController;
  TextEditingController _shopDeliveryController;

  FirebaseServices _firebaseServices = FirebaseServices();

  UploadTask task;
  File file;

  String url = "";

  Users user;

  CollectionReference foodDelivery =
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
    _shopDescriptionController = TextEditingController();
    _shopDeliveryController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _shopAddressController.dispose();
    _shopOpenHourController.dispose();
    _shopDescriptionController.dispose();
    _shopDeliveryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Register as Food Delivery'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
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
                          border:
                              Border.all(width: 1, style: BorderStyle.solid),
                        ),
                        child: url == ""
                            ? Center(child: Text('Add Logo'))
                            : Image.network(url),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextButton(
                          onPressed: selectFile,
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue)),
                          child: Text(
                            'Browse',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              task != null ? buildUploadStatus(task) : Container(),
              Divider(thickness: 20),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _shopNameController,
                  style: TextStyle(color: Colors.black87),
                  validator:
                      RequiredValidator(errorText: "Store name is required"),
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
                  validator:
                      RequiredValidator(errorText: "Store address is required"),
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
                  validator:
                      RequiredValidator(errorText: "Opening hour is required"),
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
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _shopDescriptionController,
                  style: TextStyle(color: Colors.black87),
                  validator:
                      RequiredValidator(errorText: "Description is required"),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide:
                          const BorderSide(color: Colors.black87, width: 0.0),
                    ),
                    hintText: "Enter Store Description",
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
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _shopDeliveryController,
                  style: TextStyle(color: Colors.black87),
                  validator:
                      RequiredValidator(errorText: "Delivery time is required"),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide:
                          const BorderSide(color: Colors.black87, width: 0.0),
                    ),
                    hintText: "Enter Estimated Delivery Time",
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
                        if (url.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "LOGO IS REQUIRED",
                              backgroundColor: Colors.red);
                          return;
                        }
                        if (_formKey.currentState.validate() &&
                            url.isNotEmpty) {
                          _formKey.currentState.save();
                          setState(() {
                            loading = true;
                          });
                          await _firebaseServices.addFoodDelivery(
                              user.uid,
                              _shopNameController.text,
                              _shopAddressController.text,
                              _shopOpenHourController.text,
                              url,
                              _shopDescriptionController.text,
                              0,
                              _shopDeliveryController.text);
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;
    setState(() {
      file = File(path);
      uploadFile();
    });
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    url = urlDownload;
    setState(() {});
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
