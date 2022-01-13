import 'package:biguenoexpress/models/cart.dart';
import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/foodelivery/food_delivery_checkout.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinner_input/spinner_input.dart';

class FoodDeliveryCart extends StatefulWidget {
  @override
  _FoodDeliveryCartState createState() => _FoodDeliveryCartState();
}

class _FoodDeliveryCartState extends State<FoodDeliveryCart> {
  Users user;
  FirebaseServices _firebaseServices = FirebaseServices();
  double total = 0;
  bool loading = false;
  double maxTotal;

  String _storeName;
  List<Cart> cart = [];

  double quantity;

  @override
  void initState() {
    super.initState();
  }

  Future checkData() {
    total = 0;
    maxTotal = 0;
    cart.clear();
    return FirebaseFirestore.instance
        .collection('shop cart')
        .doc(user.uid)
        .collection('cart')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _storeName = doc['store name'];
        total = total + (doc['price'].toDouble() * doc['quantity']);
        cart.add(new Cart(doc['price'].toDouble(), doc['product image'],
            doc['product name'], doc['quantity'].toDouble(), doc['seller'], total, doc['product id']));
      });
      maxTotal = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('shop cart')
            .doc(user.uid)
            .collection('cart')
            .get(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.connectionState == ConnectionState.done &&  snapshot.data.size > 0){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('shop cart')
                          .doc(user.uid)
                          .collection('cart')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text('');
                        }
                        return ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                            return ListTile(
                              title: Text(data['product name']),
                              leading: Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(data['product image']),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              subtitle: Text(
                                  '\u20B1 ${data['price'].toStringAsFixed(2)}  x ${data['quantity'].toStringAsFixed(0)}'),
                            );
                          }).toList(),
                        );
                      }),
                  FutureBuilder(
                    future: checkData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }

                      if (snapshot.hasData && !snapshot.data.exists) {
                        return Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Subtotal',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    Text(
                                      '\u20B1 ${total.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                      Text(
                                        '\u20B1 ${maxTotal.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Text('loading...');
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  maxTotal > 50 ? Text('') :TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.blue, // This is a custom
                    ),
                    onPressed: () {
                      print(_storeName);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FoodDeliveryCheckout(myCart: cart, total: maxTotal, storeName: _storeName,)),
                      );
                    },
                    child: Container(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('CHECKOUT'),
                        ),
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text('CART IS EMPTY. 😞'));
        }
      ),
    );
  }
}
