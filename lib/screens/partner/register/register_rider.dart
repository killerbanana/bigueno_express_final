import 'dart:io';

import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/partner/validator/MobileNoValidator.dart';
import 'package:biguenoexpress/services/firebase_api.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:biguenoexpress/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:path/path.dart';
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
  TextEditingController _riderContactNumberController;

  final _formKey = GlobalKey<FormState>();
  final RegExp _emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final FirebaseServices _firebaseServices = FirebaseServices();

  UploadTask task;
  File file;

  String url = "";

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
    _riderContactNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _riderNameController.dispose();
    _riderAddressController.dispose();
    _riderOpenHourController.dispose();
    _riderContactNumberController.dispose();
    super.dispose();
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
                            ? Center(child: Text('Add Image'))
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
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _riderNameController,
                  style: TextStyle(color: Colors.black87),
                  validator: MultiValidator(
                    [
                      RequiredValidator(errorText: 'Name is required'),
                    ],
                  ),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide:
                          const BorderSide(color: Colors.black87, width: 0.0),
                    ),
                    hintText: "Enter your name",
                    hintStyle: TextStyle(color: Colors.black87),
                    prefixIcon: Icon(
                      Icons.account_circle,
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
                  validator: MultiValidator(
                    [
                      RequiredValidator(errorText: 'Address is required'),
                    ],
                  ),
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
                  validator: MultiValidator(
                    [
                      RequiredValidator(
                          errorText: 'Available time is required'),
                    ],
                  ),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide:
                          const BorderSide(color: Colors.black87, width: 0.0),
                    ),
                    hintText: "Enter Available Time",
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
                  controller: _riderContactNumberController,
                  style: TextStyle(color: Colors.black87),
                  validator: MultiValidator(
                    [
                      RequiredValidator(
                          errorText: 'Contact Number is required'),
                      MobileNoValidator(
                          errorText: "Mobile no must be 0912XXXXXXX"),
                    ],
                  ),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide:
                          const BorderSide(color: Colors.black87, width: 0.0),
                    ),
                    hintText: "Enter Contact Number",
                    hintStyle: TextStyle(color: Colors.black87),
                    prefixIcon: Icon(
                      FontAwesomeIcons.phone,
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
                              msg: "IMAGE IS REQUIRED",
                              backgroundColor: Colors.red);
                          return;
                        }
                        if (_formKey.currentState.validate() &&
                            url.isNotEmpty) {
                          _formKey.currentState.save();
                          setState(() {
                            loading = true;
                          });

                          await _firebaseServices.addRiders(
                              user.uid,
                              _riderNameController.text,
                              _riderAddressController.text,
                              _riderOpenHourController.text,
                              _riderContactNumberController.text,
                              url);
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
