import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {
  String status;
  filterOrder(status) {
    this.status = status;
    notifyListeners();
  }
}
