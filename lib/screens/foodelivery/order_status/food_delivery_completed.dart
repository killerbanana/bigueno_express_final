import 'package:biguenoexpress/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FoodDeliveryCompleted extends StatefulWidget {
  static String routeName = "/foodDeliveryCompleted";
  @override
  _FoodDeliveryCompletedState createState() => _FoodDeliveryCompletedState();
}

class _FoodDeliveryCompletedState extends State<FoodDeliveryCompleted> {
  Users user;
  List<dynamic> cart = [];
  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Orders'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('seller', isEqualTo: user.uid)
                  .where('status', isEqualTo: "Completed").orderBy('date delivered', descending: true)
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
                              'Delivered',
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
                            Text('Order created: ${DateTime.parse(data['date'].toDate().toString())}', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),),
                            Text('Order delivered: ${DateTime.parse(data['date delivered'].toDate().toString())}', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),),
                            Text('Order Id: ${document.id}', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),),
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
