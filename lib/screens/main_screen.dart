import 'package:firebase_auth/firebase_auth.dart';
import 'package:hauxe/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:hauxe/screens/first_screen.dart';
import 'package:hauxe/screens/second_screen.dart';
import 'package:hauxe/screens/settings.dart';
import 'package:hauxe/screens/home.dart';
import 'package:hauxe/screens/account.dart';
import 'package:hauxe/screens/chat.dart';
import 'package:hauxe/theme/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key, required User user})
      : _user = user,
        super(key: key);
  final User _user;

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);
    List<Widget> _buildScreens() {
      return [
        const HomePage(),
        const SecondScreen(),
        const FirstScreen(),
        const ChatPage(),
        AccountPage(
          user: _user,
        ),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: ("Home"),
          activeColorPrimary: buttonColor2,
          inactiveColorPrimary: Colors.blue,
          inactiveIcon: const Icon(Icons.home_outlined),
          // inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.search),
          title: ("Search"),
          activeColorPrimary: buttonColor2,
          inactiveColorPrimary: Colors.blue,
          inactiveIcon: const Icon(Icons.search_outlined),
          // inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.favorite),
          title: ("Favoritos"),
          activeColorPrimary: buttonColor2,
          inactiveColorPrimary: Colors.blue,
          inactiveIcon: const Icon(Icons.favorite_border_rounded),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.chat),
          title: ("Chat"),
          activeColorPrimary: buttonColor2,
          inactiveColorPrimary: Colors.blue,
          inactiveIcon: const Icon(Icons.chat_outlined),
          // inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings),
          title: ("Settings"),
          activeColorPrimary: buttonColor2,
          inactiveColorPrimary: Colors.blue,
          inactiveIcon: const Icon(Icons.settings_outlined),
          // inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    }

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: backGroundColor,
      // Default is Colors.white.
      handleAndroidBackButtonPress: true,
      // Default is true.
      resizeToAvoidBottomInset: true,
      // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true,
      // Default is true.
      hideNavigationBarWhenKeyboardShows: true,
      // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: backGroundColor,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: const Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
