import 'package:ahia/Providers/StoreProvider.dart';
import 'package:ahia/Services/ProductServices.dart';
import 'package:ahia/Widgets/Products/ProductCardWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeaturedProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _store = Provider.of<StoreProvider>(context);
    return FutureBuilder<QuerySnapshot>(
      future: _services.product
          .where('published', isEqualTo: true)
          .where('collection', isEqualTo: 'Featured Products')
          .where('seller.sellerUid', isEqualTo: _store.storeDetails['uid'])
          .limit(10)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Center(child: CircularProgressIndicator());
        // }
        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.data.docs.isEmpty) {
          return Container();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: FittedBox(
                      child: Text('Featured Products',
                          style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Colors.black,
                              )
                            ],
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    ),
                  ),
                ),
              ),
            ),
            new ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return new ProductCard(document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
