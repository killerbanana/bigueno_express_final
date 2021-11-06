import 'package:biguenoexpress/screens/foodelivery/food_delivery.dart';
import 'package:biguenoexpress/screens/pawit/paw_it.dart';
import 'package:biguenoexpress/services/auth.dart';
import 'package:biguenoexpress/widgets/icon_with_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../marketplace/marketplace.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home_screen";
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biguneo Express'),
        actions: [
          IconWithCounter(
            icon: FontAwesomeIcons.sms,
            numOfItem: 0,
          ),
          IconWithCounter(
            icon: FontAwesomeIcons.shoppingBag,
            numOfItem: 1,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DELICIOUS FOOD AT YOUR DOORSTEP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
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
                              Navigator.pushNamed(context, MarketPlace.routeName);
                            },
                            splashColor: Colors.greenAccent,
                            child: Container(
                              height: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_basket, size: 45,),
                                  Text('Marketplace', style: TextStyle(fontWeight: FontWeight.w400),)
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
                              Navigator.pushNamed(context, FoodDelivery.routeName);
                            },
                            splashColor: Colors.greenAccent,
                            child: Container(
                              height: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.fastfood, size: 45,),
                                  Text('Food Delivery', style: TextStyle(fontWeight: FontWeight.w400),)
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
                                  Icon(FontAwesomeIcons.motorcycle, size: 45,),
                                  Text('Paw it', style: TextStyle(fontWeight: FontWeight.w400),)
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
              Container(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                  'https://jb-ph-cdn.tillster.com/menu-images/prod/45df1872-c7f7-4b3d-baa9-1b0c4f56a5cc.png',
                                  fit: BoxFit.cover,
                                ),
                                footer: GridTileBar(
                                  backgroundColor: Colors.black45,
                                  title: Text(
                                    '\u20B1  125',
                                    textAlign: TextAlign.center,
                                  ),
                                  trailing:
                                  GestureDetector(
                                    onTap: () {

                                    },
                                      child: Icon(CupertinoIcons.cart)
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ),
                    )),
              ),
              SizedBox(height: 10,),
              Text('POPULAR NOW', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
              Container(
                height: 120,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {},
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
                                            image: NetworkImage("https://www.lutongbahayrecipe.com/wp-content/uploads/2019/04/lutong-bahay-recipe-filipino-beef-empanada-1200x755.jpg"),
                                        )
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Special Empanada', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                        Text('Aling Patatas Empanada', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),),
                                        Text('\u20B1  100', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                                      ],
                                    )
                                  ],
                                ),
                              )
                          ),
                        ),
                    )),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
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
                          SizedBox(height: 20,),
                          Text('Name Last Name', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
                          SizedBox(height: 5,),
                          Text('Test@email.com', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),),
                          SizedBox(height: 5,),
                          Text('0987654321', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),),
                        ],
                      ),
                    ),
                  ),
                  ProfileButton(title: "Profile Management", color: Colors.black87, icon: Icons.account_circle,),
                  ProfileButton(title: "Acount Settings", color: Colors.black87, icon: CupertinoIcons.settings,),
                  ProfileButton(title: "Favourites", color: Colors.black87, icon: FontAwesomeIcons.heart,),
                  ProfileButton(title: "Customer Service", color: Colors.black87, icon: FontAwesomeIcons.servicestack,),
                ],
              ),
              ProfileButton(title: "Log Out", color: Colors.black87, icon: CupertinoIcons.fullscreen_exit, click: () async{
               await _auth.signOut();
              },),
            ],
          ),
        )
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    Key key, this.icon, this.title, this.color, this.click,
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
            Icon(icon, color: color,),
            SizedBox(width: 10,),
            Text(title, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: color),)
          ],
        )
    );
  }
}
