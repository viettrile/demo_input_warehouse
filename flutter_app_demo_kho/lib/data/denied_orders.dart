import 'package:flutter_app_demo_kho/model/data/order.dart';

List<Order> deniedOrdersData = [
  Order(
    supplierName: 'Hyundai Steel Co., Ltd',
    orderId: 'DH_011',
    entryPerson: 'Nguyễn Văn Tấn',
    vehicleNumber: '51C-00612',
    driverName: 'Trần Bình',
    identification: 'ID-123456',
    dateOfEntry: '2024-04-13',
    status: OrderStatus.rejected,
    specification: "2.5 x 1260 Q195",
    Lot: "81",
    rollCode: "171",
    quantity: "7",
    weight: "5,112.0",
  ),
  Order(
    supplierName: 'Thép Hòa Phát',
    orderId: 'DH_012',
    entryPerson: 'Lê Thị Huệ',
    vehicleNumber: '51K-68600',
    driverName: 'Phạm Đức Đạt',
    identification: 'ID-789012',
    dateOfEntry: '2024-04-11',
    status: OrderStatus.rejected,
    specification: "19.8 x 1500 Q235",
    Lot: "91",
    rollCode: "84",
    quantity: "1",
    weight: "13,680",
  ),
  // Thêm các đơn hoàn thành khác vào đây...
];
