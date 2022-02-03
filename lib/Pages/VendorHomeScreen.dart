import 'package:ahia/Providers/StoreProvider.dart';
import 'package:ahia/Widgets/CategoriesWidget.dart';
import 'package:ahia/Widgets/ImageSlider.dart';
import 'package:ahia/Widgets/Products/BestSellingProduct.dart';
import 'package:ahia/Widgets/Products/FeaturedProducts.dart';
import 'package:ahia/Widgets/Products/RecentlyAddedProducts.dart';
import 'package:ahia/Widgets/VendorAppBar.dart';
import 'package:ahia/Widgets/VendorBanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String id = 'vendor-home-screen';
  @override
  Widget build(BuildContext context) {
    // StoreProvider _storeData = StoreProvider();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            VendorAppBar(),
          ];
        },
        body: ListView(
          shrinkWrap: true,
          children: [
            VendorBanner(),
            VendorCategories(),
            RecentlyAddedProducts(),
            FeaturedProducts(),
            BestSellingProducts(),
          ],
        ),
      ),
    );
  }
}
