import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/chat/send_message.dart';
import 'package:biguenoexpress/widgets/icon_with_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
          IconWithCounter(
            numOfItem: 1,
            icon: FontAwesomeIcons.shoppingBag,
          )
        ],
      ),
      body:SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _sellerList.length,
            itemBuilder: (BuildContext context, int index) {
              return  Container(
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
                                    image: NetworkImage(_sellerList[index]['Image url']),
                                )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_sellerList[index]['Shop Name'],
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.blue,),
                                    Text(_sellerList[index]['Address'], style: TextStyle(fontWeight: FontWeight.w300),),
                                  ],
                                ),
                                Text(_sellerList[index]['Opening Hours'], style: TextStyle(fontWeight: FontWeight.w300),),
                              ],
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text('Rating'),
                          _sellerList[index]['Rating'] <= 0 ? Text('No rating'): RatingBarIndicator(
                            rating: _sellerList[index]['Rating'],
                            itemBuilder: (context, index) =>
                                Icon(
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
                  SizedBox(height: 10,),
                  StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text("Loading");
                          }

                          return Container(
                              height: 220,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: snapshot.data.docs.map((DocumentSnapshot document) {
                                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                  return  Container(
                                    height: 220,
                                    child: Card(
                                      elevation: 5,
                                      child: InkWell(
                                        onTap: () {},
                                        splashColor: Colors.greenAccent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          height: 220,
                                          width: 170,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: GridTile(
                                              child: Image.network(
                                                data['imgUrl'],
                                                fit: BoxFit.cover,
                                              ),
                                              footer: GridTileBar(
                                                backgroundColor: Colors.black45,
                                                title: Text(
                                                  '\u20B1  ${data['price']}',
                                                  textAlign: TextAlign.center,
                                                ),
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
                                    MaterialPageRoute(builder: (context) => SendMessage(senderId: user.uid, senderName: _sellerList[index]['Shop Name']),),
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
                                        SizedBox(width: 10,),
                                        Text('Send a message'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.greenAccent,
                                onTap: () {},
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
                                        SizedBox(width: 10,),
                                        Text('Contact a Rider'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Divider(thickness: 10,)
                        ],
                      ),
                    ),
                  );
            }
        ),
      ),
    );
  }

  List _sellerList = [];
  listSeller() async {
    setState(() {
      loading = true;
    });
    await FirebaseFirestore.instance
        .collection('partner').where('Category', isEqualTo: 'Merchant')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _sellerList.add(doc);
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

class MarketCard extends StatelessWidget {
  const MarketCard({
    Key key, this.name, this.address, this.time, this.desc, this.imgUrl, this.rating, this.price, this.productLength,
  }) : super(key: key);

  final String name;
  final String address;
  final String time;
  final String desc;
  final String imgUrl;
  final double rating;
  final double price;
  final int productLength;


  @override
  Widget build(BuildContext context) {
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
                      color: Colors.red,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.blue,),
                              Text(address, style: TextStyle(fontWeight: FontWeight.w300),),
                            ],
                          ),
                          Text(time, style: TextStyle(fontWeight: FontWeight.w300),),
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text('Rating'),
                    rating == null ? Text('No rating'): RatingBarIndicator(
                      rating: rating,
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
            SizedBox(height: 10,),
            Text(desc),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  splashColor: Colors.greenAccent,
                  onTap: () {
                    Navigator.popAndPushNamed(context, SendMessage.routeName);
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
                          SizedBox(width: 10,),
                          Text('Send a message'),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  splashColor: Colors.greenAccent,
                  onTap: () {},
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
                          SizedBox(width: 10,),
                          Text('Contact a Rider'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Divider(thickness: 10,)
          ],
        ),
      ),
    );
  }
}
