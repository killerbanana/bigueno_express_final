import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/foodelivery/widget/productlist.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinner_input/spinner_input.dart';

class StoreList extends StatefulWidget {
  final String storeId;
  final String storeName;
  const StoreList({Key key, this.storeId, this.storeName}) : super(key: key);

  @override
  _StoreListState createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  Users user;
  FirebaseServices _firebaseServices = FirebaseServices();

  double price;
  double quantity;

  bool loading = false;

  String currentStore;

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return SliverToBoxAdapter(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('seller id', isEqualTo: widget.storeId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('');
            }

            return ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  data['imgUrl'],
                                ),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black45, BlendMode.darken)),
                          ),
                          height: 150,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: Text(
                                      data['product name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  data['% off'] == 0
                                      ? Text('')
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, right: 10),
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                '${data['% off'].toString()} % off',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.pink,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          )),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                                    child: Text(' Stock: ${data['stock'].toString()}', style: TextStyle(color: Colors.white),),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      data['% off'] == 0
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10, left: 8),
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '\u20B1 ${data['price'].toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(20)),
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10, left: 8),
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '\u20B1 ${data['price'].toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontWeight:
                                                                FontWeight.w300),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        '\u20B1 ${data['discounted price'].toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(20)),
                                              ),
                                            ),
                                      ProductList(
                                        storeName: widget.storeName,
                                        docId: document.id,
                                        storeId: widget.storeId,
                                        stock: data['stock'],
                                        productName: data['product name'],
                                        imgUrl: data['imgUrl'],
                                        percentOff: data['% off'],
                                        price: data['price'].toDouble(),
                                        discountedPrice:
                                            data['discounted price'].toDouble(),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
