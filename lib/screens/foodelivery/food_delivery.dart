import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/chat/chat_screen.dart';
import 'package:biguenoexpress/screens/foodelivery/food_delivery_main_screen.dart';
import 'package:biguenoexpress/widgets/icon_with_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'food_delivery_cart.dart';

class FoodDelivery extends StatelessWidget {
  static String routeName = "/food_delivery";
  Users user;

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Delivery'),
        centerTitle: true,
        actions: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(user.uid)
                  .collection('chats')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                int _total = 0;
                if (snapshot.connectionState == ConnectionState.active) {
                  _total = snapshot.data.size;
                  //Map<String, dynamic> data = snapshot.data.data();
                  //print(data['quantity']);
                }
                return IconWithCounter(
                  icon: FontAwesomeIcons.sms,
                  numOfItem: _total,
                  press: () {
                    Navigator.pushNamed(context, ChatScreen.routeName);
                  },
                );
              }),
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
                  return Text("Loading");
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
                  press: (){
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CupertinoSearchTextField(
                placeholder: 'Search for Shops and Restaurants',
                onChanged: (String value) {
                  print('The text has changed to: $value');
                },
                onSubmitted: (String value) {
                  print('Submitted text: $value');
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your Daily deals',
                      style: TextStyle(
                          fontFamily: 'avenir',
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.view_list_rounded), onPressed: () {}),
                  IconButton(icon: Icon(Icons.grid_view), onPressed: () {}),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('partner')
                    .where('Category', isEqualTo: "Food Delivery")
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
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FoodDeliveryMainScreen(
                                      storeId: document.id,
                                    )),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 180,
                                  width: double.infinity,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            data['Image url'],
                                          ),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black45, BlendMode.darken))),
                                ),
                                Container(
                                  height: 180,
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          FutureBuilder<DocumentSnapshot>(
                                            future:  FirebaseFirestore.instance
                                                .collection('discount').doc(document.id)
                                                .get(),
                                            builder:
                                                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                                              if (snapshot.hasError) {
                                                return Text("Something went wrong");
                                              }

                                              if (snapshot.hasData && !snapshot.data.exists) {
                                                return Text('');
                                              }

                                              if (snapshot.connectionState == ConnectionState.done) {
                                                Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
                                                return Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 10),
                                                  child: Container(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          6.0),
                                                      child: Text(
                                                        '${data['% off']} % OFF',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Colors.blueAccent,
                                                        borderRadius:
                                                        BorderRadius.only(
                                                            topRight: Radius
                                                                .circular(20),
                                                            bottomRight:
                                                            Radius
                                                                .circular(
                                                                20))),
                                                  ),
                                                );
                                              }
                                              return Text('');
                                            },
                                          ),
                                          FutureBuilder<DocumentSnapshot>(
                                            future:  FirebaseFirestore.instance
                                                .collection('free delivery').doc(document.id)
                                                .get(),
                                            builder:
                                                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                                              if (snapshot.hasError) {
                                                return Text("Something went wrong");
                                              }

                                              if (snapshot.hasData && !snapshot.data.exists) {
                                                return Text('');
                                              }

                                              if (snapshot.connectionState == ConnectionState.done) {
                                                Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
                                                return Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 10),
                                                  child: Container(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          6.0),
                                                      child: data['free delivery'] ? Text(
                                                        data['free delivery']? "Free Delivery":" ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 14),
                                                      ) : Text(''),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Colors.blueAccent,
                                                        borderRadius:
                                                        BorderRadius.only(
                                                            topRight: Radius
                                                                .circular(20),
                                                            bottomRight:
                                                            Radius
                                                                .circular(
                                                                20))),
                                                  ),
                                                );
                                              }
                                              return Text('');
                                            },
                                          ),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              data['Delivery Time'],
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['Shop Name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.star_fill,
                                    color: Colors.yellow,
                                  ),
                                  data['Rating'] != 0
                                      ? Text(
                                          data['Rating'].toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          '(No Rating)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
                                        )
                                ],
                              )
                            ],
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
