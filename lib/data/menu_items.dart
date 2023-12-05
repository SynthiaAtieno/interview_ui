import 'package:interview/model/menuItem.dart';
import 'package:flutter/material.dart';

class MenuItems {
  static const List<MenuItem> items = [
    itemEditProfile,
    itemSignOut,
  ];

  static const itemSignOut = MenuItem(text: 'SignOut', iconData: Icons.logout);
  static const itemEditProfile = MenuItem(text: 'Edit', iconData: Icons.person);
}
