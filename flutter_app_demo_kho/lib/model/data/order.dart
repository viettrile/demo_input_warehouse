// order_model.dart
enum OrderStatus {
  completed,
  temporaryEntry,
  awaitingEntry,
  rejected,
}

String getStatusDescription(OrderStatus status) {
  switch (status) {
    case OrderStatus.completed:
      return 'Hoàn thành';
    case OrderStatus.temporaryEntry:
      return 'Nhập tạm';
    case OrderStatus.awaitingEntry:
      return 'Chờ nhập kho';
    case OrderStatus.rejected:
      return 'Từ chối';
    default:
      return 'Không xác định';
  }
}

String orderStatusToString(OrderStatus status) {
  return status.toString().split('.').last;
}

class Order {
  final String supplierName;
  final String orderId;
  final String entryPerson;
  String vehicleNumber;
  String driverName;
  String identification;
  final String dateOfEntry;
  OrderStatus status;
  bool isCompleted;
  String statusStr;
  String reason;
  String specification;
  String Lot;
  String rollCode;
  String quantity;
  String weight;

  Order({
    required this.supplierName,
    required this.orderId,
    required this.entryPerson,
    required this.vehicleNumber,
    required this.driverName,
    required this.identification,
    required this.dateOfEntry,
    this.status = OrderStatus.completed,
    this.statusStr = "",
    this.isCompleted = false,
    this.reason = "",
    this.specification = "",
    this.Lot = "",
    this.rollCode = "",
    this.quantity = "",
    this.weight = "",
  });
  String getStatusValue() {
    return orderStatusToString(this.status);
  }

  String getStatusString() {
    return getStatusDescription(status);
  }
}
