import 'package:biguenoexpress/models/partners.dart';
import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/chat/chat_screen.dart';
import 'package:biguenoexpress/screens/foodelivery/food_delivery.dart';
import 'package:biguenoexpress/screens/foodelivery/food_delivery_cart.dart';
import 'package:biguenoexpress/screens/foodelivery/food_delivery_main_screen.dart';
import 'package:biguenoexpress/screens/foodelivery/food_delivery_profile.dart';
import 'package:biguenoexpress/screens/home/my_orders.dart';
import 'package:biguenoexpress/screens/marketplace/marketplace_add_product.dart';
import 'package:biguenoexpress/screens/marketplace/marketplace_profile.dart';
import 'package:biguenoexpress/screens/pawit/paw_it.dart';
import 'package:biguenoexpress/screens/pawit/paw_it_profile.dart';
import 'package:biguenoexpress/screens/test/model/product.dart';
import 'package:biguenoexpress/screens/test/provider/products.dart';
import 'package:biguenoexpress/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:biguenoexpress/widgets/icon_with_counter.dart';
import 'package:biguenoexpress/screens/partner/partner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../marketplace/marketplace.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  final FirebaseServices _firebaseServices = FirebaseServices();
  Users user;
  Partners _partners;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    final data = Provider.of<FirebaseServices>(context).category;
    return Scaffold(
      appBar: AppBar(
        title: Text('Biguneo Express'),
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
                  return Text("");
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
                  return Text("");
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DELICIOUS FOOD AT YOUR DOORSTEP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MarketPlace.routeName);
                            },
                            splashColor: Colors.greenAccent,
                            child: Container(
                              height: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_basket,
                                    size: 45,
                                  ),
                                  Text(
                                    'Marketplace',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, FoodDelivery.routeName);
                            },
                            splashColor: Colors.greenAccent,
                            child: Container(
                              height: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.fastfood,
                                    size: 45,
                                  ),
                                  Text(
                                    'Food Delivery',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, PawIt.routeName);
                            },
                            splashColor: Colors.greenAccent,
                            child: Container(
                              height: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.motorcycle,
                                    size: 45,
                                  ),
                                  Text(
                                    'Paw it',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ),
              Text(
                'DAILY DEALS'
                    '',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('products')
                      .where('daily deals', isEqualTo: true)
                      .get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return Container(
                        height: 220,
                        width: double.infinity  ,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children:
                              snapshot.data.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return Container(
                              height: 220,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FoodDeliveryMainScreen(
                                            storeId: data['seller id'],
                                            storeName: data['Shop Name'],
                                          )),
                                    );
                                  },
                                  splashColor: Colors.greenAccent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                    height: 220,
                                    width: 170,
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      child: GridTile(
                                        child: Image.network(
                                          data['imgUrl'],
                                          fit: BoxFit.cover,
                                        ),
                                        footer: GridTileBar(
                                          backgroundColor: Colors.black45,
                                          title: Text(
                                            '\u20B1  ${data['price'].toString()}',
                                            textAlign: TextAlign.center,
                                          ),
                                          trailing: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => FoodDeliveryMainScreen(
                                                        storeId: data['seller id'],
                                                        storeName: data['Shop Name'],
                                                      )),
                                                );
                                              },
                                              child: Icon(
                                                  CupertinoIcons.cart)),
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
                    }

                    return Text('');
                  }),
              SizedBox(
                height: 10,
              ),
              Text(
                'POPULAR NOW',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('products')
                      .where('popularNow', isEqualTo: true)
                      .get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return Container(
                        height: 120,
                        width: double.infinity  ,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                            return Container(
                              height: 120,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FoodDeliveryMainScreen(
                                            storeId: data['seller id'],
                                            storeName: data['Shop Name'],
                                          )),
                                    );
                                  },
                                  splashColor: Colors.greenAccent,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black87),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      height: 120,
                                      width: 350,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        data['imgUrl']),
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                             Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  data['product name'],
                                                  overflow:TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                Container(
                                                  width: 220,
                                                  child: Text(
                                                    data['description'],
                                                    maxLines: 1,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                Text(
                                                  '\u20B1  ${data['price'].toString()}',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              )
                            );
                          }).toList(),
                        ),
                      );
                    }

                    return Text('');
                  }),
            ],
          ),
        ),
      ),
      drawer: Drawers(
          firebaseServices: _firebaseServices,
          user: user,
          data: data,
          auth: _auth),
    );
  }
}

class Drawers extends StatelessWidget {
  const Drawers({
    Key key,
    @required FirebaseServices firebaseServices,
    @required this.user,
    @required this.data,
    @required AuthService auth,
  })  : _firebaseServices = firebaseServices,
        _auth = auth,
        super(key: key);

  final FirebaseServices _firebaseServices;
  final Users user;
  final String data;
  final AuthService _auth;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: _firebaseServices.readPartner(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              print(snapshot.data);
              return DrawerOriginal(
                auth: _auth,
                email: user.email,
              );
            } else {
              Map<String, dynamic> datas = snapshot.data;
              print(datas["Category"]);
              return DrawerPartner(
                auth: _auth,
                category: datas["Category"],
                shopEmail: user.email,
                shopName: datas['Shop Name'],
              );
            }
          }
          return Drawer(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

class DrawerOriginal extends StatelessWidget {
  const DrawerOriginal({
    Key key,
    @required AuthService auth,
    this.email,
  })  : _auth = auth,
        super(key: key);

  final AuthService _auth;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  color: Colors.lightBlue,
                  width: double.infinity,
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Name Last Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          email,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '0987654321',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                ProfileButton(
                  title: "My Orders",
                  color: Colors.black87,
                  icon: CupertinoIcons.list_dash,
                  click: () {
                    Navigator.popAndPushNamed(context, MyOrders.routeName);
                  },
                ),
              ],
            ),
            Column(
              children: [
                ProfileButton(
                  title: "Become a Partner",
                  color: Colors.black87,
                  icon: FontAwesomeIcons.handshake,
                  click: () {
                    Navigator.popAndPushNamed(context, Partner.routeName);
                  },
                ),
                ProfileButton(
                  title: "Log Out",
                  color: Colors.black87,
                  icon: CupertinoIcons.fullscreen_exit,
                  click: () async {
                    await _auth.signOut();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerPartner extends StatelessWidget {
  const DrawerPartner({
    Key key,
    @required AuthService auth,
    this.category,
    this.shopName,
    this.shopEmail,
  })  : _auth = auth,
        super(key: key);

  final AuthService _auth;
  final String category, shopName, shopEmail;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  color: Colors.lightBlue,
                  width: double.infinity,
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          shopName,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          shopEmail,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                if (category == "Merchant")
                  ProfileButton(
                    title: "Manage my store",
                    color: Colors.black87,
                    icon: FontAwesomeIcons.shopify,
                    click: () {
                      Navigator.popAndPushNamed(
                          context, MarketplaceProfile.routeName);
                    },
                  ),
                if (category == "Food Delivery")
                  ProfileButton(
                    title: "Manage my Product",
                    color: Colors.black87,
                    icon: FontAwesomeIcons.hamburger,
                    click: () {
                      Navigator.popAndPushNamed(
                          context, FoodDeliveryProfile.routeName);
                    },
                  ),
                if (category == "Rider")
                  ProfileButton(
                    title: "Manage Rider Profile",
                    color: Colors.black87,
                    icon: FontAwesomeIcons.handshake,
                    click: () {
                      Navigator.popAndPushNamed(
                          context, PawItProfile.routeName);
                    },
                  ),
              ],
            ),
            Column(
              children: [
                ProfileButton(
                  title: "Log Out",
                  color: Colors.black87,
                  icon: CupertinoIcons.fullscreen_exit,
                  click: () async {
                    await _auth.signOut();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    Key key,
    this.icon,
    this.title,
    this.color,
    this.click,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Color color;
  final Function click;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: click,
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 16, color: color),
          )
        ],
      ),
    );
  }
}
