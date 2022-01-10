import 'package:biguenoexpress/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class PawItComments extends StatefulWidget {
  static String routeName = "/profile/reviews";

  const PawItComments({Key key}) : super(key: key);

  @override
  _PawItCommentsState createState() => _PawItCommentsState();
}

class _PawItCommentsState extends State<PawItComments> {
  Users user;

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Reviews'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('ratings')
                    .where("seller id", isEqualTo: user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.active &&
                      snapshot.hasData) {
                    return Column(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24.0,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                    "https://cdn.iconscout.com/icon/free/png-256/account-avatar-profile-human-man-user-30448.png"),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(document['name'])
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RatingBarIndicator(
                            rating: document['rating'],
                            itemSize: 15,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          document['comment'] != null
                              ? Text(
                                  document['comment'],
                                  maxLines: 20,
                                )
                              : Text(''),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 2,
                            thickness: 2,
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    }).toList());
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ));
  }
}
