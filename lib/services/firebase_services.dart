import 'package:biguenoexpress/models/partners.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseServices extends ChangeNotifier {
  CollectionReference _discount =
  FirebaseFirestore.instance.collection('discount');

  CollectionReference _freeDelivery =
  FirebaseFirestore.instance.collection('free delivery');

  CollectionReference partner =
      FirebaseFirestore.instance.collection('partner');
  CollectionReference message = FirebaseFirestore.instance.collection('chat');
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  CollectionReference product =
      FirebaseFirestore.instance.collection('products');

  Partners myPartner;
  String category = "";
  Partners get partners {
    return myPartner;
  }

  Future sendMessage(
      String uid, String sender, String receiver, String messages) {
    return message
        .doc(uid)
        .collection('chats')
        .doc(receiver)
        .collection('messages')
        .doc()
        .set({
          "date": DateTime.now(),
          "message": messages,
          "sender": sender,
          "receiver": receiver
        })
        .then((value) => print("Message Sent"))
        .catchError((error) => print("Failed to send message: $error"));
  }

  Future receiveMessage(
      String uid, String sender, String receiver, String messages) {
    return message
        .doc(receiver)
        .collection('chats')
        .doc(uid)
        .collection('messages')
        .doc()
        .set({
          "date": DateTime.now(),
          "message": messages,
          "sender": sender,
          "receiver": receiver
        })
        .then((value) => print("Message Sent"))
        .catchError((error) => print("Failed to send message: $error"));
  }

  Future addToChat(String uid, String receiver, String messages, String name) {
    return chats
        .doc(uid)
        .collection('chats')
        .doc(receiver)
        .set({"message": messages, "name": name})
        .then((value) => print("Message Sent"))
        .catchError((error) => print("Error $error"));
  }

  Future sentMessage(String uid, String sender, String messages, String name) {
    return chats
        .doc(uid)
        .collection('chats')
        .doc(sender)
        .set({"message": messages, "name": name})
        .then((value) => print("Message Sent"))
        .catchError((error) => print("Error $error"));
  }

  Future addProductMerchant(String uid, String name, int price, String desc,
      int stock, String imgUrl) {
    return product
        .doc()
        .set({
          "product name": name,
          "price": price,
          "description": desc,
          "stock": stock,
          "seller id": uid,
          "imgUrl": imgUrl,
          "category": "market",
          "date added": DateTime.now()
        })
        .then((value) => "Product added")
        .catchError((error) => "error: $error");
  }

  Future addProductFoodDelivery(String uid, String name, int price, String desc,
      int stock, String imgUrl, int off, double discountedPrice) {
    return product
        .doc()
        .set({
      "product name": name,
      "price": price,
      "description": desc,
      "stock": stock,
      "seller id": uid,
      "imgUrl": imgUrl,
      "category": "food delivery",
      "daily deals": false,
      "% off": off,
      "date added": DateTime.now(),
      "discounted price": discountedPrice,
    })
        .then((value) => "Product added")
        .catchError((error) => "error: $error");
  }

  Future updateProductFoodDelivery(String uid, String name, int price, String desc,
      int stock, String imgUrl, String productId) {
    return product
        .doc(productId)
        .update({
      "product name": name,
      "price": price,
      "description": desc,
      "stock": stock,
      "seller id": uid,
      "imgUrl": imgUrl,
      "category": "food delivery",
      "daily deals": false,
      "% off": 0,
      "date updated": DateTime.now()
    })
        .then((value) => "Product updated")
        .catchError((error) => "error: $error");
  }

  Future addMerchant(String uid, String shopName, String address,
      String openingHours, String url, String desc) {
    myPartner =
        new Partners("Merchant", shopName, openingHours, address, false, uid);
    category = "Merchant";
    notifyListeners();
    return partner
        .doc(uid)
        .set({
          "Shop Name": myPartner.name,
          "Address": myPartner.address,
          "Opening Hours": myPartner.time,
          "Set up": myPartner.setUp,
          "Category": myPartner.category,
          "Image url": url,
          "Short desc": desc
        })
        .then((value) => print("Added Merchant"))
        .catchError((error) => print("Failed to add Merchant: $error"));
  }

  Future addFoodDelivery(
      String uid, String shopName, String address, String openingHours, String url, String desc, int rating, String devTime) {
    myPartner = new Partners(
        "Food Delivery", shopName, openingHours, address, false, uid);
    category = "Food Delivery";
    notifyListeners();
    return partner
        .doc(uid)
        .set({
          'Shop Name': shopName,
          'Address': address,
          'Opening Hours': openingHours,
          'Category': 'Food Delivery',
      "Image url": url,
      "Short desc": desc,
          'Set up': false,
      "Rating": 0,
      "Delivery Time": devTime,
      "Free Delivery": false,
      "Percent Off": 0
        })
        .then((value) => print("Food Delivery Added"))
        .catchError((error) => print("Failed to add Food Delivery: $error"));
  }

  Future addFoodDeliveryDiscount(
      String uid, int discount) {
    return _discount.doc(uid)
        .set({
      "% off": discount,
    })
        .then((value) => print("Food Delivery Added"))
        .catchError((error) => print("Failed to add Food Delivery: $error"));
  }

  Future addRider(
      String uid, String shopName, String address, String openingHours) {
    myPartner = new Partners(
        "Food Delivery", shopName, openingHours, address, false, uid);
    category = "Food Delivery";
    notifyListeners();
    return partner
        .doc(uid)
        .set({
          'Rider Name': shopName,
          'Address': address,
          'Opening Hours': openingHours,
          'Category': 'Rider',
          'Set up': false
        })
        .then((value) => print("Rider Added"))
        .catchError((error) => print("Failed to add Rider: $error"));
  }

  Future checkPartnerIfExist(String uid) {
    return partner.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> datas;
        datas = documentSnapshot.data();
        notifyListeners();
        return datas;
      } else
        return null;
      // ignore: return_of_invalid_type_from_catch_error
    }).catchError((error) => print("Failed to add Merchant: $error"));
  }

  Future readPartner(String uid) async {
    dynamic datas = await checkPartnerIfExist(uid);
    return datas;
  }

  Future addMerchants(String uid, String shopName, String address,
      String openingHours, String url, String desc) async {
    dynamic result =
        await addMerchant(uid, shopName, address, openingHours, url, desc);
    myPartner =
        new Partners("Merchant", shopName, openingHours, address, false, uid);
    notifyListeners();
    return notifyListeners();
  }

  Future foodDeliveries(
      String uid, String shopName, String address, String openingHours, String url, String desc, int rating, String devTime) async {
    dynamic result =
        await addFoodDelivery(uid, shopName, address, openingHours, url, desc, rating, devTime);
    myPartner = new Partners(
        "Food Delivery", shopName, openingHours, address, false, uid);
    notifyListeners();
    return notifyListeners();
  }

  Future addRiders(
      String uid, String shopName, String address, String openingHours) async {
    dynamic result = await addRider(uid, shopName, address, openingHours);
    myPartner =
        new Partners("Rider", shopName, openingHours, address, false, uid);
    notifyListeners();
    return notifyListeners();
  }
}
