import 'package:ahia/Providers/StoreProvider.dart';
import 'package:ahia/Services/ProductServices.dart';
import 'package:ahia/Widgets/Products/ProductCardWidget.dart';
import 'package:ahia/Widgets/Products/ProductFilterWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _storeProvider = Provider.of<StoreProvider>(context);
    return FutureBuilder<QuerySnapshot>(
      future: _services.product
          .where('published', isEqualTo: true)
          .where('category.mainCategory',
              isEqualTo: _storeProvider.selectedProductCategory)
          .where('category.subCategory',
              isEqualTo: _storeProvider.selectedSubCategory)
          .where('seller.sellerUid',
              isEqualTo: _storeProvider.storeDetails['uid'])
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.docs.isEmpty) {
          return Container();
        }

        return Column(
          children: [
            // ProductFilterWidget(),
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
                        child: Row(
                      children: [
                        snapshot.data.docs.length <= 1
                            ? Text('${snapshot.data.docs.length} Item',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold))
                            : Text('${snapshot.data.docs.length} Items',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    )),
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
