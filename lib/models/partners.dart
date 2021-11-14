import 'package:flutter/cupertino.dart';

class Partners with ChangeNotifier{
  final String uid;
  final String category;
  final String name;
  final String time;
  final String address;
  final bool setUp;
  Partners(this.category, this.name, this.time, this.address, this.setUp, this.uid);
}