import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  CollectionReference vendorBanner =
      FirebaseFirestore.instance.collection('vendorBanner');
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');

  //get only admin verified sellers
  getStores() {
    return vendors
        .where('accountVerified', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }

  getStoresPagination() {
    return vendors
        .where('accountVerified', isEqualTo: true)
        .orderBy('shopName');
  }

  getTopPickedStores() {
    return vendors
        .where('accountVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }

  Future<DocumentSnapshot> getShopDetails(sellerUid) async {
    DocumentSnapshot snapshot = await vendors.doc(sellerUid).get();
    return snapshot;
  }
}
