import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:biguenoexpress/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class UpdateCaption extends StatefulWidget {
  final String sellerId;
  const UpdateCaption({Key key, this.sellerId}) : super(key: key);

  @override
  _UpdateCaptionState createState() => _UpdateCaptionState();
}

class _UpdateCaptionState extends State<UpdateCaption> {

  TextEditingController _captionCtrl;
  FirebaseServices _firebaseServices = FirebaseServices();

  double _rating;
  String _caption = "";

  bool _loading = false;

  Users user;

  @override
  void initState() {
    super.initState();
    _captionCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _captionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Caption'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _captionCtrl,
              style: TextStyle(color: Colors.black45),
              maxLength: 500,
              minLines: 1,
              maxLines: 20,
              onChanged: (value) => _caption = value,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(
                      color: Colors.black45, width: 1.0),
                ),
                hintText: "Please enter your store caption.!",
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
                await _firebaseServices.updateMarketCaption(widget.sellerId, _caption);
                setState(() {
                  _loading = false;
                });
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
