import 'package:flutter/material.dart';
import 'package:flutter_app_demo_kho/screens/home/menu.dart';
import 'package:flutter_app_demo_kho/screens/input/ct_phieunhapkho.dart';
import 'package:flutter_app_demo_kho/screens/input/nhapkho.dart';

import '../model/data/order.dart';

class Routes {
  //menu
  static const String menu = "/menu";

  //Phieu nhap
  static const String inputInventory = "/inputInventory";

  //Chi tiet phieu nhap
  static const String detail_inputInventory = "/detail_inputInventory";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case inputInventory:
        return MaterialPageRoute(
          builder: (context) {
            return InventoryInScreen();
          },
          fullscreenDialog: false,
        );
      case menu:
        return MaterialPageRoute(
          builder: (context) {
            return MainMenuScreen();
          },
          fullscreenDialog: false,
        );
      case detail_inputInventory:
        final Order order = settings.arguments as Order;
        return MaterialPageRoute(
          builder: (context) {
            return OrdersDetailScreen(order: order);
          },
          fullscreenDialog: false,
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Not Found'),
              ),
              body: Center(
                child: Text('No path for ${settings.name}'),
              ),
            );
          },
        );
    }
  }

  static final Routes _instance = Routes._internal();

  factory Routes() {
    return _instance;
  }

  Routes._internal();
}
