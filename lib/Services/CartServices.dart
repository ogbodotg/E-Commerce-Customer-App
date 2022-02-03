import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartServices {
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  User user = FirebaseAuth.instance.currentUser;

  Future<void> addToCart(document) {
    cart.doc(user.uid).set({
      'user': user.uid,
      'sellerUid': document.data()['seller']['sellerUid'], // remove this line
      'shopName': document.data()['seller'][
          'shopName'], //remove this line to allow customers order from multiple seller/vendors
    });

    return cart.doc(user.uid).collection('products').add({
      'productId': document.data()['productId'],
      'productName': document.data()['productName'],
      'productImage': document.data()['productImage'],
      'brand': document.data()['brand'],
      'price': document.data()['price'],
      'comparedPrice': document.data()['comparedPrice'],
      'quantity': 1,
      'total': document.data()['price'] // total price for one quantity
      // add the sellerUid line here
      // add the shopName line here
    });
  }

  Future<void> updateCartQty(docId, qty, total) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products')
        .doc(docId);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception("Product is not in your cart!");
          }

          // Perform an update on the document
          transaction.update(documentReference, {
            'quantity': qty,
            'total': total,
          });

          // Return the new count
          return qty;
        })
        .then((value) => print("Cart updated"))
        .catchError((error) => print("Failed to update cart: $error"));
  }

  Future<void> removeFromCart(docId) async {
    cart.doc(user.uid).collection('products').doc(docId).delete();
  }

  Future<void> checkCartData() async {
    final snapshot = await cart.doc(user.uid).collection('products').get();
    if (snapshot.docs.length == 0) {
      cart.doc(user.uid).delete();
    }
  }

  Future<void> deleteCart() async {
    final result =
        await cart.doc(user.uid).collection('products').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<String> checkSeller() async {
    final snapshot = await cart.doc(user.uid).get();
    return snapshot.exists ? snapshot.data()['shopName'] : null;
  }
}
