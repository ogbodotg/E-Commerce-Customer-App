import 'package:ahia/Widgets/Cart/Counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
  final DocumentSnapshot document;
  CartCard({this.document});
  @override
  Widget build(BuildContext context) {
    double saving = document.data()['comparedPrice'] - document.data()['price'];
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(document.data()['productImage'],
                        fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(document.data()['productName']),
                        if (document.data()['comparedPrice'] >
                            document.data()['price'])
                          Text(
                              'N${document.data()['comparedPrice'].toStringAsFixed(0)}',
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12)),
                        Text('N${document.data()['price'].toStringAsFixed(0)}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              right: 0.0,
              bottom: 0.0,
              child: CounterForCard(document),
            ),
            if (saving > 0)
              Container(
                decoration: BoxDecoration(
                  // color: Theme.of(context).primaryColor,
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 3, bottom: 3),
                  child: Text(
                    'Save N${saving.toStringAsFixed(0)}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            // Positioned(
            //     child: CircleAvatar(
            //   backgroundColor: Theme.of(context).primaryColor,
            //   child: Text(
            //     'N${saving.toStringAsFixed(0)}',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ))
          ],
        ),
      ),
    );
  }
}
