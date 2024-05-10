import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_demo_kho/configs/config.dart';
import 'package:flutter_app_demo_kho/data/complete_order.dart';
import 'package:flutter_app_demo_kho/data/denied_orders.dart';
import 'package:flutter_app_demo_kho/data/incomplete.dart';
import 'package:flutter_app_demo_kho/data/temporary_orders.dart';
import 'package:flutter_app_demo_kho/model/data/order.dart';
import 'package:flutter_app_demo_kho/widget/app_button.dart';
import 'package:flutter_app_demo_kho/widget/app_icon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OrdersDetailScreen extends StatefulWidget {
  final Order order;

  OrdersDetailScreen({super.key, required this.order});

  @override
  _OrdersDetailScreenState createState() => _OrdersDetailScreenState();
}
class _OrdersDetailScreenState extends State<OrdersDetailScreen> {
  TextEditingController idNumberController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController nameDriverController = TextEditingController();

  FocusNode _vehicleNumberFocus = FocusNode();
  FocusNode _idNumberFocus = FocusNode();
  FocusNode _nameDriverFocus = FocusNode();

  bool _isFocused1 = false;
  bool _isFocused2 = false;
  bool _isFocused3 = false;

  late Order order;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _nameDriverFocus = FocusNode();
    _vehicleNumberFocus = FocusNode();
    vehicleNumberController.addListener(_onFocusChange);
    idNumberController.addListener(_onFocusChange);
    nameDriverController.addListener(_onFocusChange);
    _idNumberFocus = FocusNode();
    _idNumberFocus.addListener(() {
      setState(() {
        _isFocused1 = _idNumberFocus.hasFocus;
      });
    });
    _nameDriverFocus.addListener(() {
      setState(() {
        _isFocused3 = _nameDriverFocus.hasFocus;
      });
    });
    _vehicleNumberFocus.addListener(() {
      setState(() {
        _isFocused2 = _vehicleNumberFocus.hasFocus;
      });
    });
    // Lấy dữ liệu Order từ widget.order
    order = widget.order;
    // if (order.isCompleted) {
    nameDriverController.text = order.driverName;
    vehicleNumberController.text = order.vehicleNumber;
    idNumberController.text = order.identification;
    // }
    // updateField(widget.order);
  }

  @override
  void dispose() {
    super.dispose();
    idNumberController.removeListener(_onFocusChange);
    idNumberController.dispose();
    vehicleNumberController.removeListener(_onFocusChange);
    vehicleNumberController.dispose();
    _vehicleNumberFocus.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void updateField(Order order) {
    // Trạng thái mà khi đó chúng ta sẽ cập nhật controller với vehicle number từ order
    if (order.status == OrderStatus.awaitingEntry ||
        order.status == OrderStatus.temporaryEntry) {
      vehicleNumberController.text = order.vehicleNumber;
      nameDriverController.text = order.driverName;
      idNumberController.text = order.identification;
    }
  }

  String? rejectionReason;
  Future<void> _showRejectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Nhập lý do từ chối',
          ),
          contentPadding:
              EdgeInsets.only(top: 50, bottom: 60, left: 12, right: 12),
          content: Container(
            height: 100,
            child: TextField(
              onChanged: (value) {
                rejectionReason = value;
              },
              maxLines: 1,
              textAlignVertical: TextAlignVertical.bottom,
              // textDirection: TextDecoration.overline,
              decoration: InputDecoration(hintText: 'Nhập lý do tại đây...!'),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(
                  () {
                    order.reason = rejectionReason!;
                    order.status = OrderStatus.rejected;
                    print('Lý do là ${order.reason}');
                  },
                );

                Fluttertoast.showToast(
                    msg: "Đã lưu lý do",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: lightColorScheme.primary,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.pop(context);
              },
              child: Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRejectionReason(BuildContext context) async {
    if (order.reason != "") {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lý do từ chối'),
            content: Text(order.reason),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Đóng'),
              ),
            ],
          );
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "Không có lý do nào được lưu",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: lightColorScheme.error,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    print(order.reason);
  }

  File? _imageFile;
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _processImage_vehicleNumber();
      // _processImageID();
    }
  }

  Future<void> _pickImageID() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _processImageID();
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> _processImage_vehicleNumber() async {
    final inputImage = InputImage.fromFilePath(_imageFile!.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    print(recognizedText.text);
    // Biến đổi nhiều dòng thành một dòng và thay thế các dấu phẩy giữa các số bằng dấu chấm
    String extractedText = recognizedText.text
        .trim()
        .replaceAll('\n', ' ')
        .replaceAllMapped(RegExp(r'(\d{2}),(\d{2})'),
            (match) => '${match.group(1)}.${match.group(2)}');
    print(extractedText);
    // Loại bỏ ký tự trắng thừa
    extractedText = extractedText.replaceAll(RegExp(r'\s+'), ' ');
    print("biển số sau khi loại khoảng trắng: $extractedText");
    // Regex tìm biển số xe
    RegExp licensePlateRegex = RegExp(r'\b\d{2}[A-Z]-\d{3}[.,]\d{2}\b');
    Iterable<RegExpMatch> matches = licensePlateRegex.allMatches(extractedText);
    String vehicleNumber = matches.isNotEmpty
        ? matches.first.group(0)?.replaceAll(',', '.') ?? ""
        : "null";
    vehicleNumberController.text = vehicleNumber;
    print(vehicleNumber.isNotEmpty
        ? "Biển số xe được tìm thấy: $vehicleNumber"
        : "Không tìm thấy biển số xe phù hợp");
  }

  Future<void> _processImageID() async {
    final inputImageID = InputImage.fromFilePath(_imageFile!.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImageID);
    print(recognizedText.text);
    final idRegExp = RegExp(
        r'(số/ no:|số no:|số:|no:|sối no:|số i no.|số | no| no.:|no|số:|so |số i no.: |sóI No|só I NO:)\s*(\d+)',
        caseSensitive: false);
    final idMatches = idRegExp.allMatches(recognizedText.text);
    // final nameMatches = nameRegExp.allMatches(recognizedText.text);
    // Xử lý ID
    for (final match1 in idMatches) {
      final matchedText = match1.group(2);
      if (matchedText != null && matchedText.isNotEmpty) {
        print('Found ID: $matchedText');
        idNumberController.text = matchedText;
        break;
      }
      if (idNumberController.text.isEmpty) {
        print('ID not found');
      }
    }
  }

  Future<void> _processNameID() async {
    final inputImageID = InputImage.fromFilePath(_imageFile!.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImageID);
    print(recognizedText.text);
    final nameRegExp = RegExp(
      r'(Họ và tên / Full name:|Họ và tên I Full name:|Họ và tên/Full name:)\s*([A-ZẮẰẴẲÂẤẦẪẨÉÈẼẸÊẾỀỂỆÍÌỈĨÓÒỌÕÔỐỒỜỘỔƠỚỜỢỞỦÚÙỤŨƯỨỪỰỬỮÝỲỴỶỸĐ\s]+)',
      caseSensitive: false,
    );
    final nameMatches = nameRegExp.allMatches(recognizedText.text);
    if (nameMatches.isNotEmpty) {
      final matchedText = nameMatches.first.group(2)?.trim();
      if (matchedText != null && matchedText.isNotEmpty) {
        print('Found name: $matchedText');
        nameDriverController.text = matchedText;
      }
    } else {
      print("Name not found");
    }
  }

  bool isButtonEnabled() {
    return idNumberController.text.isNotEmpty &&
        vehicleNumberController.text.isNotEmpty &&
        nameDriverController.text.isNotEmpty;
  }

  void onCompleted() {
    if (isButtonEnabled()) {
      // Kiểm tra xem cả hai trường đều không trống
      order.identification = idNumberController.text;
      order.vehicleNumber = vehicleNumberController.text;
      order.driverName = nameDriverController.text;
      order.isCompleted = true;
      order.status = OrderStatus.completed;

      setState(() {
        completedOrdersData.add(order);
        incompleteOrdersData.remove(order);
        temporaryOrdersData.remove(order);
      });
      Navigator.pop(context, order);
    }
  }

  void onTemporary() {
    if (isButtonEnabled()) {
      // Kiểm tra xem cả hai trường đều không trống
      order.identification = idNumberController.text;
      order.vehicleNumber = vehicleNumberController.text;
      order.driverName = nameDriverController.text;
      order.isCompleted = true;
      order.statusStr = order.getStatusValue();
      setState(() {
        temporaryOrdersData.add(order);
        incompleteOrdersData.remove(order);
      });
      Navigator.pop(context, order);
    } else {}
  }

  Widget buildOrderButtons(Order order) {
    Size size = MediaQuery.of(context).size;
    switch (order.status) {
      case OrderStatus.completed:
        // Đơn hàng đã hoàn thành, không hiển thị nút nào
        return Container();
      case OrderStatus.temporaryEntry:
        // Đơn hàng nhập tạm, hiển thị nút "Hoàn thành" và "Từ chối"
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: isButtonEnabled()
                  ? () {
                      onCompleted();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: lightColorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize:
                    Size(size.width * 0.3, 44), // Kích thước tối thiểu cho nút
                padding: EdgeInsets.symmetric(vertical: 12), // Padding cho nút
              ),
              child: Text(
                "Hoàn Thành",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: size.width * 0.2),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: lightColorScheme.onError,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize:
                    Size(size.width * 0.3, 44), // Kích thước tối thiểu cho nút
                padding: EdgeInsets.symmetric(vertical: 12), // Padding cho nút
              ),
              child: Text(
                "Từ chối",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await _showRejectionDialog(context);
                deniedOrdersData.add(order);
                incompleteOrdersData.remove(order);
                temporaryOrdersData.remove(order);
                Navigator.pop(context);
              },
            ),
          ],
        );
      case OrderStatus.awaitingEntry:
        // Đơn hàng chờ nhập kho, hiển thị tất cả 3 nút
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: isButtonEnabled()
                  ? () {
                      onTemporary();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: lightColorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize:
                    Size(size.width * 0.25, 44), // Kích thước tối thiểu cho nút
                padding: EdgeInsets.symmetric(vertical: 12), // Padding cho nút
              ),
              child: Text(
                "Nhập tạm",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: size.width * 0.06),
            ElevatedButton(
              onPressed: isButtonEnabled()
                  ? () {
                      onCompleted();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: lightColorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize:
                    Size(size.width * 0.25, 44), // Kích thước tối thiểu cho nút
                padding: EdgeInsets.symmetric(vertical: 12), // Padding cho nút
              ),
              child: Text(
                "Hoàn Thành",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: size.width * 0.06),
            ElevatedButton(
              onPressed: isButtonEnabled()
                  ? () async {
                      await _showRejectionDialog(context);
                      deniedOrdersData.add(order);
                      incompleteOrdersData.remove(order);
                      temporaryOrdersData.remove(order);
                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: lightColorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize:
                    Size(size.width * 0.25, 44), // Kích thước tối thiểu cho nút
                padding: EdgeInsets.symmetric(vertical: 12), // Padding cho nút
              ),
              child: Text(
                "Từ chối",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      case OrderStatus.rejected:
        // Đơn hàng bị từ chối, chỉ hiển thị nút "Xem lý do từ chối"
        return AppButton(
          'Xem lý do từ chối',
          onPressed: () {
            _showRejectionReason(context);
          },
        );
      default:
        // Trường hợp không xác định, không hiển thị nút nào
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết phiếu nhập kho'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12),
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      "assets/icons/supplier.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                enabled: false,
                labelText: 'Tên nhà cung cấp',
                labelStyle: TextStyle(
                  color: lightColorScheme.onSurfaceVariant,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(cornerNormal),
                  borderSide: BorderSide(
                    color: lightColorScheme.onSurfaceVariant
                        .withOpacity(0.5), // Màu nhạt với độ mờ 50%
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
              style: TextStyle(fontSize: 16.0, color: lightColorScheme.scrim),
              initialValue: order.supplierName,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12),
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      "assets/icons/order_code.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                enabled: false,
                labelText: 'Mã đơn hàng',
                labelStyle: TextStyle(
                  color: lightColorScheme.onSurfaceVariant,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(cornerNormal),
                  borderSide: BorderSide(
                    color: lightColorScheme.onSurfaceVariant
                        .withOpacity(0.5), // Màu nhạt với độ mờ 50%
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
              style: TextStyle(fontSize: 16.0, color: lightColorScheme.scrim),
              initialValue: order.orderId,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12),
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      "assets/icons/person_edit.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                enabled: false,
                labelText: 'Người nhập hàng',
                labelStyle: TextStyle(
                  color: lightColorScheme.onSurfaceVariant,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(cornerNormal),
                  borderSide: BorderSide(
                    color: lightColorScheme.onSurfaceVariant
                        .withOpacity(0.5), // Màu nhạt với độ mờ 50%
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
              style: TextStyle(fontSize: 16.0, color: lightColorScheme.scrim),
              initialValue: order.entryPerson,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: nameDriverController,
              focusNode: _nameDriverFocus,
              enabled: order.status == OrderStatus.rejected ||
                      order.status == OrderStatus.completed
                  ? false
                  : true,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      "assets/icons/driver.png",
                      fit: BoxFit.contain,
                      color: _isFocused3
                          ? lightColorScheme.primary
                          : lightColorScheme.onSurfaceVariant,
                      width: 14,
                      height: 14,
                    ),
                  ),
                ),
                suffixIcon: order.status == OrderStatus.rejected ||
                        order.status == OrderStatus.completed
                    ? null
                    : nameDriverController.text.isEmpty
                        ? null
                        : IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              nameDriverController.clear();
                            }),
                labelText: 'Tên tài xế',
                labelStyle: TextStyle(
                    color: lightColorScheme.onSurfaceVariant.withOpacity(0.6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(cornerNormal),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: lightColorScheme.onSurfaceVariant
                        .withOpacity(0.5), // Màu nhạt với độ mờ 50%
                  ),
                  borderRadius: BorderRadius.circular(cornerNormal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: lightColorScheme.primary, width: 2.0),
                  borderRadius: BorderRadius.circular(cornerNormal),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
              style: TextStyle(fontSize: 16.0, color: lightColorScheme.scrim),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: idNumberController,
                    focusNode: _idNumberFocus,
                    enabled: order.status == OrderStatus.rejected ||
                            order.status == OrderStatus.completed
                        ? false
                        : true,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            "assets/icons/id_card.png",
                            fit: BoxFit.contain,
                            color: _isFocused1
                                ? lightColorScheme.primary
                                : lightColorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      suffixIcon: order.status == OrderStatus.rejected ||
                              order.status == OrderStatus.completed
                          ? null
                          : idNumberController.text.isEmpty
                              ? null
                              : IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    idNumberController.clear();
                                  }),
                      labelText: 'CCCD/GPLX',
                      labelStyle: TextStyle(
                          color: lightColorScheme.onSurfaceVariant
                              .withOpacity(0.6)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cornerNormal),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: lightColorScheme.onSurfaceVariant
                              .withOpacity(0.5), // Màu nhạt với độ mờ 50%
                        ),
                        borderRadius: BorderRadius.circular(cornerNormal),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: lightColorScheme.primary, width: 2.0),
                        borderRadius: BorderRadius.circular(cornerNormal),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                    ),
                    style: TextStyle(
                        fontSize: 16.0, color: lightColorScheme.scrim),
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  onPressed: order.isCompleted
                      ? null
                      : () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                margin: EdgeInsets.only(left: 12),
                                padding: EdgeInsets.only(left: 12, right: 12),
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                // color: lightColorScheme.secondaryContainer,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 12,
                                      ),
                                      CustomTextWithIcon(
                                          text: "Thông báo",
                                          style: TextStyle(fontSize: 24),
                                          iconPath: "assets/icons/noti.png"),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "Chọn ảnh",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      AppButton(
                                        'Thư viện hình ảnh',
                                        onPressed: () async {
                                          await _pickImageID();
                                          Navigator.pop(context);
                                          if (_imageFile != null) {
                                            await _processImageID();
                                            await _processNameID();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      AppButton(
                                        'Chụp ảnh',
                                        onPressed: () async {
                                          final pickedImage =
                                              await ImagePicker().pickImage(
                                                  source: ImageSource.camera);
                                          Navigator.pop(context);
                                          if (pickedImage != null) {
                                            setState(() {
                                              _imageFile =
                                                  File(pickedImage.path);
                                            });
                                            await _processNameID();
                                            await _processImageID();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      AppButton(
                                        'Hủy',
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                  icon: Icon(Icons.camera_alt_outlined),
                  iconSize: 36,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                      controller: vehicleNumberController,
                      focusNode: _vehicleNumberFocus,
                      enabled: order.status == OrderStatus.rejected ||
                              order.status == OrderStatus.completed
                          ? false
                          : true,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Opacity(
                            opacity: 0.6,
                            child: Image.asset(
                              "assets/icons/car.png",
                              fit: BoxFit.contain,
                              color: _isFocused2
                                  ? lightColorScheme.primary
                                  : lightColorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        suffixIcon: order.status == OrderStatus.rejected ||
                                order.status == OrderStatus.completed
                            ? null
                            : vehicleNumberController.text.isEmpty
                                ? null
                                : IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      vehicleNumberController.clear();
                                    }),
                        labelText: 'Biển số xe',
                        labelStyle: TextStyle(
                            color: lightColorScheme.onSurfaceVariant
                                .withOpacity(0.6)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(cornerNormal),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: lightColorScheme.onSurfaceVariant
                                .withOpacity(0.5), // Màu nhạt với độ mờ 50%
                          ),
                          borderRadius: BorderRadius.circular(cornerNormal),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: lightColorScheme.primary, width: 2.0),
                          borderRadius: BorderRadius.circular(cornerNormal),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                      ),
                      style: TextStyle(
                          fontSize: 16.0, color: lightColorScheme.scrim)),
                ),
                SizedBox(width: 16),
                IconButton(
                  onPressed: order.isCompleted
                      ? null
                      : () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                margin: EdgeInsets.only(left: 12),
                                padding: EdgeInsets.only(left: 12, right: 12),
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                // color: lightColorScheme.secondaryContainer,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 12,
                                      ),
                                      CustomTextWithIcon(
                                          text: "Thông báo",
                                          style: TextStyle(fontSize: 24),
                                          iconPath: "assets/icons/noti.png"),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "Chọn ảnh",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      AppButton(
                                        'Thư viện hình ảnh',
                                        onPressed: () async {
                                          await _pickImage();
                                          Navigator.pop(context);
                                          if (_imageFile != null) {
                                            await _processImage_vehicleNumber();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      AppButton(
                                        'Chụp ảnh',
                                        onPressed: () async {
                                          final pickedImage =
                                              await ImagePicker().pickImage(
                                                  source: ImageSource.camera);
                                          Navigator.pop(context);
                                          if (pickedImage != null) {
                                            setState(() {
                                              _imageFile =
                                                  File(pickedImage.path);
                                            });
                                            await _processImage_vehicleNumber();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      AppButton(
                                        'Hủy',
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                  icon: Icon(Icons.camera_alt_outlined),
                  iconSize: 36,
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.15,
            ),
            buildOrderButtons(order),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
