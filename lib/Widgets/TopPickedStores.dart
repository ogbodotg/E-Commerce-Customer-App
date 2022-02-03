import 'package:ahia/Auth/WelcomeScreen.dart';
import 'package:ahia/Pages/VendorHomeScreen.dart';
import 'package:ahia/Providers/StoreProvider.dart';
import 'package:ahia/Services/StoreServices.dart';
import 'package:ahia/Services/UserServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class TopPickedStores extends StatelessWidget {
  // UserServices _userServices = UserServices();
  // User user = FirebaseAuth.instance.currentUser;
  // var _userLatitude = 0.0;
  // var _userLongitude = 0.0;

  // get user location and then calculate distance from shops
  // void initState() {
  //   _userServices.getUserById(user.uid).then((result) {
  //     if (user != null) {
  //       setState(() {
  //         _userLatitude = result.data()['latitude'];
  //         _userLongitude = result.data()['longitude'];
  //       });
  //     } else {
  //       Navigator.pushReplacementNamed(context, WelcomeScreen.id);
  //     }
  //   });
  //   super.initState();
  // }

  // String getDistance(location) {
  //   var distance = Geolocator.distanceBetween(
  //       _userLatitude, _userLongitude, location.latitude, location.longitude);
  //   var distanceInKm = distance / 1000;
  //   return distanceInKm.toStringAsFixed(2);
  // }
  // Stream<QuerySnapshot> myStream = FirebaseFirestore.instance
  //     .collection('vendors')
  //     .where('accountVerified', isEqualTo: true)
  //     .where('isTopPicked', isEqualTo: true)
  //     .orderBy('shopName')
  //     .snapshots();

  @override
  Widget build(BuildContext context) {
    StoreServices _storeServices = StoreServices();
    // StoreProvider _storeData = StoreProvider();
    var _storeData = Provider.of<StoreProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStores(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (!snapShot.hasData) return CircularProgressIndicator();
          // List shopsNearBy = [];
          // for (int i = 0; i <= snapShot.data.docs.length; i++) {
          //   var distance = Geolocator.distanceBetween(
          //       _userLatitude,
          //       _userLongitude,
          //       snapShot.data.docs[i]['location'].latitude,
          //       snapShot.data.docs[i]['location'].longitude);
          //   var distanceInKm = distance / 1000;

          //   shopsNearBy.add(distanceInKm);
          // }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
                child: Text('Top Picked Stores',
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              ),
              Flexible(
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        snapShot.data.docs.map((DocumentSnapshot document) {
                      return InkWell(
                        onTap: () {
                          _storeData.getSelectedStore(document);
                          pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: VendorHomeScreen.id),
                            screen: VendorHomeScreen(),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Stack(
                            children: [
                              Container(
                                width: 120,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Card(
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    child: Image.network(
                                                        document['shopImage'],
                                                        fit: BoxFit.cover)),
                                              )),
                                        ],
                                      ),
                                      Container(
                                          child: Text(
                                        document['shopName'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                      Text(
                                          document['shopCity'] +
                                              ' - ' +
                                              document['shopState'],
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          )),
                                      // Text('${getDistance(document['location'])}Km',
                                      //     style: TextStyle(
                                      //       color: Colors.grey,
                                      //       fontSize: 10,
                                      //     ))
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList()),
              )
            ],
          );
        },
      ),
    );
  }
}
