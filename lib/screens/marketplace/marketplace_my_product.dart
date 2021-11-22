import 'package:biguenoexpress/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MarketplaceMyProduct extends StatelessWidget {
  static String routeName = "/marketplace_my_product";
  final CollectionReference _marketplaceProduct = FirebaseFirestore.instance.collection('products');

  Users user;
  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Product'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _marketplaceProduct.where('seller id', isEqualTo: user.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              shrinkWrap: true,
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(data['imgUrl']),
                  ),
                  title: Text(data['product name']),
                  subtitle: Text('\u20B1' + ' '+  data['price'].toString()),
                  trailing: Text('Edit'),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
