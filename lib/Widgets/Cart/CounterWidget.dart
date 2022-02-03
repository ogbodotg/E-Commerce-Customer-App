import 'package:ahia/Services/CartServices.dart';
import 'package:ahia/Widgets/Products/AddToCartWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  final DocumentSnapshot document;
  final int qty;
  final String docId;
  CounterWidget({this.document, this.qty, this.docId});

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  CartServices _cart = CartServices();
  int _qty;
  bool _updating = false;
  bool _exists = true;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _qty = widget.qty;
    });

    return _exists
        ? Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            height: 56,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                child: Row(children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _updating = true;
                      });
                      if (_qty == 1) {
                        _cart.removeFromCart(widget.docId).then((value) {
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
                            .updateCartQty(widget.docId, _qty, total)
                            .then((value) {
                          setState(() {
                            _updating = false;
                          });
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          _qty == 1 ? Icons.delete : Icons.remove,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 8, bottom: 8),
                      child: _updating
                          ? Container(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor)),
                            )
                          : Text(_qty.toString()),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _updating = true;
                        _qty++;
                      });
                      var total = _qty * widget.document.data()['price'];

                      _cart
                          .updateCartQty(widget.docId, _qty, total)
                          .then((value) {
                        setState(() {
                          _updating = false;
                        });
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            )),
          )
        : AddToCartWidget(widget.document);
  }
}
