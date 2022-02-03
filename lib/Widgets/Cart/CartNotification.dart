import 'package:ahia/Pages/CartPage.dart';
import 'package:ahia/Providers/CartProvider.dart';
import 'package:ahia/Services/CartServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CartNotification extends StatefulWidget {
  @override
  _CartNotificationState createState() => _CartNotificationState();
}

class _CartNotificationState extends State<CartNotification> {
  // CartServices _cart = CartServices();
  // DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getCartTotal();
    _cartProvider.getShopName();

    // _cart.getShopName().then((value) {
    //   setState(() {
    //     document = value;
    //   });
    // });

    return Visibility(
      visible: _cartProvider.cartQty > 0 ? true : false,
      child: Container(
        height: 30,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        // color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${_cartProvider.cartQty}${_cartProvider.cartQty == 1 ? ' item in cart' : ' items in cart'}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(' | ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        Text(
                          'Sub-Total: NGN${_cartProvider.subTotal.toStringAsFixed(0)}',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    // if (_cartProvider.cartQty > 0)
                    //   // if (document.exists)
                    //   Text(
                    //     'From ${document.data()['shopName']}',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: CartPage.id),
                    screen: CartPage(
                      document: _cartProvider.document,
                    ),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Container(
                    child: Row(children: [
                  Text('View Cart',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(width: 5),
                  Icon(CupertinoIcons.cart_fill, color: Colors.red)
                ])),
              )
            ],
          ),
        ),
      ),
    );
  }
}
