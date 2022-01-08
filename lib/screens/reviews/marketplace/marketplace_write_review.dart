import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:biguenoexpress/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class MarketPlaceWriteReview extends StatefulWidget {
  static String routeName = "/write a review";
  final String sellerId;

  const MarketPlaceWriteReview({Key key, this.sellerId}) : super(key: key);

  @override
  State<MarketPlaceWriteReview> createState() => _MarketPlaceWriteReviewState();
}

class _MarketPlaceWriteReviewState extends State<MarketPlaceWriteReview> {
  TextEditingController _experienceCtrl;
  FirebaseServices _firebaseServices = FirebaseServices();

  double _rating;
  String _comment = "";

  bool _loading = false;

  Users user;

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return FutureBuilder(
        future: _firebaseServices.checkIfReview(user.uid, widget.sellerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            _experienceCtrl.text = snapshot.data['comment'];
            _rating = snapshot.data['rating'].toDouble();

            return Scaffold(
              appBar: AppBar(
                title: Text('Write a review'),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.email),
                            Text(
                              'Reviews are public and include your email.',
                              maxLines: 2,
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RatingBar.builder(
                      initialRating: snapshot.data['rating'].toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        _rating = rating;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _experienceCtrl,
                      style: TextStyle(color: Colors.black45),
                      maxLength: 500,
                      minLines: 1,
                      maxLines: 20,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide: const BorderSide(
                              color: Colors.black45, width: 1.0),
                        ),
                        hintText: "Describe your experience",
                        hintStyle: TextStyle(color: Colors.black45),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _loading
                        ? CircularProgressIndicator()
                        : RoundedButton(
                            btnText: 'Submit',
                            press: () async {
                              setState(() {
                                _loading = true;
                              });
                              await _firebaseServices.updateMarketRating(
                                  user.uid,
                                  widget.sellerId,
                                  _rating,
                                  _experienceCtrl.text);
                              setState(() {
                                _loading = false;
                              });
                              await _firebaseServices
                                  .checkStoreReview(widget.sellerId);
                              Navigator.pop(context);
                            },
                          ),
                    Text(
                      'Ratings and reviews',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('ratings')
                                  .where("seller id", isEqualTo: widget.sellerId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if(snapshot.connectionState == ConnectionState.active && snapshot.hasData){
                                  return Column(
                                      children: snapshot.data.docs
                                          .map((DocumentSnapshot document) {
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
                                            document['comment'] != null? Text(
                                              document['comment'],
                                              maxLines: 20,
                                            ) : Text(''),
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
                                return Center(child: CircularProgressIndicator(),);
                              }),
                        ))
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Write a review'),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.email),
                            Text(
                              'Reviews are public and include your email.',
                              maxLines: 2,
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        _rating = rating;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _experienceCtrl,
                      style: TextStyle(color: Colors.black45),
                      maxLength: 500,
                      minLines: 1,
                      maxLines: 20,
                      onChanged: (value) => _comment = value,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide: const BorderSide(
                              color: Colors.black45, width: 1.0),
                        ),
                        hintText: "Describe your experience",
                        hintStyle: TextStyle(color: Colors.black45),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _loading
                        ? CircularProgressIndicator()
                        : RoundedButton(
                            btnText: 'Submit',
                            press: () async {
                              setState(() {
                                _loading = true;
                              });
                              await _firebaseServices.addMarketRating(
                                  user.uid,
                                  widget.sellerId,
                                  _rating,
                                  _comment, user.email);
                              await _firebaseServices
                                  .checkStoreReview(widget.sellerId);
                              setState(() {
                                _loading = false;
                              });
                              Navigator.pop(context);
                            },
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 2,
                      thickness: 3,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Ratings and reviews',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('ratings')
                              .where("seller id", isEqualTo: widget.sellerId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if(snapshot.connectionState == ConnectionState.active){
                              return Column(
                                  children: snapshot.data.docs
                                      .map((DocumentSnapshot document) {
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
                                        Text(
                                          document['comment'],
                                          maxLines: 20,
                                        ),
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
                            return Center(child: CircularProgressIndicator(),);
                          }),
                    ))
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _experienceCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _experienceCtrl.dispose();
    super.dispose();
  }
}
