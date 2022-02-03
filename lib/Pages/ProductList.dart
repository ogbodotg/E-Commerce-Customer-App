import 'package:ahia/Providers/StoreProvider.dart';
import 'package:ahia/Widgets/Products/ProductFilterWidget.dart';
import 'package:ahia/Widgets/Products/ProductListWidget.dart';
import 'package:ahia/Widgets/VendorAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  static const String id = 'product-list';
  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(_storeProvider.selectedProductCategory,
                style: TextStyle(color: Colors.white)),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            expandedHeight: 110,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(top: 88),
              child: Container(
                height: 56,
                color: Colors.grey,
                child: ProductFilterWidget(),
              ),
            ),
          ),
        ];
      },
      body: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          ProductListWidget(),
        ],
      ),
    ));
  }
}
