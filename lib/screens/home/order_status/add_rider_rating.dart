import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:biguenoexpress/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class AddRiderRating extends StatefulWidget {
  final String riderId;
  final String transactionId;
  const AddRiderRating({Key key, this.riderId, this.transactionId}) : super(key: key);

  @override
  _AddMarketRatingState createState() => _AddMarketRatingState();
}

class _AddMarketRatingState extends State<AddRiderRating> {
  TextEditingController _experienceCtrl;
  FirebaseServices _firebaseServices = FirebaseServices();

  double _rating = 5;
  String _comment;

  bool _loading = false;

  Users user;

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
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
              initialRating: 5,
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
                  borderSide:
                      const BorderSide(color: Colors.black45, width: 1.0),
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
                      await _firebaseServices.addRiderRating(user.uid,
                          widget.riderId, _rating, _comment, user.email, widget.transactionId);
                      setState(() {
                        _loading = false;
                      });
                      await _firebaseServices.checkStoreReview(widget.riderId);
                      Navigator.pop(context);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
