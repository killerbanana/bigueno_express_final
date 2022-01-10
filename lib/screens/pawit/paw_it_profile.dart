import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/marketplace/marketplace_add_product.dart';
import 'package:biguenoexpress/screens/pawit/order_status/paw_it_completed_delivery.dart';
import 'package:biguenoexpress/screens/pawit/paw_it_comments.dart';
import 'package:biguenoexpress/screens/pawit/paw_it_deliver_history.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_status/paw_it_for_confirmation_delivery.dart';
import 'order_status/paw_it_for_delivery.dart';

// ignore: must_be_immutable
class PawItProfile extends StatefulWidget {
  static String routeName = "/pawItProfile";

  @override
  State<PawItProfile> createState() => _PawItProfileState();
}

class _PawItProfileState extends State<PawItProfile> {
  final CollectionReference partner =
      FirebaseFirestore.instance.collection('partner');

  Users user;

  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          actions: [
            IconButton(
              icon: Icon(
                CupertinoIcons.chat_bubble,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, PawItComments.routeName);
              },
            ),
          ],
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: partner.doc(user.uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data['Image url']),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['Shop Name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Following 5',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        VerticalDivider(),
                                        Text(
                                          'Followers 13',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            if(data['Status'] == "Online")
                              CircleAvatar(backgroundColor: Colors.green, radius: 10,),
                            if(data['Status'] == "Driving")
                              CircleAvatar(backgroundColor: Colors.orange, radius: 10,),
                            if(data['Status'] == "Not Available")
                              CircleAvatar(backgroundColor: Colors.redAccent, radius: 10,),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    SellerProfileButton(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PawItDeliverHistory(uid: user.uid)),
                        );
                      },
                      title: "My Deliveries",
                      isNew: false,
                      iconColor: Colors.blueAccent,
                      iconData: CupertinoIcons.list_dash,
                      subTitle: "View Delivery History",
                    ),
                    Divider(
                      height: 1,
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SalesActionButton(
                            press: () {
                              Navigator.pushNamed(context,
                                  PawItForConfirmationDelivery.routeName);
                            },
                            iconData: CupertinoIcons.check_mark,
                            title: "For Confirmation",
                          ),
                          SalesActionButton(
                            press: () {
                              Navigator.pushNamed(
                                  context, PawItForDelivery.routeName);
                            },
                            iconData: CupertinoIcons.cube_box,
                            title: "To Deliver",
                          ),
                          SalesActionButton(
                            press: () {
                              Navigator.pushNamed(
                                  context, PawItCompletedDelivery.routeName);
                            },
                            iconData: CupertinoIcons.flag_circle,
                            title: "Delivered",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Click button to update current status'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () async {
                            await _firebaseServices.updateStatus(user.uid, "Online");
                            setState(() {

                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                          child: Text(
                            'Online',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _firebaseServices.updateStatus(user.uid, "Driving");
                            setState(() {

                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange),
                          ),
                          child: Text(
                            'Driving',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _firebaseServices.updateStatus(user.uid, "Not Available");
                            setState(() {

                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.redAccent),
                          ),
                          child: Text(
                            'Not Available',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return Center(child: Text("loading"));
          },
        ));
  }
}

class SalesActionButton extends StatelessWidget {
  const SalesActionButton({
    Key key,
    this.title,
    this.iconData,
    this.press,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      child: Column(
        children: [
          Icon(
            iconData,
            color: Colors.black45,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black),
          ),
        ],
      ),
      style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Colors.white),
    );
  }
}

class SellerProfileButton extends StatelessWidget {
  const SellerProfileButton({
    Key key,
    this.title,
    this.isNew,
    this.iconData,
    this.iconColor,
    this.subTitle,
    this.press,
  }) : super(key: key);

  final String title;
  final bool isNew;
  final IconData iconData;
  final Color iconColor;
  final String subTitle;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Colors.white),
      onPressed: press,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  iconData,
                  color: iconColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87),
                ),
                SizedBox(
                  width: 10,
                ),
                if (isNew)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        'New',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                    ),
                  )
              ],
            ),
            Row(
              children: [
                Text(
                  subTitle,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
                Icon(
                  CupertinoIcons.forward,
                  color: Colors.black45,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
