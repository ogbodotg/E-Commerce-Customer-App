import 'package:ahia/Pages/FavouriteScreen.dart';
import 'package:ahia/Pages/HomeScreen.dart';
import 'package:ahia/Pages/OrdersScreen.dart';
import 'package:ahia/Pages/ProfileScreen.dart';
import 'package:ahia/Widgets/Cart/CartNotification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainScreen extends StatelessWidget {
  static const String id = 'main-screen';
  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);

    List<Widget> _buildScreens() {
      return [HomeScreen(), FavouriteScreen(), MyOrders(), ProfileScreen()];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          title: ("Home"),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.square_favorites_alt),
          title: ("Favourites"),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.bag),
          title: ("My Orders"),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          title: ("Profile"),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: CupertinoColors.systemGrey,
        ),
      ];
    }

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: CartNotification(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears.
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
        decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0.0),
            colorBehindNavBar: Colors.white,
            border: Border.all(color: Colors.black45)),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style6, // Choose the nav bar style with this property.
      ),
    );
  }
}
