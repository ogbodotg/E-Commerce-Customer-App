import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SaveForLater extends StatelessWidget {
  final DocumentSnapshot document;

  SaveForLater(this.document);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        EasyLoading.show(status: 'Adding to Wish List');
        addToFavourite().then((value) {
          EasyLoading.showSuccess('Added successfully');
        });
      },
      child: Container(
        height: 80,
        color: Colors.red,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.bookmark, color: Colors.white),
                SizedBox(width: 10),
                Text('Add to Wish List',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addToFavourite() {
    CollectionReference _favourite =
        FirebaseFirestore.instance.collection('favourites');
    User user = FirebaseAuth.instance.currentUser;
    return _favourite.add({
      'product': document.data(),
      'customerId': user.uid,
    });
  }
}
