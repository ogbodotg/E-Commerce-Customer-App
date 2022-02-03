import 'package:ahia/Services/CartServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CounterForCard extends StatefulWidget {
  final DocumentSnapshot document;
  CounterForCard(this.document);
  @override
  _CounterForCardState createState() => _CounterForCardState();
}

class _CounterForCardState extends State<CounterForCard> {
  User user = FirebaseAuth.instance.currentUser;
  CartServices _cart = CartServices();
  int _qty = 1;
  String _docId;
  bool _exists = false;
  bool _updating = false;

  getCartData() {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products')
        .where('productId', isEqualTo: widget.document.data()['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
              if (querySnapshot.docs.isNotEmpty)
                {
                  querySnapshot.docs.forEach((doc) {
                    if (doc['productId'] ==
                        widget.document.data()['productId']) {
                      // meaning product already exists in particular users cart
                      setState(() {
                        _qty = doc['quantity'];
                        _exists = true;
                        _docId = doc.id;
                      });
                    }
                  }),
                }
              else
                {
                  setState(() {
                    _exists = false;
                  })
                }
            });
  }

  @override
  void initState() {
    getCartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _exists
        ? StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return Container(
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _updating = true;
                          });
                          if (_qty == 1) {
                            _cart.removeFromCart(_docId).then((value) {
                              setState(() {
                                _updating = false;
                                _exists = false;
                              });
                              _cart.checkCartData();
                            });
                          }
                          if (_qty > 1) {
                            setState(() {
                              _qty--;
                            });
                            var total = _qty * widget.document.data()['price'];

                            _cart
                                .updateCartQty(_docId, _qty, total)
                                .then((value) {
                              setState(() {
                                _updating = false;
                              });
                            });
                          }
                        },
                        child: Container(
                          child: Icon(_qty == 1 ? Icons.delete : Icons.remove,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        width: 30,
                        color: Theme.of(context).primaryColor,
                        child: Center(
                            child: FittedBox(
                                child: _updating
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white)),
                                      )
                                    : Text(_qty.toString(),
                                        style:
                                            TextStyle(color: Colors.white)))),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _updating = true;
                            _qty++;
                          });
                          var total = _qty * widget.document.data()['price'];

                          _cart
                              .updateCartQty(_docId, _qty, total)
                              .then((value) {
                            setState(() {
                              _updating = false;
                            });
                          });
                        },
                        child: Container(
                          child: Icon(Icons.add,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ));
            },
          )
        : StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return InkWell(
                onTap: () {
                  EasyLoading.show(status: 'Adding to cart');

                  // remove entire checkSeller() function to allow customers buy from different vendors
                  _cart.checkSeller().then((shopName) {
                    if (shopName ==
                        widget.document.data()['seller']['shopName']) {
                      setState(() {
                        _exists = true;
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
                        _exists = true;
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

                  // use commented out code below to allow customers purchase from different vendors
                  // _cart.addToCart(widget.document).then((value) {
                  //   setState(() {
                  //     _exists = true;
                  //   });
                  //   EasyLoading.showSuccess('Added to cart');
                  // });
                },
                child: Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Text(
                        'Add to cart',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            },
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
                        _exists = true;
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
