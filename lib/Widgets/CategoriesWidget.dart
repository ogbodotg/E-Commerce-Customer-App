import 'package:ahia/Pages/ProductList.dart';
import 'package:ahia/Widgets/Products/ProductListWidget.dart';
import 'package:ahia/Providers/StoreProvider.dart';
import 'package:ahia/Services/ProductServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class VendorCategories extends StatefulWidget {
  @override
  _VendorCategoriesState createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {
  ProductServices _services = ProductServices();
  List _catList = [];

  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: _store.storeDetails['uid'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  _catList.add(doc['category']['mainCategory']);
                });
              }),
            });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);

    return FutureBuilder(
      future: _services.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong...'));
        }
        if (_catList.length == 0) {
          return Center(
            child: Text(''),
          );
        }
        if (!snapshot.hasData) {
          return Container();
        }
        return SingleChildScrollView(
          child: Column(
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
                        child: Text('Shop by Category',
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
              Wrap(
                direction: Axis.horizontal,
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return _catList.contains(document.data()['categoryName'])
                      ? InkWell(
                          onTap: () {
                            _storeProvider.selectedCategory(
                                document.data()['categoryName']);
                            _storeProvider.selectedCategorySub(null);
                            pushNewScreenWithRouteSettings(
                              context,
                              settings: RouteSettings(name: ProductList.id),
                              screen: ProductList(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 150,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: .3,
                                  )),
                              child: Column(
                                children: [
                                  Center(
                                      child: Image.network(
                                          document.data()['productImage'])),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Text(
                                      document.data()['categoryName'],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Text('');
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
