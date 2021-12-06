import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/foodelivery/food_delivery_cart.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:biguenoexpress/widgets/icon_with_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spinner_input/spinner_input.dart';

class FoodDeliveryMainScreen extends StatefulWidget {
  final String storeId;
  static String routeName = "/food_delivery_main_screen";

  const FoodDeliveryMainScreen({Key key, this.storeId}) : super(key: key);
  @override
  _FooDeliveryMainScreenState createState() => _FooDeliveryMainScreenState();
}

class _FooDeliveryMainScreenState extends State<FoodDeliveryMainScreen> {
  Users user;
  FirebaseServices _firebaseServices = FirebaseServices();

  double price;
  double quantity;

  String currentStore;

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            actions: [
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

                    int _total = 0;
                    if (snapshot.connectionState == ConnectionState.active) {
                      _total = snapshot.data.size;
                      //Map<String, dynamic> data = snapshot.data.data();
                      //print(data['quantity']);
                    }
                    return IconWithCounter(
                      icon: FontAwesomeIcons.shoppingBag,
                      numOfItem: _total,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FoodDeliveryCart(
                              )),
                        );
                      },
                    );
                  }),
            ],
            expandedHeight: 200,
            flexibleSpace: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('partner').doc(widget.storeId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data.exists) {
                  return Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('');
                }
                  Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
                  return FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(data['Shop Name']),
                    background: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  data['Image url'],
                                ),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black45, BlendMode.darken)),
                          ),
                        ),
                        Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.white)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        data['Delivery Time'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.star_fill,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      data['Rating'] ==0 ? Text('No Rating', style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300)) :Text(
                                        '4.6',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      data['Rating'] ==0 ? Text('') :Text(
                                        ' ( 21 ) ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  );
              }
            ),
          ),
          SliverToBoxAdapter(
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
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 10),
                                        child: Text(data['product name'], style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),),
                                      ),
                                      data['% off'] ==0 ?Text('') : Padding(
                                        padding: const EdgeInsets.only(top: 10, right: 10),
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('${data['% off'].toString()} % off', style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.pink,
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                        )
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      data['% off'] == 0 ? Padding(
                                        padding: const EdgeInsets.only(bottom: 10, left: 8),
                                        child: Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('\u20B1 ${data['price'].toStringAsFixed(2)}', style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold),),
                                                ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(20)
                                              ),
                                        ),
                                      ) : Padding(
                                        padding: const EdgeInsets.only(bottom: 10, left: 8),
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text('\u20B1 ${data['price'].toStringAsFixed(2)}', style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    decoration: TextDecoration.lineThrough,
                                                    fontWeight: FontWeight.w300),),
                                                SizedBox(width: 10,),
                                                Text('\u20B1 ${data['discounted price'].toStringAsFixed(2)}', style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                        ),
                                      ),
                                      FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance.collection('shop cart')
                                            .doc(user.uid).collection('cart').doc(document.id).get(),
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
                                                    child: Text('ADD TO CART', style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold),),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(20)
                                                  ),
                                                ),
                                              ),
                                              onTap: () async{
                                                data['% off'] == 0? price = data['price'].toDouble() : price = data['discounted price'].toDouble();
                                                  dynamic result =  await _firebaseServices.addToCart(user.uid, widget.storeId, document.id, data['product name'], price, 1, data['imgUrl']);
                                                setState(() {

                                                });
                                              },
                                            );
                                          }
                                          if (snapshot.connectionState == ConnectionState.done) {
                                            Map<String, dynamic> data1 = snapshot.data.data() as Map<String, dynamic>;
                                            currentStore = data1['seller'];
                                            return Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Container(
                                                child: SpinnerInput(
                                                  minValue: 0,
                                                  maxValue: 200,
                                                  step: 1,
                                                  plusButton: SpinnerButtonStyle(elevation: 0, color: Colors.blue, borderRadius: BorderRadius.circular(0)),
                                                  minusButton: SpinnerButtonStyle(elevation: 0, color: Colors.blueAccent, borderRadius: BorderRadius.circular(0)),
                                                  middleNumberWidth: 30,
                                                  disabledPopup: true,
                                                  disabledLongPress: true,
                                                  middleNumberStyle: TextStyle(fontSize: 16),
                                                  middleNumberBackground: Colors.yellowAccent.withOpacity(0.5),
                                                  spinnerValue: data1['quantity'].toDouble(),
                                                  onChange: (newValue) async{
                                                    quantity = data1['quantity'].toDouble();
                                                    if(newValue == 0){
                                                      dynamic result =  await _firebaseServices.deleteCart(user.uid, widget.storeId, document.id);
                                                    }
                                                    else{
                                                      dynamic result =  await _firebaseServices.updateCart(user.uid, widget.storeId, document.id, data['product name'],  newValue);
                                                    }
                                                    setState(() {
                                                    });
                                                  },
                                                ),
                                              ),
                                            );

                                          }

                                          return Text("");
                                        }
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
