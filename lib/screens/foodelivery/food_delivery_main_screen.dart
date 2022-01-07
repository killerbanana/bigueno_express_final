import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/foodelivery/food_delivery_cart.dart';
import 'package:biguenoexpress/screens/foodelivery/widget/storelist.dart';
import 'package:biguenoexpress/screens/reviews/marketplace/marketplace_write_review.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:biguenoexpress/widgets/icon_with_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FoodDeliveryMainScreen extends StatefulWidget {
  final String storeId;
  final String storeName;
  static String routeName = "/food_delivery_main_screen";

  const FoodDeliveryMainScreen({Key key, this.storeId, this.storeName}) : super(key: key);
  @override
  _FooDeliveryMainScreenState createState() => _FooDeliveryMainScreenState();
}

class _FooDeliveryMainScreenState extends State<FoodDeliveryMainScreen> {
  Users user;
  FirebaseServices _firebaseServices = FirebaseServices();

  double price;
  double quantity;
  String storeName;
  bool loading = false;

  String currentStore;


  @override
  void initState() {
    super.initState();
  }

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
                              builder: (context) => FoodDeliveryCart()),
                        );
                      },
                    );
                  }),
            ],
            expandedHeight: 200,
            flexibleSpace: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('partner')
                    .doc(widget.storeId)
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
                  Map<String, dynamic> data =
                      snapshot.data.data() as Map<String, dynamic>;

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
                                        border:
                                            Border.all(color: Colors.white)),
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
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MarketPlaceWriteReview(sellerId: widget.storeId,)),
                                      );
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.star_fill,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        data['Rating'] == 0
                                            ? Text('No Rating',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w300))
                                            : Text(
                                                data['Rating'].toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w300),
                                              ),
                                        data['Rating'] == 0
                                            ? Text('')
                                            : Text(
                                                ' ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w300),
                                              )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  );
                }),
          ),
          StoreList(
            storeName: widget.storeName,
            storeId: widget.storeId,
          )
        ],
      ),
    );
  }
}
