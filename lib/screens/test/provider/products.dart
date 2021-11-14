import 'package:biguenoexpress/screens/test/model/product.dart';
import 'package:flutter/cupertino.dart';

class Products with ChangeNotifier{
  List<Product> _items = [];

  List<Product> get items{
    return [..._items];
  }

  void addProduct(){
    notifyListeners();
  }
}