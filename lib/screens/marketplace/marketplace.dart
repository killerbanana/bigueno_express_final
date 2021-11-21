import 'package:biguenoexpress/screens/chat/send_message.dart';
import 'package:biguenoexpress/widgets/icon_with_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MarketPlace extends StatelessWidget {
  static String routeName = "/marketplace";
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
            itemCount: 2,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Container(
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
                                  Text('JL Tugas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, color: Colors.blue,),
                                      Text('Barangay Cuta', style: TextStyle(fontWeight: FontWeight.w300),),
                                    ],
                                  ),
                                  Text('13 Minutes Ago', style: TextStyle(fontWeight: FontWeight.w300),),
                                ],
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text('Rating'),
                            RatingBarIndicator(
                              rating: 5,
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
                    Text('Available na po ngayon fresh na prutas galing Samar.'),
                    Container(
                      height: 220,
                      child: ListView.builder(
                        itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                        'https://www.unlockfood.ca/EatRightOntario/media/Website-images-resized/How-to-store-fruit-to-keep-it-fresh-resized.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                      footer: GridTileBar(
                                        backgroundColor: Colors.black45,
                                        title: Text(
                                          '\u20B1  100',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
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
            )),
      ),
    );
  }
}
