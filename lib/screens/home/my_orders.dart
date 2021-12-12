import 'package:flutter/material.dart';

import 'order_status/cancelled.dart';
import 'order_status/completed.dart';
import 'order_status/for_confirmation.dart';
import 'order_status/for_delivery.dart';

class MyOrders extends StatefulWidget {
  static String routeName = "/myOrders";

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          title: Text(
            'My Orders',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Text('For Confirmation'),
              Text('For Delivery'),
              Text('Completed'),
              Text('Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ForConfirmation(),
            ForDelivery(),
            Completed(),
            Cancelled(),
          ],
        ),
      ),
    );
  }
}
