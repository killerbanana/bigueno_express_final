
import 'package:biguenoexpress/models/partners.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseServices extends ChangeNotifier{
  CollectionReference partner =
  FirebaseFirestore.instance.collection('partner');
  Partners myPartner;
  String category = "";
  Partners get partners{
    return myPartner;
  }

  Future addMerchant(String uid, String shopName, String address, String openingHours) {
    myPartner = new Partners("Merchant", shopName, openingHours, address, false, uid);
    category = "Merchant";
    notifyListeners();
    return partner
        .doc(uid)
        .set({
      "Shop Name": myPartner.name,
      "Address": myPartner.address,
      "Opening Hours": myPartner.time,
      "Set up": myPartner.setUp,
      "Category": myPartner.category
    })
        .then((value) => print("Added Merchant"))
        .catchError((error) => print("Failed to add Merchant: $error"));
  }

  Future addFoodDelivery(String uid, String shopName, String address, String openingHours) {
    myPartner = new Partners("Food Delivery", shopName, openingHours, address, false, uid);
    category = "Food Delivery";
    notifyListeners();
    return partner
        .doc(uid)
        .set({
      'Shop Name': shopName,
      'Address': address,
      'Opening Hours': openingHours,
      'Category': 'Food Delivery',
      'Set up': false
    })
        .then((value) => print("Food Delivery Added"))
        .catchError((error) => print("Failed to add Food Delivery: $error"));
  }

  Future addRider(String uid, String shopName, String address, String openingHours) {
    myPartner = new Partners("Food Delivery", shopName, openingHours, address, false, uid);
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

  Future checkPartnerIfExist(String uid){
    return partner
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> datas;
        datas = documentSnapshot.data();
        notifyListeners();
        return datas;
      }
      else return null;
    // ignore: return_of_invalid_type_from_catch_error
    }).catchError((error) => print("Failed to add Merchant: $error"));
  }

  Future readPartner(String uid) async{
    dynamic datas = await checkPartnerIfExist(uid);
    return datas;
  }

  Future addMerchants(String uid, String shopName, String address, String openingHours) async{
    dynamic result = await addMerchant(uid, shopName, address, openingHours);
    myPartner = new Partners("Merchant", shopName, openingHours, address, false, uid);
    notifyListeners();
    return notifyListeners();
  }

  Future foodDeliveries(String uid, String shopName, String address, String openingHours) async{
    dynamic result = await addFoodDelivery(uid, shopName, address, openingHours);
    myPartner = new Partners("Food Delivery", shopName, openingHours, address, false, uid);
    notifyListeners();
    return notifyListeners();
  }

  Future addRiders(String uid, String shopName, String address, String openingHours) async{
    dynamic result = await addRider(uid, shopName, address, openingHours);
    myPartner = new Partners("Rider", shopName, openingHours, address, false, uid);
    notifyListeners();
    return notifyListeners();
  }
}