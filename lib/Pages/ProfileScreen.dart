import 'package:ahia/Auth/WelcomeScreen.dart';
import 'package:ahia/Pages/HomeScreen.dart';
import 'package:ahia/Pages/ProfileUpdate.dart';
import 'package:ahia/Pages/SetDeliveryAddress.dart';
import 'package:ahia/Providers/Auth_Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<AuthProvider>(context);
    userDetails.getUserDetails();
    User user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('Ahia', style: TextStyle(color: Colors.white)),
        // leading: IconButton(
        //     icon: Icon(
        //       Icons.arrow_back,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       pushNewScreenWithRouteSettings(
        //         context,
        //         settings: RouteSettings(name: HomeScreen.id),
        //         screen: HomeScreen(),
        //         withNavBar: true,
        //         pageTransitionAnimation: PageTransitionAnimation.cupertino,
        //       );
        //     }),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('My Account',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Stack(
              children: [
                Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              child: Text('O',
                                  style: TextStyle(
                                      fontSize: 50, color: Colors.white)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      userDetails.snapshot.data() != null
                                          ? '${userDetails.snapshot.data()['firstName']} ${userDetails.snapshot.data()['lastName']}'
                                          : 'Update Your Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white)),
                                  if (userDetails.snapshot.data()['email'] !=
                                      null)
                                    Text(
                                        '${userDetails.snapshot.data()['email']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white)),
                                  Text(user.phoneNumber,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (userDetails.snapshot != null)
                          ListTile(
                            tileColor: Colors.white,
                            leading: Icon(Icons.location_on,
                                color: Theme.of(context).primaryColor),
                            title: Text(userDetails.snapshot.data()['address'],
                                maxLines: 1),
                            subtitle: Text(userDetails.snapshot.data()['city'] +
                                ' - ' +
                                userDetails.snapshot.data()['state']),
                            trailing: OutlineButton(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text('Change Address',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor)),
                              onPressed: () {
                                // Navigator.pushNamed(context, SetDeliveryLocation.id);
                                pushNewScreenWithRouteSettings(
                                  context,
                                  settings: RouteSettings(
                                      name: SetDeliveryLocation.id),
                                  screen: SetDeliveryLocation(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    right: 10.0,
                    // top: 10.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(name: UpdateProfile.id),
                          screen: UpdateProfile(),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                    )),
              ],
            ),
            ListTile(leading: Icon(Icons.history), title: Text('My Orders')),
            Divider(),
            ListTile(
                leading: Icon(Icons.comment_outlined),
                title: Text('My Ratings & Review')),
            Divider(),
            ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications')),
            Divider(),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Log Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: WelcomeScreen.id),
                  screen: WelcomeScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
