// all_orders.dart
import 'package:flutter_app_demo_kho/data/complete_order.dart';
import 'package:flutter_app_demo_kho/data/denied_orders.dart';
import 'package:flutter_app_demo_kho/data/incomplete.dart';
import 'package:flutter_app_demo_kho/data/temporary_orders.dart';
import 'package:flutter_app_demo_kho/model/data/order.dart';

final List<Order> allOrdersData = [
  ...completedOrdersData,
  ...incompleteOrdersData,
  ...temporaryOrdersData,
  ...deniedOrdersData,
];
