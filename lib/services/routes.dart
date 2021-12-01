import 'package:biguenoexpress/screens/chat/chat_screen.dart';
import 'package:biguenoexpress/screens/chat/send_message.dart';
import 'package:biguenoexpress/screens/foodelivery/food_deliver_edit_product.dart';
import 'package:biguenoexpress/screens/foodelivery/food_delivery.dart';
import 'package:biguenoexpress/screens/foodelivery/food_delivery_add_product.dart';
import 'package:biguenoexpress/screens/foodelivery/food_delivery_my_product.dart';
import 'package:biguenoexpress/screens/foodelivery/food_delivery_profile.dart';
import 'package:biguenoexpress/screens/home/home_screen.dart';
import 'package:biguenoexpress/screens/marketplace/marketplace.dart';
import 'package:biguenoexpress/screens/marketplace/marketplace_add_product.dart';
import 'package:biguenoexpress/screens/marketplace/marketplace_my_product.dart';
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
  MarketPlaceAddProduct.routeName: (context) => MarketPlaceAddProduct(),
  ChatScreen.routeName: (context) => ChatScreen(),
  SendMessage.routeName: (context) => SendMessage(),
  MarketplaceProfile.routeName: (context) => MarketplaceProfile(),
  MarketplaceMyProduct.routeName: (context) => MarketplaceMyProduct(),
  FoodDeliveryProfile.routeName: (context) => FoodDeliveryProfile(),
  FoodDeliveryAddProduct.routeName: (context) => FoodDeliveryAddProduct(),
  FoodDeliveryMyProduct.routeName: (context) => FoodDeliveryMyProduct(),
  FoodDeliveryEditProduct.routeName: (context) => FoodDeliveryEditProduct(),
};
