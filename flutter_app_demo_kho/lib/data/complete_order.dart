// completed_orders.dart

import 'package:flutter_app_demo_kho/model/data/order.dart';

List<Order> completedOrdersData = [
  Order(
      supplierName: 'Hyundai Steel Co., Ltd',
      orderId: 'DH_001',
      entryPerson: 'Nguyễn Văn Dũng',
      vehicleNumber: '51C-00612',
      driverName: 'Trần Bình',
      identification: 'ID-123456',
      dateOfEntry: '2024-04-18',
      status: OrderStatus.completed,
      specification: "2.5 x 1260 Q195",
      Lot: "81",
      rollCode: "171",
      quantity: "1",
      weight: "21,770",
      isCompleted: true),
  Order(
      supplierName: 'Thép Hòa Phát',
      orderId: 'DH_002',
      entryPerson: 'Lê Thị Hoa',
      vehicleNumber: '51K-68600',
      driverName: 'Phạm Đức Đạt',
      identification: 'ID-789012',
      dateOfEntry: '2024-03-12',
      status: OrderStatus.completed,
      specification: "2.5 x 1260 Q195L",
      Lot: "81",
      rollCode: "170",
      quantity: "15",
      weight: "912",
      isCompleted: true),
  // Thêm các đơn hoàn thành khác vào đây...
];
