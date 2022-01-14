import 'package:biguenoexpress/models/products.dart';
import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/foodelivery/food_deliver_edit_product.dart';
import 'package:biguenoexpress/screens/foodelivery/food_delivery_add_product.dart';
import 'package:biguenoexpress/screens/marketplace/marketplace_edit_product.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MarketplaceMyProduct extends StatelessWidget {
  static String routeName = "/marketplaceMyProduct";
  final CollectionReference _marketplaceProduct = FirebaseFirestore.instance.collection('products');
  FirebaseServices _firebaseServices = FirebaseServices();
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
                  trailing: Container(
                    width: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () async {
                            await _firebaseServices.deleteProduct(document.id);
                          },
                          child: Icon(FontAwesomeIcons.trash, color: Colors.red,)
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MarketPlaceEditProduct(
                                      productId: document.id,
                                      product: new Products(
                                          document.id,
                                          data['product name'],
                                          false,
                                          data['description'],
                                          data['imgUrl'],
                                          data['price'],
                                          data['stock'],
                                          0,
                                          0),
                                    )));
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(
                                Colors.blueAccent),
                          ),
                          child: Text(
                            'EDIT',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
