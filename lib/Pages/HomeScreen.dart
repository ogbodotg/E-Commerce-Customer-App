import 'package:ahia/Auth/WelcomeScreen.dart';
import 'package:ahia/Pages/Map_Screen.dart';
import 'package:ahia/Providers/Auth_Provider.dart';
import 'package:ahia/Providers/Location_Provider.dart';
import 'package:ahia/Widgets/AppBar.dart';
import 'package:ahia/Widgets/ImageSlider.dart';
import 'package:ahia/Widgets/NearByStores.dart';
import 'package:ahia/Widgets/TopPickedStores.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // String _location = '';

  // @override
  // void initState() {
  //   getPrefs();
  //   super.initState();
  // }

  // getPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String location = prefs.getString('location');

  //   setState(() {
  //     _location = location;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<AuthProvider>(context);
    // final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      // backgroundColor: Colors.green[200],

      //non scrollable app bar
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(112),
      //   child: MyAppBar(),
      // ),

      // scrollable appbar
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [MyAppBar()];
        },
        //homepage body
        body: ListView(
          children: [
            ImageSlider(),
            Container(
                height: 190,
                color: Colors.green[100],
                child: Expanded(child: TopPickedStores())),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: NearByStores(),
            ),
          ],
        ),
      ),
    );
  }
}
