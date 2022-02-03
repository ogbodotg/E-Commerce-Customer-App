import 'dart:async';
import 'package:ahia/Auth/LoginScreen.dart';
import 'package:ahia/Pages/CartPage.dart';
import 'package:ahia/Pages/MainScreen.dart';
import 'package:ahia/Pages/Map_Screen.dart';
import 'package:ahia/Pages/ProductDetails.dart';
import 'package:ahia/Pages/ProductList.dart';
import 'package:ahia/Pages/ProfileScreen.dart';
import 'package:ahia/Pages/ProfileUpdate.dart';
import 'package:ahia/Providers/CartProvider.dart';
import 'package:ahia/Providers/CouponProvider.dart';
import 'package:ahia/Providers/OrderProvider.dart';
import 'package:ahia/Providers/ProductProvider.dart';
import 'package:ahia/Services/OnlinePayment.dart';
import 'package:ahia/Widgets/Products/ProductListWidget.dart';
import 'package:ahia/Pages/SetDeliveryAddress.dart';
import 'package:ahia/Pages/VendorHomeScreen.dart';
import 'package:ahia/Providers/Location_Provider.dart';
import 'package:ahia/Providers/StoreProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:ahia/Auth/OnBoardScreen.dart';
import 'package:ahia/Auth/RegisterScreen.dart';
import 'package:ahia/Auth/WelcomeScreen.dart';
import 'package:ahia/Pages/HomeScreen.dart';
import 'package:ahia/Pages/SplashScreen.dart';
import 'package:ahia/Providers/Auth_Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => LocationProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => StoreProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => CouponProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => OrderProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(primaryColor: Colors.green, fontFamily: 'Lato'),

      theme: ThemeData(primaryColor: Color(0xFF84c225), fontFamily: 'Lato'),
      debugShowCheckedModeBanner: false,
      // home: SplashScreen(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        MapScreen.id: (context) => MapScreen(),
        SetDeliveryLocation.id: (context) => SetDeliveryLocation(),
        LoginScreen.id: (context) => LoginScreen(),
        MainScreen.id: (context) => MainScreen(),
        VendorHomeScreen.id: (context) => VendorHomeScreen(),
        ProductList.id: (context) => ProductList(),
        ProductDetails.id: (context) => ProductDetails(),
        CartPage.id: (context) => CartPage(),
        ProfileScreen.id: (context) => ProfileScreen(),
        UpdateProfile.id: (context) => UpdateProfile(),
        OnlinePayment.id: (context) => OnlinePayment(),
      },
      builder: EasyLoading.init(),
    );
  }
}
