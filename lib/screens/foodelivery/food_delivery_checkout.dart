import 'package:biguenoexpress/models/cart.dart';
import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/partner/validator/MobileNoValidator.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class FoodDeliveryCheckout extends StatefulWidget {
  static String routeName = "/food_delivery_checkout";

  final List<Cart> myCart;
  final String storeName;
  final double total;

  const FoodDeliveryCheckout({Key key, this.myCart, this.total, this.storeName})
      : super(key: key);

  @override
  _FoodDeliveryCheckoutState createState() => _FoodDeliveryCheckoutState();
}

class _FoodDeliveryCheckoutState extends State<FoodDeliveryCheckout> {
  TextEditingController _cartDeliveryAddressController;
  TextEditingController _cartDeliveryNameController;
  TextEditingController _cartDeliveryContactController;

  Users user;
  FirebaseServices _firebaseServices = FirebaseServices();
  String seller;

  bool loading = false;
  bool loadingAll = false;
  List orders = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    functionBefore();
  }

  functionBefore() async {
    String uid = Provider.of<Users>(context, listen: false).uid;
    setState(() {
      loadingAll = true;
    });
    _cartDeliveryAddressController = TextEditingController();
    _cartDeliveryNameController = TextEditingController();
    _cartDeliveryContactController = TextEditingController();

    widget.myCart.forEach((element) {
      seller = element.sellerId;
      orders.add({
        "seller": element.sellerId,
        "price": element.price,
        "imgUrl": element.imgUrl,
        "qty": element.qty,
        "product name": element.productName,
        "product id": element.productId
      });
      print(orders);
    });
    DocumentSnapshot documentSnapshot =
        await _firebaseServices.checkAddress(uid);
    if (documentSnapshot.exists) {
      _cartDeliveryAddressController.text = documentSnapshot['address'];
      _cartDeliveryNameController.text = documentSnapshot['user name'];
      _cartDeliveryContactController.text = documentSnapshot['contact'];
    } else {}
    setState(() {
      loadingAll = false;
    });
  }

  @override
  void dispose() {
    _cartDeliveryAddressController.dispose();
    _cartDeliveryNameController.dispose();
    _cartDeliveryContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return loadingAll
        ? Scaffold(
            body: Center(
              child: Text('Loading...'),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Checkout"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Address',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _cartDeliveryAddressController,
                            style: TextStyle(color: Colors.black87),
                            validator: RequiredValidator(
                                errorText: "Delivery address is required"),
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderSide: const BorderSide(
                                    color: Colors.black87, width: 0.0),
                              ),
                              hintText: "Enter Delivery Address",
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
                      ),
                      Text(
                        'Personal Details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                controller: _cartDeliveryNameController,
                                style: TextStyle(color: Colors.black87),
                                validator: RequiredValidator(
                                    errorText: "Name is required"),
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Colors.black87, width: 0.0),
                                  ),
                                  hintText: "Enter Your Name",
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
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                controller: _cartDeliveryContactController,
                                style: TextStyle(color: Colors.black87),
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Contact number is required"),
                                  MobileNoValidator(
                                      errorText:
                                          "Mobile no must be 0912XXXXXXX")
                                ]),
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Colors.black87, width: 0.0),
                                  ),
                                  hintText: "Enter Your Contact Number",
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
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      loading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : TextButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  loading = true;
                                  setState(() {});

                                  dynamic result =
                                      await _firebaseServices.addOrder(
                                          widget.storeName,
                                          user.uid,
                                          seller,
                                          orders,
                                          _cartDeliveryAddressController.text,
                                          _cartDeliveryNameController.text,
                                          _cartDeliveryContactController.text,
                                          widget.total);

                                  await _firebaseServices
                                      .deleteEntireCart(user.uid);

                                  orders.forEach((element) async {
                                    print(element['product id']);
                                    int stock = await _firebaseServices
                                        .checkStock(element['product id']);
                                    await _firebaseServices
                                        .updateStockFoodDelivery(
                                            stock - element['qty'].toInt(),
                                            element['product id']);
                                    await _firebaseServices.addAddress(
                                        _cartDeliveryNameController.text,
                                        user.uid,
                                        _cartDeliveryAddressController.text,
                                        _cartDeliveryContactController.text);
                                  });

                                  loading = false;
                                  setState(() {});

                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blueAccent)),
                              child: Container(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Place my Order',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
