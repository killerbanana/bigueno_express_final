import 'package:biguenoexpress/screens/foodelivery/food_delivery.dart';
import 'package:biguenoexpress/screens/home/home_screen.dart';
import 'package:biguenoexpress/screens/marketplace/marketplace.dart';
import 'package:biguenoexpress/screens/marketplace/marketplace_profile.dart';
import 'package:biguenoexpress/screens/partner/partner.dart';
import 'package:biguenoexpress/screens/partner/register/register_food_delivery.dart';
import 'package:biguenoexpress/screens/partner/register/register_merchant.dart';
import 'package:biguenoexpress/screens/partner/register/register_rider.dart';
import 'package:biguenoexpress/screens/pawit/paw_it.dart';
import 'package:flutter/widgets.dart';
import 'wrapper.dart';

final Map<String, WidgetBuilder> routes = {
  Wrapper.routeName: (context) => Wrapper(),
  HomeScreen.routeName: (context) => HomeScreen(),
  MarketPlace.routeName: (context) => MarketPlace(),
  FoodDelivery.routeName: (context) => FoodDelivery(),
  PawIt.routeName: (context) => PawIt(),
  Partner.routeName: (context) => Partner(),
  RegisterFoodDelivery.routeName: (context) => RegisterFoodDelivery(),
  RegisterMerchant.routeName: (context) => RegisterMerchant(),
  RegisterRider.routeName: (context) => RegisterRider(),
  MarketPlaceProfile.routeName: (context) => MarketPlaceProfile(),

};

