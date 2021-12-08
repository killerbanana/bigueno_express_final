import 'dart:io';

import 'package:biguenoexpress/models/products.dart';
import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/services/auth.dart';
import 'package:biguenoexpress/services/firebase_api.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:biguenoexpress/widgets/rounded_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class FoodDeliveryEditProduct extends StatefulWidget {
  static String routeName = "/foodDeliveryEditProduct";

  final String productId;
  final Products product;

  const FoodDeliveryEditProduct({Key key, this.productId, this.product})
      : super(key: key);

  @override
  _FoodDeliveryEditProductState createState() =>
      _FoodDeliveryEditProductState();
}

class _FoodDeliveryEditProductState extends State<FoodDeliveryEditProduct> {
  TextEditingController _productNameController;
  TextEditingController _productPriceController;
  TextEditingController _productDescController;
  TextEditingController _productStockController;
  TextEditingController _productCategoryController;
  TextEditingController _productDiscountController;

  FirebaseServices _firebaseServices = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool remember = false;
  final List<String> errors = [];
  bool loading = false;

  double discountedPrice = 0;
  int off = 0;
  Users user;

  UploadTask task;
  File file;

  String url;
  String _productGroupValue = "Standard Delivery";
  String _discountGroupValue = "No Discount";
  List<String> _delivery = ["Standard Delivery", "Free Delivery"];
  List<String> _discount = ["No Discount", "With Discount"];

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
    _productNameController = TextEditingController();
    _productPriceController = TextEditingController();
    _productDescController = TextEditingController();
    _productStockController = TextEditingController();
    _productCategoryController = TextEditingController();
    _productDiscountController = TextEditingController();
    if(widget.product.percentOff != 0) {
      _discountGroupValue = "With Discount";
      _productDiscountController.text = widget.product.percentOff.toString();
    }
    _productNameController.text = widget.product.productName;
    _productPriceController.text = widget.product.price.toString();
    _productDescController.text = widget.product.description;
    _productStockController.text = widget.product.stock.toString();
    url = widget.product.imgUrl;
    super.initState();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _productDescController.dispose();
    _productStockController.dispose();
    _productCategoryController.dispose();
    _productDiscountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage my Products'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                          border:
                              Border.all(width: 1, style: BorderStyle.solid),
                        ),
                        child: url == null
                            ? Center(child: Text('Add Photo'))
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
                  controller: _productNameController,
                  style: TextStyle(color: Colors.black54),
                  validator:
                      RequiredValidator(errorText: 'Product name is required'),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide:
                          const BorderSide(color: Colors.black54, width: 0.0),
                    ),
                    hintText: "Enter Product Name",
                    hintStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(
                      CupertinoIcons.pencil,
                      color: Colors.black54,
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
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _productPriceController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black54),
                  validator:
                      RequiredValidator(errorText: 'Product price is required'),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide:
                          const BorderSide(color: Colors.black54, width: 0.0),
                    ),
                    hintText: "Enter Price",
                    hintStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(
                      CupertinoIcons.money_dollar,
                      color: Colors.black54,
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
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _productDescController,
                  style: TextStyle(color: Colors.black54),
                  validator: RequiredValidator(
                      errorText: 'Product description is required'),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide:
                          const BorderSide(color: Colors.black54, width: 0.0),
                    ),
                    hintText: "Enter Product Description",
                    hintStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(
                      CupertinoIcons.paperclip,
                      color: Colors.black54,
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
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _productStockController,
                  style: TextStyle(color: Colors.black54),
                  validator:
                      RequiredValidator(errorText: 'Product stock is required'),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide:
                          const BorderSide(color: Colors.black54, width: 0.0),
                    ),
                    hintText: "Enter Product Stock",
                    hintStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(
                      CupertinoIcons.time,
                      color: Colors.black54,
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
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: RadioGroup<String>.builder(
                  direction: Axis.horizontal,
                  groupValue: _productGroupValue,
                  onChanged: (value) => setState(() {
                    _productGroupValue = value;
                  }),
                  items: _delivery,
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: RadioGroup<String>.builder(
                  direction: Axis.horizontal,
                  groupValue: _discountGroupValue,
                  onChanged: (value) => setState(() {
                    if (value == "No Discount") {
                      _productDiscountController.clear();
                    }
                    _discountGroupValue = value;
                  }),
                  items: _discount,
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _discountGroupValue == "With Discount"
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextFormField(
                        controller: _productDiscountController,
                        style: TextStyle(color: Colors.black54),
                        keyboardType: TextInputType.number,
                        validator: MultiValidator(
                          [
                            RequiredValidator(
                                errorText: 'Discount % is required'),
                            RangeValidator(
                                min: 1, max: 100, errorText: "Invalid discount percentage. Enter 1% ~ 100%")
                          ],
                        ),
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: const BorderSide(
                                color: Colors.black54, width: 0.0),
                          ),
                          hintText: "Enter Product Discount Percent",
                          hintStyle: TextStyle(color: Colors.black54),
                          prefixIcon: Icon(
                            CupertinoIcons.percent,
                            color: Colors.black54,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    )
                  : Text(''),
              SizedBox(
                height: 20,
              ),
              loading
                  ? CircularProgressIndicator()
                  : RoundedButton(
                      btnText: 'UPDATE THIS PRODUCT',
                      press: () async {
                        if (!_formKey.currentState.validate() && url == null) {
                          Fluttertoast.showToast(
                              msg: "Product image is required",
                              backgroundColor: Colors.red);
                          return;
                        } else {
                          try {
                            setState(() {
                              loading = true;
                            });

                            if (_productDiscountController.text.isNotEmpty &&
                                _productPriceController.text.isNotEmpty) {
                              double dprice = 0.0;

                              dprice = ( double.parse(_productDiscountController.text) / 100 ) * double.parse(_productPriceController.text);

                              discountedPrice = double.parse(_productPriceController.text) - dprice;

                              off = int.parse(_productDiscountController.text);

                              dynamic result = await _firebaseServices
                                  .addFoodDeliveryDiscount(
                                      user.uid,
                                      int.parse(
                                          _productDiscountController.text));
                            } else {
                              off = 0;
                              discountedPrice =
                                  double.parse(_productPriceController.text);
                            }

                            dynamic result = await _firebaseServices
                                .updateProductFoodDelivery(
                                    user.uid,
                                    _productNameController.text,
                                    int.parse(_productPriceController.text),
                                    _productDescController.text,
                                    int.parse(_productStockController.text),
                                    url,
                                    widget.productId,
                                    off,
                                    discountedPrice);
                            _formKey.currentState.reset();
                            Fluttertoast.showToast(
                                msg: result.toString(),
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.greenAccent,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            setState(() {
                              loading = false;
                            });
                          } catch (e) {}
                        }
                      },
                    ),
              SizedBox(
                height: 30,
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
