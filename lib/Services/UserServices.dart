import 'package:ahia/Models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  String collection = 'Ahia Users';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

//Create new user
  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collection).doc(id).set(values);
  }

//Update Ahia User Data
  Future<void> updateUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collection).doc(id).update(values);
  }

//get user data by User id

  Future<DocumentSnapshot> getUserById(String id) async {
    var result = await _firestore.collection(collection).doc(id).get();

    return result;
  }

  // Future<DocumentSnapshot> getUserDetails(userUid) async {
  //   DocumentSnapshot snapshot = await ahiaUsers.doc(userUid).get();
  //   return snapshot;
  // }
}
