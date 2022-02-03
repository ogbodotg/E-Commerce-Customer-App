import 'package:ahia/Services/CartServices.dart';
import 'package:ahia/Widgets/Cart/CounterWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddToCartWidget extends StatefulWidget {
  final DocumentSnapshot document;

  AddToCartWidget(this.document);

  @override
  _AddToCartWidgetState createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  CartServices _cart = CartServices();
  User user = FirebaseAuth.instance.currentUser;
  bool _loading = true;
  bool _exist = false;
  int _qty = 1;
  String _docId;

  @override
  void initState() {
    getCartData(); // Check if product is already in cart or not
    // TODO: implement initState
    super.initState();
  }

  getCartData() async {
    final snapshot =
        await _cart.cart.doc(user.uid).collection('products').get();
    if (snapshot.docs.length == 0) {
      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products')
        .where('productId', isEqualTo: widget.document.data()['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['productId'] == widget.document.data()['productId']) {
          // meaning product already exists in particular users cart
          setState(() {
            _exist = true;
            _qty = doc['quantity'];
            _docId = doc.id;
          });
        }
      });
    });

    return _loading
        ? Container(
            height: 56,
            child: Center(
                child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            )),
          )
        : _exist
            ? CounterWidget(
                document: widget.document,
                qty: _qty,
                docId: _docId,
              )
            : InkWell(
                onTap: () {
                  EasyLoading.show(status: 'Adding to cart');
                  _cart.checkSeller().then((shopName) {
                    if (shopName ==
                        widget.document.data()['seller']['shopName']) {
                      setState(() {
                        _exist = true;
                      });
                      _cart.addToCart(widget.document).then((value) {
                        EasyLoading.showSuccess('Added to cart');
                      });
                      return;
                    }
                    // else {

                    // }
                    if (shopName == null) {
                      setState(() {
                        _exist = true;
                      });
                      _cart.addToCart(widget.document).then((value) {
                        EasyLoading.showSuccess('Added to cart');
                      });
                      return;
                    }

                    if (shopName !=
                        widget.document.data()['seller']['shopName']) {
                      EasyLoading.dismiss();
                      showDialog(shopName);
                    }
                  });

                  // _cart.addToCart(widget.document).then((value) {
                  //   setState(() {
                  //     _exist = true;
                  //   });
                  // });
                  // EasyLoading.showSuccess('Added to cart');
                },
                child: Container(
                  height: 80,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.cart, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Add to cart',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }

  showDialog(shopName) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Replace Cart Item'),
            content: Text(
                'Your cart contains item(s) from $shopName. Do you want to remove the current item(s) and add item(s) from ${widget.document.data()['seller']['shopName']}'),
            actions: [
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  _cart.deleteCart().then((value) {
                    _cart.addToCart(widget.document).then((value) {
                      setState(() {
                        _exist = true;
                      });
                      Navigator.pop(context);
                    });
                  });
                },
              )
            ],
          );
        });
  }
}
