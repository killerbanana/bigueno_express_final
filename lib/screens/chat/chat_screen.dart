import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/screens/chat/send_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  Users user;
  final CollectionReference _chatStream =
      FirebaseFirestore.instance.collection('chats');
  static String routeName = "/chat_screen";
  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatStream.doc(user.uid).collection('chats').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return InkWell(
                splashColor: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SendMessage(
                              receiverId: document.id,
                              receiverName: data['name'],
                            )),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24.0,
                    backgroundImage: NetworkImage(
                        "https://cdn.iconscout.com/icon/free/png-256/account-avatar-profile-human-man-user-30448.png"),
                  ),
                  title: Text(
                    data['name'],
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text(
                    data['message'].toString(),
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w400),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14.0,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
