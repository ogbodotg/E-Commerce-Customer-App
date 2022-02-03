import 'package:ahia/Auth/WelcomeScreen.dart';
import 'package:ahia/Models/ProductModel.dart';
import 'package:ahia/Pages/Map_Screen.dart';
import 'package:ahia/Pages/SetDeliveryAddress.dart';
import 'package:ahia/Providers/Location_Provider.dart';
import 'package:ahia/Widgets/Products/AllProductSearch.dart';
import 'package:ahia/Widgets/Products/SearchCardWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  static List<AllProduct> allProducts = [];
  String offer;
  String shopName;
  DocumentSnapshot document;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          document = doc;
          offer = ((doc.data()['comparedPrice'] - doc.data()['price']) /
                  (doc.data()['comparedPrice']) *
                  100)
              .toStringAsFixed(00);
          allProducts.add(AllProduct(
            brand: doc['brand'],
            price: doc['price'],
            category: doc['category']['mainCategory'],
            image: doc['productImage'],
            productName: doc['productName'],
            document: doc,
          ));
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    allProducts.clear();
    super.dispose();
  }
  // String _location = '';
  // String _address = '';

  // @override
  // void initState() {
  //   getPrefs();
  //   super.initState();
  // }

  // getPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // String location = prefs.getString('location');
  //   String address = prefs.getString('address');

  //   setState(() {
  //     // _location = location;
  //     _address = address;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final locationData = Provider.of<LocationProvider>(context);
    // return AppBar ( non-scrollable App Bar
    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      floating: true,
      snap: true,
      title: Text('Ahia',
          style: TextStyle(
            fontFamily: 'Signatra',
            color: Colors.white,
            fontSize: 40,
            // fontWeight: FontWeight.bold,
          )),
      // leading: Container(),
      // title: FlatButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, SetDeliveryLocation.id);
      //     // locationData.getCurrentPosition();
      //     // if (locationData.permissionAllowed == true) {
      //     //   Navigator.pushNamed(context, MapScreen.id);
      //     // } else {
      //     //   print('Permission not allowed');
      //     // }
      //   },
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     // mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       // Row(
      //       //   children: [
      //       //     Flexible(
      //       //       child: Text(
      //       //         _address == null
      //       //             ? 'Delivery address not set'
      //       //             : 'DELIVERY ADDRESS: ${_address}',
      //       //         style: TextStyle(
      //       //             color: Colors.white, fontWeight: FontWeight.bold),
      //       //         overflow: TextOverflow.ellipsis,
      //       //       ),
      //       //     ),
      //       //     // IconButton(
      //       //     //     onPressed: () {},
      //       //     //     icon: Icon(Icons.edit_outlined),
      //       //     //     color: Colors.white),
      //       //     Icon(
      //       //       Icons.edit_outlined,
      //       //       color: Colors.white,
      //       //       size: 15,
      //       //     )
      //       //   ],
      //       // ),
      //       Flexible(
      //           child: Text(
      //         _address,
      //         overflow: TextOverflow.ellipsis,
      //         style: TextStyle(color: Colors.white, fontSize: 12),
      //       )),
      //     ],
      //   ),
      // ),
      actions: [
        // IconButton(
        //   icon: Icon(Icons.power_settings_new, color: Colors.white),
        //   onPressed: () {
        //     FirebaseAuth.instance.signOut();
        //     Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        //   },
        // ),
        IconButton(
          icon: Icon(Icons.search, color: Colors.white, size: 30),
          onPressed: () {
            showSearch(
                context: context,
                delegate: SearchPage<AllProduct>(
                  onQueryUpdate: (s) => print(s),
                  items: allProducts,
                  searchLabel: 'Search product',
                  suggestion: Center(
                    child: Text(
                      'Filter product by category, name or price',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  failure: Center(
                    child: Text('No product found :(',
                        style: TextStyle(fontSize: 20)),
                  ),
                  filter: (products) => [
                    products.productName,
                    products.category,
                    products.brand,
                    products.price.toString(),
                  ],
                  builder: (allProducts) => AllProductSearch(
                    offer: offer,
                    allProducts: allProducts,
                    document: allProducts.document,
                  ),
                ));
          },
        ),
      ],
      centerTitle: true,
      // bottom: PreferredSize(
      //     preferredSize: Size.fromHeight(56),
      //     child: Padding(
      //       padding: const EdgeInsets.all(10.0),
      //       child: TextField(
      //         decoration: InputDecoration(
      //             hintText: 'Search',
      //             prefixIcon:
      //             border: OutlineInputBorder(
      //                 borderRadius: BorderRadius.circular(10),
      //                 borderSide: BorderSide.none),
      //             contentPadding: EdgeInsets.zero,
      //             filled: true,
      //             fillColor: Colors.white),
      //       ),
      //     ))
    );
  }
}
