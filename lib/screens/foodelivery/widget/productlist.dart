import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinner_input/spinner_input.dart';

class ProductList extends StatefulWidget {
  final String storeId;
  final String docId;
  final String productName;
  final String imgUrl;
  final int percentOff;
  final double price;
  final double discountedPrice;

  const ProductList(
      {Key key,
      this.docId,
      this.storeId,
      this.productName,
      this.imgUrl,
      this.percentOff,
      this.price,
      this.discountedPrice})
      : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Users user;
  FirebaseServices _firebaseServices = FirebaseServices();

  double price;
  double quantity;

  bool loading = false;

  String currentStore;
  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return loading
        ? Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 10),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'please wait...',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
          )
        : FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('shop cart')
                .doc(user.uid)
                .collection('cart')
                .doc(widget.docId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data.exists) {
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, right: 10),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'ADD TO CART',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  onTap: () async {
                    print("Hello");

                    widget.percentOff == 0
                        ? price = widget.price
                        : price = widget.discountedPrice;

                    setState(() {
                      loading = true;
                    });

                    dynamic result = await _firebaseServices.addToCart(
                        user.uid,
                        widget.storeId,
                        widget.docId,
                        widget.productName,
                        price,
                        1,
                        widget.imgUrl);
                    setState(() {
                      loading = false;
                    });
                  },
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data1 =
                    snapshot.data.data() as Map<String, dynamic>;
                currentStore = data1['seller'];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    child: SpinnerInput(
                      minValue: 0,
                      maxValue: 200,
                      step: 1,
                      plusButton: SpinnerButtonStyle(
                          elevation: 0,
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(0)),
                      minusButton: SpinnerButtonStyle(
                          elevation: 0,
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(0)),
                      middleNumberWidth: 30,
                      disabledPopup: true,
                      disabledLongPress: true,
                      middleNumberStyle: TextStyle(fontSize: 16),
                      middleNumberBackground:
                          Colors.yellowAccent.withOpacity(0.5),
                      spinnerValue: data1['quantity'].toDouble(),
                      onChange: (newValue) async {
                        quantity = data1['quantity'].toDouble();
                        setState(() {
                          loading = true;
                        });
                        if (newValue == 0) {
                          dynamic result = await _firebaseServices.deleteCart(
                              user.uid, widget.storeId, widget.docId);
                        } else {
                          dynamic result = await _firebaseServices.updateCart(
                              user.uid,
                              widget.storeId,
                              widget.docId,
                              widget.productName,
                              newValue);
                        }
                        setState(() {
                          loading = false;
                        });
                      },
                    ),
                  ),
                );
              }

              return Text("");
            });
  }
}
