import 'package:biguenoexpress/models/users.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SendMessage extends StatefulWidget {
  final senderId;
  final senderName;
  static String routeName = "/send_message";

  const SendMessage({Key key, this.senderId, this.senderName}) : super(key: key);

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  Users user;
  final CollectionReference _chatStream = FirebaseFirestore.instance.collection('chat');
  ScrollController _scrollController;
  TextEditingController _emailController;
  String message = "";

  FirebaseServices _firebaseServices  = FirebaseServices();
  @override
  void initState() {
    _emailController = TextEditingController();
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom(){
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.senderName),
      ),
      body: Stack(
        children: [
          Column(
              children: [
                Expanded(child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: StreamBuilder<QuerySnapshot>(
                                stream: _chatStream.doc(user.uid).collection('messages').doc(widget.senderId).collection('list').orderBy('date', descending: false ).snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Text("Loading");
                                  }

                                  return Column(
                                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                      if(data['sender'] == user.uid){
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(data['message']),
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                    color: Colors.blue
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      else{
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(data['message']),
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10)),
                                                    color: Colors.green
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  }).toList(),
                                  );
                                },
                      ),
                    ),
                  ],
                )),
                Container(
                  color: Colors.blueAccent,
                  height: 65,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: _emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderSide: const BorderSide(color: Colors.white, width: 0.0),
                              ),
                              hintText: "Compose a message",
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(CupertinoIcons.mail, color: Colors.white,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextButton(
                              onPressed: () async{
                                dynamic result =  await _firebaseServices.sendMessage(user.uid, widget.senderId, user.uid, _emailController.text);
                                _emailController.clear();
                                scrollToBottom();
                              },
                              child: Icon(Icons.send, color: Colors.white,),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
          ),
        ],
      ),
    );
  }
}
