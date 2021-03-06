import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FoodDeliveryForDelivery extends StatefulWidget {
  static String routeName = "/foodDeliveryForDelivery";

  @override
  _FoodDeliveryForDeliveryState createState() =>
      _FoodDeliveryForDeliveryState();
}

class _FoodDeliveryForDeliveryState extends State<FoodDeliveryForDelivery> {
  Users user;
  List<dynamic> cart = [];

  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('For Delivery'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('seller', isEqualTo: user.uid)
                  .where('status', isEqualTo: "For Delivery")
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    cart = data['order'];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'For Delivery',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blueAccent),
                            ),
                            ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: cart.map((element) {
                                  return ListTile(
                                    leading: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  element['imgUrl']),
                                              fit: BoxFit.fill)),
                                    ),
                                    title: Text(element['product name']),
                                    subtitle: Text(
                                        '\u20B1  ${element['price'].toString()} x ${element['qty'].toStringAsFixed(0)}'),
                                  );
                                }).toList()),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Order Total \u20B1  ${data['total'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blueAccent),
                                ),
                              ],
                            ),
                            Divider(),
                            Text(
                              'Delivery Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blueAccent),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Customer Name: '),
                                        Text('${data['name']}')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Customer Contact: '),
                                        Text('${data['contact number']}'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'Delivery Address: '),
                                        Text('${data['delivery address']}')
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            Text(
                              'Order created: ${DateTime.parse(data['date'].toDate().toString())}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 12),
                            ),
                            Text(
                              'Order Id: ${document.id}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
