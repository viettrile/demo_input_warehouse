import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_demo_kho/configs/config.dart';
import 'package:flutter_app_demo_kho/data/all_orders.dart';
import 'package:flutter_app_demo_kho/data/complete_order.dart';
import 'package:flutter_app_demo_kho/data/denied_orders.dart';
import 'package:flutter_app_demo_kho/data/incomplete.dart';
import 'package:flutter_app_demo_kho/data/temporary_orders.dart';
import 'package:flutter_app_demo_kho/model/data/order.dart';
import 'package:flutter_app_demo_kho/routes/routes.dart';
import 'package:flutter_app_demo_kho/widget/app_button.dart';
import 'package:flutter_app_demo_kho/widget/app_icon.dart';
import 'package:intl/intl.dart';

class InventoryInScreen extends StatefulWidget {
  const InventoryInScreen({super.key});
  @override
  State<InventoryInScreen> createState() => _InventoryInScreenState();
}

class _InventoryInScreenState extends State<InventoryInScreen> {
  TextEditingController searchIdController = TextEditingController();
  TextEditingController searchSupplierController = TextEditingController();
  TextEditingController searchSupplierParentController =
      TextEditingController();
  TextEditingController _dateController = TextEditingController();
  FocusNode searchIdFocusNode = FocusNode();
  FocusNode searchSupplierParentFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode _searchSupplierNode = FocusNode();

  List<String> getSuppliersList(List<Order> orders) {
    return orders.map((order) => order.supplierName).toSet().toList();
  }

  List<Order> _filterOrders({
    required List<Order> orders,
    String? orderId,
    String? selectedSupplier,
    DateTime? selectedDate,
    String? entryPerson,
  }) {
    return orders.where((order) {
      final orderDate =
          DateFormat('yyyy-MM-dd').parse(order.dateOfEntry, true).toLocal();
      final isDateMatch = selectedDate == null ||
          (orderDate.year == selectedDate.year &&
              orderDate.month == selectedDate.month &&
              orderDate.day == selectedDate.day);

      final isSupplierMatch =
          selectedSupplier == null || order.supplierName == selectedSupplier;

      final isOrderIdMatch =
          orderId == null || order.orderId.toLowerCase().contains(orderId);

      // final isEntryPersonMatch = entryPerson == null ||
      //     order.entryPerson.toLowerCase().contains(entryPerson);
      return isOrderIdMatch && isSupplierMatch && isDateMatch;
      // isEntryPersonMatch;
    }).toList();
  }

  String? selectedSupplier;
  String? selectedEntryPerson;
  DateTime? _selectedDate;

  List<Order> orders = allOrdersData;
  List<Order> orders1 = completedOrdersData;
  List<Order> orders2 = incompleteOrdersData;
  List<Order> orders3 = temporaryOrdersData;
  List<Order> orders4 = deniedOrdersData;

  List<Order> filteredAllOrders = [];
  List<Order> filterCompletedOrders = [];
  List<Order> filterIncompleteOrders = [];
  List<Order> filterTemporaryOrders = [];
  List<Order> filterDeniedOrders = [];

  bool _isFocusSearchID = false;
  bool _isFocusSearchName = false;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();

    filteredAllOrders = List<Order>.from(orders);
    filterCompletedOrders = List<Order>.from(orders1);
    filterIncompleteOrders = List<Order>.from(orders2);
    filterTemporaryOrders = List<Order>.from(orders3);
    filterDeniedOrders = List<Order>.from(orders4);

    searchIdController.addListener(() {
      filterSearchResults(searchIdController.text);
    });
    _searchSupplierNode.addListener(() {
      setState(
        () {
          _isFocusSearchName = _searchSupplierNode.hasFocus;
        },
      );
    });
    searchIdFocusNode.addListener(() {
      setState(() {
        _isFocusSearchID = searchIdFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    searchIdController.dispose();
    searchSupplierController.dispose();
    searchIdFocusNode.dispose();
    _searchSupplierNode.dispose();
    super.dispose();
  }

  List<Order> dataSearch(String query, List<Order> listData) {
    if (query.isNotEmpty) {
      return listData.where((order) {
        return order.orderId.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      return List<Order>.from(listData);
    }
  }

  void filterSearchResults(String query) {
    print('Search query: $query');
    setState(() {
      final String? orderId = searchIdController.text.isNotEmpty
          ? searchIdController.text.toLowerCase()
          : null;
      if (orderId != null ||
          selectedSupplier != null ||
          _selectedDate != null) {
        filteredAllOrders = _filterOrders(
            orders: orders,
            orderId: orderId,
            selectedSupplier: selectedSupplier,
            selectedDate: _selectedDate);
        filterCompletedOrders = _filterOrders(
            orders: orders1,
            orderId: orderId,
            selectedSupplier: selectedSupplier,
            selectedDate: _selectedDate);
        filterIncompleteOrders = _filterOrders(
            orders: orders2,
            orderId: orderId,
            selectedSupplier: selectedSupplier,
            selectedDate: _selectedDate);
        filterTemporaryOrders = _filterOrders(
            orders: orders3,
            orderId: orderId,
            selectedSupplier: selectedSupplier,
            selectedDate: _selectedDate);
        filterDeniedOrders = _filterOrders(
            orders: orders4,
            orderId: orderId,
            selectedSupplier: selectedSupplier,
            selectedDate: _selectedDate);
        print('Filters applied.');
      } else {
        // Nếu không có điều kiện tìm kiếm nào, thì set lại danh sách đơn hàng không lọc.
        filteredAllOrders = List<Order>.from(allOrdersData);
        filterCompletedOrders = List<Order>.from(completedOrdersData);
        filterIncompleteOrders = List<Order>.from(incompleteOrdersData);
        filterTemporaryOrders = List<Order>.from(temporaryOrdersData);
        filterDeniedOrders = List<Order>.from(deniedOrdersData);
        print('No filters applied.');
      }
    });
  }

  void onTap(int index) {
    searchIdController.clear();
    setState(() {});
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final initialDate = DateTime.now();
    final firstDate = DateTime(2022);
    final lastDate = DateTime(2030);
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: initialDate,
        end: initialDate.add(Duration(
            days:
                7)), // Khởi tạo một phạm vi mặc định từ ngày hiện tại đến 7 ngày sau
      ),
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        // Xử lý khi người dùng chọn phạm vi ngày
        // picked.start là ngày bắt đầu, picked.end là ngày kết thúc
        // Cập nhật giá trị ngày được chọn vào _selectedDate hoặc _startDate, _endDate
        // _startDate = picked.start;
        // _endDate = picked.end;
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        print("picked : ${picked.toString().split(" ")[0]}");
        _dateController.text = DateFormat('yyyy-MM-dd')
            .format(picked); // Cập nhật text của _dateController
        filterSearchResults(
            _dateController.text); // Gọi hàm lọc khi có thay đổi
      });
    }
  }

  void _runFilter() {
    filterSearchResults(searchIdController.text);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            onTap: onTap,
            tabAlignment: TabAlignment.center,
            labelPadding: EdgeInsets.symmetric(horizontal: 12.0),
            dividerColor: Colors.white,
            indicatorPadding: EdgeInsets.all(2),
            indicatorWeight: 0,
            indicatorColor: Colors.white,
            padding: EdgeInsets.only(top: 20, left: 12),
            tabs: const [
              Tab(text: 'Tất cả'),
              Tab(text: 'Chờ nhập kho'),
              Tab(text: 'Hoàn thành'),
              Tab(text: "Nhập tạm"),
              Tab(text: "Từ chối"),
            ],
            unselectedLabelColor: lightColorScheme.tertiary,
            unselectedLabelStyle: TextStyle(fontSize: 16),
            // Màu của label khi tab không được chọn
            indicatorSize: TabBarIndicatorSize.tab, // Kích thước của indicator
            indicator: BoxDecoration(
              // Custom indicator shape
              borderRadius: BorderRadius.circular(cornerNormal),
              color: lightColorScheme.surfaceTint, // Màu của indicator
            ),
            labelColor:
                lightColorScheme.surface, // Màu của label khi tab được chọn
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16), // Style của
          ),
          title: Text(
            'Phiếu nhập kho',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: <Widget>[
            // SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchIdController,
                      focusNode: searchIdFocusNode,
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 12),
                        labelText: 'Search',
                        hintText: 'Nhập mã đơn hàng ở đây!',
                        hintStyle: TextStyle(
                            color: lightColorScheme.secondary.withOpacity(0.6)),
                        // prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search_outlined,
                              color: _isFocusSearchID
                                  ? lightColorScheme.primary
                                  : lightColorScheme.onSurfaceVariant),
                          onPressed: () {
                            filterSearchResults(searchIdController.text);
                            searchIdFocusNode.unfocus();
                            FocusScope.of(context).unfocus();
                            // print();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(cornerNormal)),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          var suppliers = getSuppliersList(allOrdersData);
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return Container(
                                height: size.height * 0.95,
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              'assets/icons/filter2.png',
                                              fit: BoxFit.contain,
                                              color: lightColorScheme.primary),
                                        ),
                                        Text(
                                          'Tìm kiếm',
                                          style: TextStyle(
                                              color: lightColorScheme.primary,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: size.width * 0.37),
                                        IconButton(
                                          iconSize: 28,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(Icons.clear_outlined),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.09,
                                    ),
                                    TextField(
                                      controller:
                                          searchSupplierParentController,
                                      focusNode: searchSupplierParentFocusNode,
                                      decoration: InputDecoration(
                                        labelText: 'Tìm nhà cung cấp',
                                        contentPadding:
                                            EdgeInsets.fromLTRB(12, 12, 0, 12),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (searchSupplierParentController
                                                .text.isNotEmpty)
                                              IconButton(
                                                icon: Icon(Icons.clear),
                                                onPressed: () {
                                                  searchSupplierParentController
                                                      .clear();
                                                  selectedSupplier = null;
                                                  filterSearchResults(
                                                      searchIdController.text);
                                                  setState(() {});
                                                },
                                              ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.search_outlined,
                                              ),
                                              onPressed: () {
                                                _searchSupplierNode.unfocus();
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                            ),
                                          ],
                                        ),
                                        labelStyle: TextStyle(
                                            color: lightColorScheme
                                                .onSurfaceVariant
                                                .withOpacity(0.6)),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              cornerNormal),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: lightColorScheme
                                                .onSurfaceVariant
                                                .withOpacity(
                                                    0.5), // Màu nhạt với độ mờ 50%
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              cornerNormal),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: lightColorScheme.primary,
                                              width: 2.0),
                                          borderRadius: BorderRadius.circular(
                                              cornerNormal),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: lightColorScheme.scrim),
                                      onTap: () {
                                        showModalBottomSheet<void>(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(builder:
                                                  (BuildContext context,
                                                      StateSetter setState) {
                                                return Container(
                                                  height: size.height * 0.95,
                                                  padding: EdgeInsets.all(16),
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.09,
                                                      ),
                                                      TextField(
                                                        controller:
                                                            searchSupplierController,
                                                        focusNode:
                                                            _searchSupplierNode,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedSupplier =
                                                                value;
                                                            if (value.isEmpty) {
                                                              // Nếu chuỗi tìm kiếm trống, hiển thị danh sách ban đầu
                                                              suppliers =
                                                                  getSuppliersList(
                                                                      allOrdersData);
                                                            } else {
                                                              // Nếu không, lọc danh sách nhà cung cấp dựa trên chuỗi tìm kiếm
                                                              suppliers =
                                                                  suppliers.where(
                                                                      (supplier) {
                                                                return supplier
                                                                    .toLowerCase()
                                                                    .contains(value
                                                                        .toLowerCase());
                                                              }).toList();
                                                            }
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Tìm nhà cung cấp',
                                                          hintText:
                                                              'Nhập tên nhà cung cấp',
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                      12,
                                                                      12,
                                                                      0,
                                                                      12),
                                                          suffixIcon: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .search_outlined,
                                                                  color: _isFocusSearchName
                                                                      ? lightColorScheme
                                                                          .primary
                                                                      : lightColorScheme
                                                                          .onSurfaceVariant,
                                                                ),
                                                                onPressed:
                                                                    () {},
                                                              ),
                                                            ],
                                                          ),
                                                          labelStyle: TextStyle(
                                                              color: lightColorScheme
                                                                  .onSurfaceVariant
                                                                  .withOpacity(
                                                                      0.6)),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        cornerNormal),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: lightColorScheme
                                                                  .onSurfaceVariant
                                                                  .withOpacity(
                                                                      0.5), // Màu nhạt với độ mờ 50%
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        cornerNormal),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    lightColorScheme
                                                                        .primary,
                                                                width: 2.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        cornerNormal),
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                        ),
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            color:
                                                                lightColorScheme
                                                                    .scrim),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.04,
                                                      ),
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        flex: 3,
                                                        child: Scrollbar(
                                                          thumbVisibility: true,
                                                          thickness:
                                                              4.0, // Tùy chỉnh độ dày của Scrollbar
                                                          child: ListView
                                                              .separated(
                                                            itemCount: suppliers
                                                                .length,
                                                            separatorBuilder: (context,
                                                                    index) =>
                                                                Divider(
                                                                    color: lightColorScheme
                                                                        .onSurface
                                                                        .withOpacity(
                                                                            0.1)), // Màu Divider nhạt
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return ListTile(
                                                                title: Text(
                                                                  suppliers[
                                                                      index],
                                                                  style: TextStyle(
                                                                      color: lightColorScheme
                                                                          .onSurface), // Điều chỉnh màu chữ
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    searchSupplierParentController
                                                                            .text =
                                                                        suppliers[
                                                                            index];
                                                                    selectedSupplier =
                                                                        searchSupplierParentController
                                                                            .text;
                                                                    print(searchSupplierParentController
                                                                        .text);
                                                                    filterSearchResults(
                                                                        selectedSupplier!);
                                                                    _searchSupplierNode
                                                                        .unfocus();
                                                                    searchSupplierParentFocusNode
                                                                        .unfocus();
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    Navigator.pop(
                                                                        context);
                                                                  });
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                            });
                                      },
                                    ),
                                    SizedBox(
                                      height: size.height * 0.04,
                                    ),
                                    Column(
                                      children: [
                                        TextField(
                                          controller: _dateController,
                                          focusNode: dateFocusNode,
                                          readOnly: true,
                                          onTap: _selectDate,
                                          decoration: InputDecoration(
                                            labelText: 'Ngày nhập kho',
                                            hintText: "YYYY-MM-DD",
                                            contentPadding: EdgeInsets.fromLTRB(
                                                12, 12, 0, 12),
                                            suffixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (_dateController
                                                      .text.isNotEmpty)
                                                    IconButton(
                                                      icon: Icon(Icons.clear),
                                                      onPressed: () {
                                                        setState(() {
                                                          _dateController
                                                              .clear();
                                                          _selectedDate = null;
                                                          _runFilter();
                                                          dateFocusNode
                                                              .unfocus();
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                        });
                                                      },
                                                    ),
                                                  Icon(Icons.calendar_today),
                                                ],
                                              ),
                                            ),
                                            labelStyle: TextStyle(
                                                color: lightColorScheme
                                                    .onSurfaceVariant
                                                    .withOpacity(0.6)),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      cornerNormal),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: lightColorScheme
                                                    .onSurfaceVariant
                                                    .withOpacity(
                                                        0.5), // Màu nhạt với độ mờ 50%
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      cornerNormal),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      lightColorScheme.primary,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      cornerNormal),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: lightColorScheme.scrim),
                                        ),
                                        // TextField(
                                        //   controller: searchIdController,
                                        //   focusNode: searchIdFocusNode,
                                        //   onChanged: (value) {
                                        //     filterSearchResults(value);
                                        //   },
                                        //   decoration: InputDecoration(
                                        //     contentPadding: EdgeInsets.fromLTRB(
                                        //         12, 12, 0, 12),
                                        //     labelText: 'Search',
                                        //     hintText: 'Tìm kiếm người nhập...!',
                                        //     hintStyle: TextStyle(
                                        //         color: lightColorScheme
                                        //             .secondary
                                        //             .withOpacity(0.6)),
                                        //     // prefixIcon: Icon(Icons.search),
                                        //     suffixIcon: IconButton(
                                        //       icon: Icon(Icons.search_outlined,
                                        //           color: _isFocusSearchID
                                        //               ? lightColorScheme.primary
                                        //               : lightColorScheme
                                        //                   .onSurfaceVariant),
                                        //       onPressed: () {
                                        //         filterSearchResults(
                                        //             searchIdController.text);
                                        //         searchIdFocusNode.unfocus();
                                        //         FocusScope.of(context)
                                        //             .unfocus();
                                        //         // print();
                                        //       },
                                        //     ),
                                        //     border: OutlineInputBorder(
                                        //       borderRadius: BorderRadius.all(
                                        //           Radius.circular(
                                        //               cornerNormal)),
                                        //     ),
                                        //   ),
                                        // ),
                                        SizedBox(
                                          height: size.height * 0.48,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    lightColorScheme.onError,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                minimumSize: Size(
                                                    size.width * 0.3,
                                                    44), // Kích thước tối thiểu cho nút
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        12), // Padding cho nút
                                              ),
                                              child: Text(
                                                "Xóa",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    searchSupplierParentController
                                                        .clear();
                                                    _dateController.clear();
                                                    searchSupplierParentFocusNode
                                                        .unfocus();
                                                    selectedSupplier = null;
                                                    _selectedDate = null;
                                                    filterSearchResults(
                                                        searchIdController
                                                            .text);
                                                  },
                                                );
                                                // Navigator.pop(context);
                                              },
                                            ),
                                            AppButton("Áp dụng", onPressed: () {
                                              setState(() {
                                                filteredAllOrders =
                                                    _filterOrders(
                                                  orders: allOrdersData,
                                                  orderId:
                                                      searchIdController.text,
                                                  selectedSupplier:
                                                      selectedSupplier,
                                                  selectedDate: _selectedDate,
                                                );
                                              });
                                              // Thực hiện lọc tại đây
                                              print(
                                                  'Đã lọc theo nhà cung cấp: $selectedSupplier và ngày: $_selectedDate');
                                              Navigator.pop(context);
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          "assets/icons/filter.png",
                          width: 36,
                          height: 36,
                          color: lightColorScheme.primary.withOpacity(0.8),
                          fit: BoxFit.contain,
                        ),
                        Transform.translate(
                          offset: Offset(0, -6),
                          child: Text(
                            "Lọc",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    lightColorScheme.primary.withOpacity(0.7)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  OrdersList(
                    filteredOrders: filteredAllOrders,
                  ),
                  OrdersList(filteredOrders: filterIncompleteOrders),
                  OrdersList(filteredOrders: filterCompletedOrders),
                  OrdersList(filteredOrders: filterTemporaryOrders),
                  OrdersList(filteredOrders: filterDeniedOrders),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const CustomText(this.text, {this.style, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(
      color: lightColorScheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    );
    return Text(
      text,
      style: style ?? defaultStyle,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class OrdersList extends StatefulWidget {
  final List<Order> filteredOrders;
  OrdersList({required this.filteredOrders});
  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background_image.jpg"),
            fit: BoxFit.fitHeight),
      ),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 8),
        itemCount: widget.filteredOrders.length,
        itemBuilder: (context, index) {
          Order order = widget.filteredOrders[index];
          return Container(
            padding: EdgeInsets.only(left: 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cornerMedium),
              ),
              color: order.isCompleted
                  ? lightColorScheme.surface
                  : lightColorScheme.primaryContainer,
              shadowColor: lightColorScheme.onSurfaceVariant,
              elevation: 10,
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: ListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            ' ${order.orderId} - ${order.dateOfEntry} ',
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          CustomTextWithIcon(
                            text: '${order.supplierName}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            iconPath: 'assets/icons/supplier.png',
                          ),
                          CustomTextWithIcon(
                            text: 'Người nhập: ${order.entryPerson}',
                            iconPath: 'assets/icons/person_edit.png',
                          ),
                          CustomTextWithIcon(
                            text: 'Biển số xe: ${order.vehicleNumber}',
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: order.status == OrderStatus.rejected ||
                                        order.status == OrderStatus.completed ||
                                        order.status ==
                                            OrderStatus.temporaryEntry
                                    ? lightColorScheme.scrim
                                    : lightColorScheme.error),
                            iconPath: 'assets/icons/car.png',
                          ),
                          CustomTextWithIcon(
                            iconSize: 18,
                            text: 'Tên tài xế: ${order.driverName}',
                            iconPath: 'assets/icons/driver.png',
                          ),
                          CustomTextWithIcon(
                            text: 'CCCD/GPLX: ${order.identification}',
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: order.status == OrderStatus.rejected ||
                                        order.status == OrderStatus.completed ||
                                        order.status ==
                                            OrderStatus.temporaryEntry
                                    ? lightColorScheme.scrim
                                    : lightColorScheme.error),
                            iconPath: 'assets/icons/id_card.png',
                          ),
                          CustomTextWithIcon(
                              text: 'Trạng thái: ${order.getStatusString()}',
                              iconPath: 'assets/icons/status.png'),
                          Transform.translate(
                            offset: Offset(-12, -12),
                            child: Accordion(
                              // paddingListTop: 4,
                              paddingListBottom: 0,
                              maxOpenSections: 1,
                              flipLeftIconIfOpen: true,
                              header: Text('Xem Thêm',
                                  style: TextStyle(fontSize: 24)),
                              headerBackgroundColor:
                                  order.status == OrderStatus.completed
                                      ? lightColorScheme.background
                                      : lightColorScheme.primaryContainer,
                              headerBackgroundColorOpened:
                                  lightColorScheme.primaryContainer,
                              // headerPadding: EdgeInsets.symmetric(
                              //     horizontal: 40, vertical: 10),
                              headerPadding: EdgeInsets.fromLTRB(0, 4, 112, 0),
                              children: [
                                AccordionSection(
                                  isOpen: isExpanded,
                                  contentBackgroundColor:
                                      lightColorScheme.surface,
                                  leftIcon: Icon(Icons.keyboard_arrow_down,
                                      color: lightColorScheme.primary),

                                  rightIcon: Icon(Icons.keyboard_arrow_down,
                                      color: lightColorScheme.background,
                                      size: 20),
                                  header: Text('Xem thêm',
                                      style: TextStyle(
                                          color: lightColorScheme.primary)),
                                  contentBorderColor: lightColorScheme.surface,
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${order.specification}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        // SizedBox(height: 8),
                                        Text(
                                            'Số lô/ Mã cuộn: ${order.Lot}/ ${order.rollCode}'),
                                        // SizedBox(height: 8),
                                        Text(
                                            'Số lượng(Cây/Tấm/Cuộn): ${order.quantity}         Trọng lượng: ${order.weight} kg'),

                                        Text(
                                            'Số lô/ Mã cuộn: ${order.Lot}/ ${order.rollCode}'),
                                        Text(
                                            'Số lô/ Mã cuộn: ${order.Lot}/ ${order.rollCode}'),
                                        Text(
                                            'Số lô/ Mã cuộn: ${order.Lot}/ ${order.rollCode}'),     Text(
                                            'Số lô/ Mã cuộn: ${order.Lot}/ ${order.rollCode}'),     Text(
                                            'Số lô/ Mã cuộn: ${order.Lot}/ ${order.rollCode}'),     Text(
                                            'Số lô/ Mã cuộn: ${order.Lot}/ ${order.rollCode}'),     Text(
                                            'Số lô/ Mã cuộn: ${order.Lot}/ ${order.rollCode}'),     Text(
                                            'Số lô/ Mã cuộn: ${order.Lot}/ ${order.rollCode}'),
                                        Text(
                                            'Số lô/ Mã cuộn: ${order.Lot}/ ${order.rollCode}'),
                                      ],
                                    ),
                                  ),
                                  // onOpenSection: () =>
                                  //     setState(() => isExpanded = true),
                                  // onCloseSection: () =>
                                  //     setState(() => isExpanded = false),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          Routes.detail_inputInventory,
                          arguments: order,
                        );
                        // Kiểm tra kết quả trả về từ Navigator.pop
                        if (result != null) {
                          // (context as Element).markNeedsBuild();
                          setState(() {
                            order = result as Order;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
