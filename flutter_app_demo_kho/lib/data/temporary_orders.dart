// completed_orders.dart

import 'package:flutter_app_demo_kho/model/data/order.dart';

List<Order> temporaryOrdersData = [
  Order(
    supplierName: 'Hyundai Steel Co., Ltd',
    orderId: 'DH_007',
    entryPerson: 'Nguyễn Văn Dũng',
    vehicleNumber: '51C-00612',
    driverName: 'Trần Bình',
    identification: 'ID-123456',
    dateOfEntry: '2024-04-11',
    status: OrderStatus.temporaryEntry,
    specification: "2.5 x 1260 Q195L",
    Lot: "81",
    rollCode: "170",
    quantity: "15",
    weight: "912",
  ),
  Order(
    supplierName: 'Thép Hòa Phát',
    orderId: 'DH_008',
    entryPerson: 'Lê Thị Hoa',
    vehicleNumber: '51K-68600',
    driverName: 'Phạm Đức Đạt',
    identification: 'ID-789012',
    dateOfEntry: '2024-04-12',
    status: OrderStatus.temporaryEntry,
    specification: "2.5 x 1260 Q195L",
    Lot: "81",
    rollCode: "170",
    quantity: "15",
    weight: "912",
  ),
  // Thêm các đơn hoàn thành khác vào đây...
];
