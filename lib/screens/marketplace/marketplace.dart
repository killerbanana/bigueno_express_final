import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/chat/send_message.dart';
import 'package:biguenoexpress/screens/pawit/paw_it.dart';
import 'package:biguenoexpress/screens/reviews/marketplace/marketplace_write_review.dart';
import 'package:biguenoexpress/widgets/icon_with_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MarketPlace extends StatefulWidget {
  static String routeName = "/marketplace";

  @override
  State<MarketPlace> createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  int seller;
  bool loading = false;

  Users user;

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace'),
        centerTitle: true,
        actions: [
          StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return IconWithCounter(
                  numOfItem: 1,
                  icon: FontAwesomeIcons.shoppingBag,
                );
              })
        ],
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _sellerList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          _sellerList[index]['Image url']),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _sellerList[index]['Shop Name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.blue,
                                        ),
                                        Text(
                                          _sellerList[index]['Address'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      _sellerList[index]['Opening Hours'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text('Rating'),
                              _sellerList[index]['Rating'] <= 0
                                  ? Text('No rating')
                                  : RatingBarIndicator(
                                rating: _sellerList[index]['Rating'],
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .where('seller id', isEqualTo: _sellerId[index])
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Loading");
                          }

                          return Container(
                            height: 220,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                                return Container(
                                  height: 220,
                                  child: Card(
                                    elevation: 5,
                                    child: InkWell(
                                      onTap: () {},
                                      splashColor: Colors.greenAccent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                        height: 100,
                                        width: 250,
                                        child: GridTile(
                                          child: Image.network(
                                            data['imgUrl'],
                                            fit: BoxFit.cover,
                                          ),
                                          footer: GridTileBar(
                                            backgroundColor: Colors.black45,
                                            title: Text(
                                              '\u20B1  ${data['price']} ${data['product name']}',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            splashColor: Colors.greenAccent,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SendMessage(
                                      receiverId: _sellerId[index],
                                      receiverName: _sellerList[index]
                                      ['Shop Name']),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black87),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.chat_bubble_2),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Send a message'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.greenAccent,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PawIt()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black87),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(FontAwesomeIcons.motorcycle),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Contact a Rider'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MarketPlaceWriteReview(sellerId: _sellerId[index],)),
                        );
                      }, child: Text('Write a Review')),
                      Divider(
                        thickness: 10,
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  List _sellerList = [];
  List _sellerId = [];

  listSeller() async {
    setState(() {
      loading = true;
    });
    await FirebaseFirestore.instance
        .collection('partner')
        .where('Category', isEqualTo: 'Merchant').where("Verified", isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.id == user.uid) {
        } else {
          _sellerList.add(doc);
          _sellerId.add(doc.id);
        }
      });
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    listSeller();
    super.initState();
  }
}
