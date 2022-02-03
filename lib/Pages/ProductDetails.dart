import 'dart:io';

import 'package:ahia/Pages/ViewImage.dart';
import 'package:ahia/Services/ProductServices.dart';
import 'package:ahia/Widgets/Products/BottomSheetContainer.dart';
import 'package:ahia/Widgets/VendorBanner.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProductDetails extends StatelessWidget {
  static const String id = 'product-details';
  final DocumentSnapshot document;

  ProductDetails({this.document});

  @override
  Widget build(BuildContext context) {
    ProductServices _productServices = ProductServices();

    Widget imagesView() {
      return new CarouselSlider(
        items: [
          document.data()['productImages1'] ?? '',
          document.data()['productImages2'] ?? '',
          document.data()['productImages3'] ?? '',
          document.data()['productImages4'] ?? '',
          document.data()['productImages5'] ?? '',
          document.data()['productImages6'] ?? '',
        ].map((e) {
          return new Builder(builder: (BuildContext context) {
            return new Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              margin: new EdgeInsets.symmetric(horizontal: 5),
              decoration: new BoxDecoration(
                color: Colors.amber,
              ),
              child: new GestureDetector(
                  child: Image.network(e, fit: BoxFit.fill),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Show(e)));
                  }),
            );
          });
        }).toList(),
        options: null,
      );
    }

    String offer =
        ((document.data()['comparedPrice'] - document.data()['price']) /
                (document.data()['comparedPrice']) *
                100)
            .toStringAsFixed(00);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.search),
            onPressed: () {},
          )
        ],
      ),
      bottomSheet: BottomSheetContainer(document),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.3),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8, bottom: 2, top: 2),
                    child: Text(document.data()['brand']),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(document.data()['productName'],
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Text('\NGN${document.data()['price'].toStringAsFixed(0)}',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                if (document.data()['comparedPrice'] > document.data()['price'])
                  Text(
                    '\NGN${document.data()['comparedPrice'].toStringAsFixed(0)}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough),
                  ),
                SizedBox(width: 10),
                if (document.data()['comparedPrice'] > document.data()['price'])
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 3, bottom: 3),
                      child: Text('${offer}% OFF',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 12)),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Hero(
                  tag: 'product${document.data()['productName']}',
                  child: Image.network(document.data()['productImage'])),
            ),
            Divider(color: Colors.grey[300], thickness: 6),
            Container(
                child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('About this product', style: TextStyle(fontSize: 20)),
            )),
            Divider(color: Colors.grey[300], thickness: 6),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
              child: ExpandableText(
                document.data()['productDescription'],
                expandText: 'read more',
                collapseText: 'show less',
                maxLines: 3,
                linkColor: Colors.blue,
                // style: TextStyle(color: Colors.grey),
              ),
            ),
            Divider(color: Colors.grey[400]),
            Container(
                child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Products Images', style: TextStyle(fontSize: 20)),
            )),
            Divider(color: Colors.grey[400]),
            if (document.data()['productImages1'] != "")
              Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                    tag: 'product images',
                    child: Image.network(document.data()['productImages1'])),
              ),
            if (document.data()['productImages2'] != "")
              Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                    tag: 'product images',
                    child: Image.network(document.data()['productImages2'])),
              ),
            if (document.data()['productImages3'] != "")
              Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                    tag: 'product images',
                    child: Image.network(document.data()['productImages3'])),
              ),
            if (document.data()['productImages4'] != "")
              Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                    tag: 'product images',
                    child: Image.network(document.data()['productImages4'])),
              ),
            if (document.data()['productImages5'] != "")
              Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                    tag: 'product images',
                    child: Image.network(document.data()['productImages5'])),
              ),
            if (document.data()['productImages6'] != "")
              Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                    tag: 'product images',
                    child: Image.network(document.data()['productImages6'])),
              ),
            Divider(color: Colors.grey[400]),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Seller: ${document.data()['seller']['shopName']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
                ],
              ),
            ),
            SizedBox(height: 10),
            // Text('Star rating ***'),
            // Text('Comment area'),
            SizedBox(height: 100)
          ],
        ),
      ),
    );
  }

  // Future<void> addToFavourite() {
  //   CollectionReference _favourite =
  //       FirebaseFirestore.instance.collection('favourites');
  //   User user = FirebaseAuth.instance.currentUser;
  //   return _favourite.add({
  //     'product': document.data(),
  //     'customerId': user.uid,
  //   });
  // }
}
