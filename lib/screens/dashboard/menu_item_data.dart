import 'package:flutter/material.dart';
import 'package:mpsc_demo/screens/dashboard/menu_item.dart';

class MenuItemData {
  static const itemRemove = const MenuItem('Remove', Icons.favorite);
  static const itemOpen = const MenuItem('Open', Icons.open_in_browser);
  static const List<MenuItem> itemsFirst = [itemRemove, itemOpen];
}
