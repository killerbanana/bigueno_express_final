import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/marketplace/marketplace_add_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PawItProfile extends StatelessWidget{
  static String routeName = "/pawItProfile";
  final CollectionReference partner = FirebaseFirestore.instance.collection('partner');
  Users user;
  @override
  Widget build(BuildContext context){
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
              onPressed: () {},
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
              Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(data['Img Url']),
                            ),
                            SizedBox(width: 20,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['Shop Name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                Row(
                                  children: [
                                    Text('Following 5', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),),
                                    VerticalDivider(),
                                    Text('Followers 13', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    SellerProfileButton(title: "My Deliveries", isNew: false, iconColor: Colors.blueAccent, iconData: CupertinoIcons.list_dash, subTitle: "View Delivery History",),
                    Divider(height: 1,),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SalesActionButton(iconData: CupertinoIcons.cube_box, title: "To Deliver",),
                          SalesActionButton(iconData: CupertinoIcons.delete_right, title: "Cancelled",),
                          SalesActionButton(iconData: CupertinoIcons.bars, title: "More",),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Text("loading");
          },
        )
    );
  }
}

class SalesActionButton extends StatelessWidget {
  const SalesActionButton({
    Key key,  this.title,  this.iconData,
  }) : super(key: key);

  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () {}, child: Column(
      children: [
        Icon(iconData, color: Colors.black45,),
        Text(title,style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black),),
      ],
    ), style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: Colors.white
    ),);
  }
}

class SellerProfileButton extends StatelessWidget {
  const SellerProfileButton({
    Key key,  this.title,  this.isNew,  this.iconData,  this.iconColor,  this.subTitle, this.press,
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
          backgroundColor: Colors.white
      ),
      onPressed: press,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(iconData, color: iconColor,),
                SizedBox(width: 10,),
                Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.black87),),
                SizedBox(width: 10,),
                if(isNew)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('New',style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.white),),
                    ),
                  )
              ],
            ),
            Row(
              children: [
                Text(subTitle,style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black),),
                Icon(CupertinoIcons.forward, color: Colors.black45,)
              ],
            )
          ],
        ),
      ),
    );
  }
}