import 'package:app/screens/feed_screen.dart';
import 'package:app/screens/nofication_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../screens/add_post_screen.dart';
import '../screens/search_screen.dart';

List<Widget> buildScreens() {
  return [
    NotificationScreen(),
    FeedScreen(),
    SearchScreen(),
    AddPostScreen(),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
  ];
}

List<PersistentBottomNavBarItem> navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: Icon(CupertinoIcons.home),
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(CupertinoIcons.search),
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(
        CupertinoIcons.add,
        color: Colors.white,
      ),
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(CupertinoIcons.heart),
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
  ];
}
