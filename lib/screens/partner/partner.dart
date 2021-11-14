import 'package:biguenoexpress/screens/partner/register/register_food_delivery.dart';
import 'package:biguenoexpress/screens/partner/register/register_merchant.dart';
import 'package:biguenoexpress/screens/partner/register/register_rider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Partner extends StatelessWidget {
  static String routeName = "/partner";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Become a Bigueno Partner'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, RegisterMerchant.routeName);
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.greenAccent,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.shopping_basket,
                        size: 45,
                        color: Colors.black87,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Register as Merchant',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(
                        context, RegisterFoodDelivery.routeName);
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.greenAccent,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.fastfood,
                        size: 45,
                        color: Colors.black87,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Register as Food Delivery',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, RegisterRider.routeName);
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.greenAccent,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.motorcycle,
                        size: 45,
                        color: Colors.black87,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Register as Rider',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
