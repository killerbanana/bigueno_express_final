import 'package:biguenoexpress/screens/foodelivery/food_delivery.dart';
import 'package:biguenoexpress/screens/home/home_screen.dart';
import 'package:biguenoexpress/screens/marketplace/marketplace.dart';
import 'package:biguenoexpress/screens/pawit/paw_it.dart';
import 'package:flutter/widgets.dart';
import 'wrapper.dart';

final Map<String, WidgetBuilder> routes = {
  Wrapper.routeName: (context) => Wrapper(),
  HomeScreen.routeName: (context) => HomeScreen(),
  MarketPlace.routeName: (context) => MarketPlace(),
  FoodDelivery.routeName: (context) => FoodDelivery(),
  PawIt.routeName: (context) => PawIt(),
};

