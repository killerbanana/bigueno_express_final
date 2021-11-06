import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference myCollection = FirebaseFirestore.instance.collection('Users');

  Future updateUserData(String name, String email) async{
    return await myCollection.doc(uid).set({
      'Name' : name,
      'Email' : email,
    });
  }

  Stream<QuerySnapshot> get collections{
    return myCollection.snapshots();
  }
}