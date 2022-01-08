import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/home/order_status/add_rider_rating.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Completed extends StatefulWidget {
  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  Users user;
  List<dynamic> cart = [];

  FirebaseServices _firebaseServices = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('uid', isEqualTo:  user.uid).where('status', isEqualTo: "Completed")
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
                          Text(data['status'],style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent), ),
                          ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: cart.map((element) {
                                return ListTile(
                                  leading: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(image: NetworkImage(element['imgUrl']), fit: BoxFit.fill)
                                    ),
                                  ),
                                  title: Text(element['product name']),
                                  subtitle: Text('\u20B1  ${element['price'].toString()} x ${element['qty'].toStringAsFixed(0)}'),
                                );
                              }).toList()
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text('Order Total \u20B1  ${data['total'].toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent))
                              ],
                              mainAxisAlignment: MainAxisAlignment.end,
                            ),
                          ),
                          FutureBuilder(
                            future: _firebaseServices.checkRiderRating(document.id),
                            builder: (context, snapshot) {
                              if(snapshot.connectionState == ConnectionState.done && !snapshot.data){
                                return TextButton(
                                  onPressed: () async {
                                    print(data['rider id']);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddRiderRating(
                                                riderId: data['rider id'],
                                                transactionId: document.id,
                                              )),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(
                                        Colors.blueAccent),
                                  ),
                                  child: Text(
                                    'RATE RIDER',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                return Text('RATING SUBMITTED');
                              }
                              return Container();
                            }
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
    );
  }
}
