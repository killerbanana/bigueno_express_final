import 'package:biguenoexpress/models/cart.dart';
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

  CollectionReference cart = FirebaseFirestore.instance.collection('shop cart');

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

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

  Future addOrder(String uid, String sellerId, List<dynamic> myCart,
      String devAddress, String name, String contactNumber, double total) {
    return orders
        .doc()
        .set({
          "date": DateTime.now(),
          "uid": uid,
          "seller": sellerId,
          "order": myCart,
          "status": "For Confirmation",
          "delivery address": devAddress,
          "name": name,
          "contact number": contactNumber,
          "total": total
        })
        .then((value) => print("Message Sent"))
        .catchError((error) => print("Failed to send message: $error"));
  }

  Future addToCart(String uid, String sellerId, String productId,
      String productName, double productPrice, int quantity, String imageUrl) {
    return cart
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .set({
          "seller": sellerId,
          "product name": productName,
          "product image": imageUrl,
          "quantity": quantity,
          "price": productPrice,
          "date added": DateTime.now()
        })
        .then((value) => print("Added to Cart"))
        .catchError((error) => print("Failed to add to cart: $error"));
  }

  Future updateCart(String uid, String sellerId, String productId,
      String productName, double quantity) {
    return cart
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .update({
          "seller": sellerId,
          "product name": productName,
          "quantity": quantity,
          "date added": DateTime.now()
        })
        .then((value) => print("Added to Cart"))
        .catchError((error) => print("Failed to add to cart: $error"));
  }

  Future deleteCart(String uid, String sellerId, String productId) {
    return cart
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .delete()
        .then((value) => print("Cart Removed"))
        .catchError((error) => print("Failed to remove cart: $error"));
  }

  Future deleteEntireCart(String userId) {
    return FirebaseFirestore.instance
        .collection('shop cart')
        .doc(userId)
        .collection('cart')
        .get()
        .then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    }).catchError((error) => print("Failed to delete user: $error"));
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

  Future updateProductFoodDelivery(
      String uid,
      String name,
      int price,
      String desc,
      int stock,
      String imgUrl,
      String productId,
      int off,
      double discountedPrice) {
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
          "% off": off,
          "date updated": DateTime.now(),
          "discounted price": discountedPrice,
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
          "Short desc": desc,
          "Rating": 0,
          "Verified": false
        })
        .then((value) => print("Added Merchant"))
        .catchError((error) => print("Failed to add Merchant: $error"));
  }

  Future addFoodDelivery(
      String uid,
      String shopName,
      String address,
      String openingHours,
      String url,
      String desc,
      int rating,
      String devTime) {
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
          "Percent Off": 0,
          "Verified": false
        })
        .then((value) => print("Food Delivery Added"))
        .catchError((error) => print("Failed to add Food Delivery: $error"));
  }

  Future addFoodDeliveryDiscount(String uid, int discount) {
    return _discount
        .doc(uid)
        .set({
          "% off": discount,
        })
        .then((value) => print("Food Delivery Added"))
        .catchError((error) => print("Failed to add Food Delivery: $error"));
  }

  Future addRider(String uid, String shopName, String address,
      String openingHours, String contact, String status, String imgUrl) {
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
          'Category': 'Rider',
          'Set up': false,
          'Contact Number': contact,
          'Status': status,
          "Img Url": imgUrl,
          "Verified": false
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
      String uid,
      String shopName,
      String address,
      String openingHours,
      String url,
      String desc,
      int rating,
      String devTime) async {
    dynamic result = await addFoodDelivery(
        uid, shopName, address, openingHours, url, desc, rating, devTime);
    myPartner = new Partners(
        "Food Delivery", shopName, openingHours, address, false, uid);
    notifyListeners();
    return notifyListeners();
  }

  Future addRiders(String uid, String shopName, String address,
      String openingHours, String contact, String imgUrl) async {
    dynamic result = await addRider(
        uid, shopName, address, openingHours, contact, "Online", imgUrl);
    myPartner =
        new Partners("Rider", shopName, openingHours, address, false, uid);
    notifyListeners();
    return notifyListeners();
  }
}
