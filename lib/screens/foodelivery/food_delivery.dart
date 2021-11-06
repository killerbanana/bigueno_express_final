import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodDelivery extends StatelessWidget {
  static String routeName = "/food_delivery";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Delivery'),
        centerTitle: true,
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
                      icon: Icon(Icons.view_list_rounded), onPressed: () {

                  }),
                  IconButton(icon: Icon(Icons.grid_view), onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
