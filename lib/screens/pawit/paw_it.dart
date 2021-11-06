import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PawIt extends StatelessWidget {
  static String routeName = "/paw_it";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paw It'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CupertinoSearchTextField(
                placeholder: 'Search Rider',
                onChanged: (String value) {
                  print('The text has changed to: $value');
                },
                onSubmitted: (String value) {
                  print('Submitted text: $value');
                },
              ),
              SizedBox(height: 20,),
              Text('Available Riders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              SizedBox(height: 20,),
              ListView.builder(
                itemCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  color: Colors.red,
                                ),
                                RatingBarIndicator(
                                  rating: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 16.0,
                                  direction: Axis.horizontal,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('JL Tugas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.blue, size: 16,),
                                  Text('Barangay Cuta', style: TextStyle(fontWeight: FontWeight.w300),),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.circle, color: Colors.green, size: 16,),
                                  Text('Online', style: TextStyle(fontWeight: FontWeight.w300),),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.phone, color: Colors.blue, size: 16,),
                                  Text('0987654321', style: TextStyle(fontWeight: FontWeight.w300),),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black87),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.chat_bubble),
                                  Text('Chat'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  }),
              SizedBox(height: 20,),
              Divider(thickness: 5,),
              Text('Currently Not Available', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              SizedBox(height: 20,),
              ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    color: Colors.red,
                                  ),
                                  RatingBarIndicator(
                                    rating: 5,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 16.0,
                                    direction: Axis.horizontal,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Ossas Boy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.blue, size: 16,),
                                    Container(
                                      width: 120,
                                        child: Text('Barangay Pandayan', style: TextStyle(fontWeight: FontWeight.w300), softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 2,)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.circle, color: Colors.orange, size: 16,),
                                    Text('Driving', style: TextStyle(fontWeight: FontWeight.w300),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.phone, color: Colors.blue, size: 16,),
                                    Text('0987654321', style: TextStyle(fontWeight: FontWeight.w300),),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black87),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.chat_bubble),
                                    Text('Chat'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
