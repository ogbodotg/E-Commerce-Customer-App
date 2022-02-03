import 'package:ahia/Pages/HomeScreen.dart';
import 'package:ahia/Pages/Map_Screen.dart';
import 'package:ahia/Providers/Location_Provider.dart';
import 'package:ahia/Services/UserServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String smsOtp;
  String verificationId;
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  // LocationProvider locationData = LocationProvider();
  String screen;
  // double latitude;
  // double longitude;
  String address;
  String city;
  String state;
  DocumentSnapshot snapshot;

  Future<void> verifyPhoneNumber({BuildContext context, String number}) async {
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String verId, int resendToken) async {
      this.verificationId = verId;

      //Enter otp dialog
      smsOtpDialog(context, number);
    };
    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String veriId) {
            this.verificationId = veriId;
          });
    } catch (e) {
      this.error = e.toString();
      this.loading = false;
      notifyListeners();
    }
  }

  Future<bool> smsOtpDialog(BuildContext context, String number) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Verification Code'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Enter the 6 digit OTP sent to your phone number',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsOtp);

                    final User user =
                        (await _auth.signInWithCredential(phoneAuthCredential))
                            .user;

                    if (user != null) {
                      this.loading = false;
                      notifyListeners();
                      _userServices.getUserById(user.uid).then((snapshot) {
                        if (snapshot.exists) {
                          if (this.screen == 'Login') {
                            //if user data exists in db, will update
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.id);
                          } else {
                            updateUser(
                              id: user.uid,
                              number: user.phoneNumber,
                            );
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.id);
                          }
                        } else {
                          //create new user
                          _createUser(id: user.uid, number: user.phoneNumber);
                          Navigator.pushReplacementNamed(
                              context, HomeScreen.id);
                        }
                      });
                    } else {
                      print('Login failed');
                    }

                    // if (user != null) {
                    //   print(this.screen);
                    // }
                  } catch (e) {
                    this.error = 'Invalid OTP';
                    notifyListeners();
                    print(e.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Done',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              )
            ],
          );
        }).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  void _createUser({String id, String number}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'address': this.address,
      // 'latitude': this.latitude,
      // 'longitude': this.longitude,
    });
    this.loading = false;
    notifyListeners();
  }

  Future<bool> updateUser({String id, String number}) async {
    try {
      _userServices.updateUserData({
        'id': id,
        'number': number,
        'address': this.address,
        // 'latitude': this.latitude,
        // 'longitude': this.longitude,
      });
      this.loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
      print('Error $e');
    }
  }

  Future<bool> updateDeliveryLocation(
      {String id,
      String number,
      String address,
      String city,
      String state}) async {
    try {
      _userServices.updateUserData({
        'id': id,
        'number': number,
        'address': address,
        'city': city,
        'state': state,
      });
      this.loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
      print('Error $e');
    }
  }

  getUserDetails() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('Ahia Users')
        .doc(_auth.currentUser.uid)
        .get();
    if (result != null) {
      this.snapshot = result;
      notifyListeners();
    } else {
      this.snapshot = null;
      notifyListeners();
    }
    return result;
  }
}
