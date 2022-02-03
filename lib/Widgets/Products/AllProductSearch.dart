import 'package:ahia/Models/ProductModel.dart';
import 'package:ahia/Pages/ProductDetails.dart';
import 'package:ahia/Widgets/Cart/Counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AllProductSearch extends StatelessWidget {
  final String offer;
  final AllProduct allProducts;
  final DocumentSnapshot document;
  const AllProductSearch({Key key, this.offer, this.allProducts, this.document})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.grey[300])),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
        child: Row(children: [
          Stack(
            children: [
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings(name: ProductDetails.id),
                      screen: ProductDetails(document: allProducts.document),
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  child: SizedBox(
                    height: 140,
                    width: 130,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                            tag:
                                'product${allProducts.document.data()['productName']}',
                            child: Image.network(
                                allProducts.document.data()['productImage']))),
                  ),
                ),
              ),
              if (allProducts.document.data()['comparedPrice'] >
                  allProducts.document.data()['price'])
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
                      '${offer}% OFF',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allProducts.document.data()['brand'],
                            style: TextStyle(fontSize: 10),
                          ),
                          SizedBox(height: 5),
                          Text(
                            allProducts.document.data()['productName'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                  '\N${allProducts.document.data()['price'].toStringAsFixed(00)}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 10),
                              if (allProducts.document.data()['comparedPrice'] >
                                  allProducts.document.data()['price'])
                                Text(
                                    '\N${allProducts.document.data()['comparedPrice'].toStringAsFixed(00)}',
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: 12))
                            ],
                          ),
                        ]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CounterForCard(allProducts.document),
                          ],
                        ),
                      ),
                    ],
                  )
                ]),
          )
        ]),
      ),
    );
  }
}
