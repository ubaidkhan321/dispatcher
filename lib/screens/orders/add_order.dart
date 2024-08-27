// import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:linear/PdfData/api/pdf_api.dart';
import 'package:linear/PdfData/api/pdf_invoice_api.dart';
import 'package:linear/PdfData/model/customer.dart';
import 'package:linear/PdfData/model/invoice.dart';
import 'package:linear/PdfData/model/supplier.dart';
import 'package:linear/PdfData/utils/flush.dart';
import 'package:linear/screens/order_booker/dashboard.dart';
import 'package:linear/screens/splash_screen/splash.dart';
import 'package:linear/search_widget/retailer_search.dart';
import 'package:linear/utils.dart';
// import 'package:linear/utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import '../../const/appColors.dart';
import 'package:pdf/widgets.dart' as pw;

import '../order_booker/retailer_visit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/globals.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../helpers/api.dart';
import 'dart:convert'; // for using json.decode()
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../search_widget/category_search.dart';
import '../../search_widget/product_search.dart';
import '../../search_widget/sub_category_search.dart';
import '../../search_widget/supplier_search.dart';
import '../order_booker/customer_visit.dart';
import '../order_booker/photo_preview.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

late File? file = null;
var _file;
int counter = 0;
String order_amount = '0';
String formattedDate = formatDate(DateTime.now());

String formatDate(DateTime date) {
  final dateFormat = DateFormat('dd-MM-yyyy');
  return dateFormat.format(date);
}

var _order = [];

//Column
final columnHeaders = [
  'No',
  'SKU',
  'Description',
  'Quantity',
  'Unit Price',
  'MRP',
  'Subtotal'
];

class AddOrder extends StatefulWidget {
  //Assign the values for Pdf
  static var counterss = 0;
  static var add_order_orders;
  static var add_order_rows;
  static var add_order_column;

  final customer;
  final type;
  const AddOrder({Key? key, this.customer, this.type}) : super(key: key);

  @override
  _AddOrderState createState() => _AddOrderState();
}

final pdf = pw.Document();

final prices =
    List.generate(_order.length, (index) => '${_order[index]['price']}');

// Rows
final rows = List.generate(
  _order.length,
  (index) => [
    '${index + 1}',
    '${_order[index]['sku']}',
    '${_order[index]['product']}',
    '${_order[index]['qty']}',
    '${_order[index]['price']}',
    '${_order[index]['amount']}',
  ],
);

class _AddOrderState extends State<AddOrder> {
  bool _saving = false;
  String base_url = 'https://rhotrack.rholabproducts.com/';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _qty_controller = TextEditingController();
  final TextEditingController _update_qty_controller = TextEditingController();
  TextEditingController _search_controller = new TextEditingController();
  TextEditingController _supplier_search_controller =
      new TextEditingController();
  String search = '';
  String supplier_search = '';

  // final TextEditingController _category_name_controller = TextEditingController();
  final TextEditingController _category_controller = TextEditingController();
  final TextEditingController _category_id_controller = TextEditingController();

  final TextEditingController _sub_category_controller =
      TextEditingController();
  final TextEditingController _sub_category__id_controller =
      TextEditingController();

  final TextEditingController _product_controller = TextEditingController();
  final TextEditingController _product_id_controller = TextEditingController();
  final TextEditingController _product_barcode_controller =
      TextEditingController();
  final TextEditingController _product_rate_controller =
      TextEditingController();
  final TextEditingController _supplier_controller = TextEditingController();
  final TextEditingController _supplier_id_controller = TextEditingController();
  final TextEditingController _selling_price_controller =
      TextEditingController();

  var _order_id = [];
  bool allow_sub_cate = false;
  List _categories = [];
  List _sub_categories = [];
  List _product = [];
  List _supplier = [];

  var supplier_id = '';
  var product_id = '';
  var product_name = '';
  var product_barcode = '';
  var product_quantity = '';
  var product_rate = '';
  var product_amount = '';
  int product_inc = 0;

  String total_product = '0';

  String? sess_user_id = '';
  String? sess_werehouse_id = '';
  String? sess_customer_id = '';
  String? sess_retailer_id = '';

  Future<void> _fetchSupplier() async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_supplier('', '', '');
    if (res['code_status'] == true) {
      setState(() {
        _saving = false;
      });
      setState(
        () {
          _supplier = res['suppliers'];
        },
      );
    }
  }

  Future<void> _fetchCategory() async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_catgories('', '', '', '');
    if (res['code_status'] == true) {
      setState(() {
        _saving = false;
      });
      setState(
        () {
          _categories = res['categories'];
        },
      );
    }
    print(_categories);
  }

  Future<void> _fetchsubCategory(category) async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_catgories('', '', '', category);
    if (res['code_status'] == true) {
      setState(
        () {
          setState(() {
            _saving = false;
          });
          _sub_categories = res['categories'];
        },
      );
    }
    print(_sub_categories);
  }

  Future<void> _fetchproduct(category, sub_category, supplier_id) async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_products(
        '', '', '', category, sub_category, '', '', supplier_id);
    if (res['code_status'] == true) {
      setState(
        () {
          setState(() {
            _saving = false;
          });
          _product = res['products'];
        },
      );
    }
  }

  static _read(thekey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = thekey.toString();
    final value = prefs.getString(key);
    print('saved tester $value');
    String usu = (value != null ? value : '');
    return usu;
  }

  @override
  void initState() {
    // TODO: implement initState
    getdata();
    _loadCounter();
    // getcustomer();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // sess_werehouse_id = await _read('werehouse_id');
    });
  }

// Store the counter value
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = prefs.getInt('counter') ?? 0;
      // counter = ;

      print("Counter valuess $counter");
    });
  }

// Increment counter code
  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', counter);
      // prefs.remove('counter');
    });
  }

  @override
  Widget build(BuildContext context) {
    AddOrder.counterss = counter;
    // print('Counter value yoo ${AddOrder.counterss}');
    // print('object');
    // // print('Counterss ${AddOrder.counterss}');
    // print('Rows $rows');
    // print('Prices $prices');
    // print('Product mrp $product_rate');
    // print("GEt Products $_product");
    // print('GEt Categories $_sub_categories');
    // print('GEt Supplier $_supplier');
    // print('Categories $_categories');
    // print('USER ID : ' + sess_user_id.toString());
    // print('WEREHOUSE ID : ' + sess_werehouse_id.toString());
    // print(' CUSTOMER ID :' + sess_customer_id.toString());
    // print('Product ID $product_id');
    // print('Supplier Id $supplier_id');

    // print('Po')
    // if (_categories.isEmpty) {
    //   _fetchCategory();
    // }

    // if (_supplier.isEmpty) {
    //   _fetchSupplier();
    // }
    // if (_sub_categories.isEmpty) {
    //   _fetchsubCategory();
    // }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Add Orders'),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //       image: AssetImage(
              //         'assets/images/screen_bg.jpg',
              //       ),
              //       fit: BoxFit.cover),
              // ),
              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                child: Column(
                  children: [
                    SizedBox(
                      child: Card(
                        color: Colors.blueGrey[100],
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Total Product : ' + total_product + ''),
                              Text('Total Amount : ' + order_amount + ''),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 80,
                              child: TextFormField(
                                controller: _supplier_controller,
                                decoration: InputDecoration(
                                  labelText: "Supplier", //label text of field
                                ),
                                onChanged: (value) {
                                  // subject = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Supplier Is Required";
                                  }
                                  return null;
                                },
                                readOnly: true,
                                onTap: () async {
                                  // showMaterialModalBottomSheet(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return SupplierSearch(
                                  //           controller: _supplier_controller,
                                  //           id: _supplier_id_controller);
                                  //     });
                                  if (_order.length > 0) {
                                    show_msg(
                                        'error',
                                        'Product Are Added for this Supplier Cant Change',
                                        context);
                                  } else {
                                    showMaterialModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SupplierSearch(
                                              controller: _supplier_controller,
                                              id: _supplier_id_controller);
                                        });
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              height: 80,
                              child: TextFormField(
                                controller: _product_controller,
                                decoration: InputDecoration(
                                  labelText: "Product", //label text of field
                                ),
                                onChanged: (value) {
                                  // subject = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Product Is Required";
                                  }
                                  return null;
                                },
                                readOnly: true,
                                onTap: () async {
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ProductSearch(
                                        product_controller: _product_controller,
                                        product_id_controller:
                                            _product_id_controller,
                                        product_barcode_controller:
                                            _product_barcode_controller,
                                        category_id: "",
                                        sub_category_id: "",
                                        supplier_id_controller:
                                            _supplier_id_controller,
                                        product_rate_controller:
                                            _product_rate_controller,
                                        selling_price_controller:
                                            _selling_price_controller,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              height: 80,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _qty_controller,
                                decoration: InputDecoration(
                                  labelText: "Quantity", //label text of field
                                ),
                                onChanged: (value) {
                                  // subject = value;
                                  product_quantity = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Quantity Is Required";
                                  }
                                  return null;
                                },
                                onTap: () async {},
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  print(
                                      'Quantity ${product_quantity.toString()}');
                                  print(
                                      'Product Rate ${_product_rate_controller.text}');
                                  var total = double.parse(
                                          '${_product_rate_controller.text}') *
                                      double.parse('${product_quantity}');
                                  print('Total $total');
                                  product_inc++;
                                  Map _data_2 = {
                                    "id": product_inc,
                                    'product_id': _product_id_controller.text,
                                    "product": _product_controller.text,
                                    "sku": _product_barcode_controller.text,
                                    "qty": product_quantity.toString(),
                                    "price": _product_rate_controller.text
                                        .toString(),
                                    // "selling_price":
                                    //     _selling_price_controller.text,
                                    "product_mrp":
                                        _selling_price_controller.text,
                                    "amount": total.toString()
                                  };
                                  setState(
                                    () {
                                      if (_order_id.contains(
                                          _product_id_controller.text)) {
                                        show_msg(
                                            'error',
                                            'Product is Already Exist',
                                            context);
                                      } else {
                                        _order_id
                                            .add(_product_id_controller.text);
                                        _order.add(_data_2);
                                        print('wajih is here $_data_2');
                                        print(
                                            'product rates wajih $product_rate');
                                        var summery = calculate_total(_order);
                                        // Remove Decimal in Total Order Amount
                                        var order_amounts =
                                            summery['total_amount'].toString();
                                        //
                                        double convert_order_amount =
                                            double.parse('$order_amounts');
                                        //
                                        NumberFormat formatter_order_amount =
                                            NumberFormat.decimalPattern();
                                        String formattedOrderAmount =
                                            formatter_order_amount
                                                .format(convert_order_amount);
                                        print(
                                            'Total order Amount without decimal $formattedOrderAmount');
                                        print(
                                            'Total order Amount with Decimal $order_amounts');
                                        //
                                        var total_product =
                                            summery['total_product'].toString();

                                        print("Total Product ${total_product}");
                                        order_amount = formattedOrderAmount;
                                      }
                                      _qty_controller.text = '';
                                      _product_controller.text = '';

                                      // this is for pdf
                                      AddOrder.add_order_orders = _order;
                                      print("Orderss $_order");
                                      // this is for pdf
                                      AddOrder.add_order_rows = rows;
                                      // this is for pdf
                                      AddOrder.add_order_column = columnHeaders;

                                      // // Rows
                                      // print('Sku ${_order[0]['sku']}');
                                      // print('Product ${_order[0]['product']}');
                                      // print('Amount ${_order[0]['amount']}');
                                      // print('Total Order $order_amount');
                                    },
                                  );
                                }
                              },
                              child: Text('Add Item'),
                            )
                          ],
                        ),
                      ),
                    ),
                    _order.isEmpty
                        ? Center(
                            child: Text(
                              'No Data',
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                itemCount: _order.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  // Convert price without decimal

                                  // var price_Data =
                                  //     _order[index]['selling_price'];
                                  var price_Data = _order[index]['product_mrp'];
                                  //
                                  double convert_price =
                                      double.parse('${price_Data}');
                                  //
                                  NumberFormat formatter_p =
                                      NumberFormat.decimalPattern();
                                  //
                                  String formatted_price =
                                      formatter_p.format(convert_price);
                                  print(
                                      'Price Without decimal $formatted_price');
                                  //
                                  // Convert Amount without decimal
                                  var amout_Data = _order[index]['amount'];
                                  double convert_amount =
                                      double.parse(amout_Data);
                                  NumberFormat formatter_a =
                                      NumberFormat.decimalPattern();
                                  String formatted_amount =
                                      formatter_a.format(convert_amount);
                                  print(
                                      'Amount Without decimal $formatted_amount');
                                  return InkWell(
                                    child: Card(
                                      child: ListTile(
                                        leading: Icon(Icons.inventory_2),
                                        title: Text(_order[index]['product']),
                                        subtitle: Text('' +
                                            _order[index]['sku'] +
                                            '\nQty :' +
                                            _order[index]['qty'] +
                                            ' \nRate : ' +
                                            formatted_price +
                                            '\nAmount : ' +
                                            formatted_amount),
                                        trailing: Column(
                                          children: [
                                            // Text(_order[index]['amount']),
                                            PopupMenuButton(
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                    value: 'update_qty',
                                                    child:
                                                        Text('Update Quantity'),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text('Delete'),
                                                  )
                                                ];
                                              },
                                              onSelected: (String value) {
                                                if (value == 'update_qty') {
                                                  _update_qty_controller.text =
                                                      _order[index]['qty'];
                                                  showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20))),
                                                    context: context,
                                                    backgroundColor:
                                                        Colors.white,
                                                    builder: (context) =>
                                                        Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      child: SizedBox(
                                                        height: 250,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Update Quantity',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 25,
                                                                  color: AppColors
                                                                      .ThemeColor),
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            TextFormField(
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  _update_qty_controller,
                                                              decoration: InputDecoration(
                                                                  // contentPadding:
                                                                  //     EdgeInsets.symmetric(
                                                                  //         horizontal:
                                                                  //             20),
                                                                  // labelText:
                                                                  //     "Update Quantity",
                                                                  // border:
                                                                  //     OutlineInputBorder(), //label text of field
                                                                  ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  _order[index][
                                                                          'qty'] =
                                                                      _update_qty_controller
                                                                          .text;
                                                                  _order[index][
                                                                      'amount'] = double.parse(
                                                                          _order[index]
                                                                              [
                                                                              'qty']) *
                                                                      double.parse(
                                                                          _order[index]
                                                                              [
                                                                              'price']);
                                                                  _order[index][
                                                                      'amount'] = _order[
                                                                              index]
                                                                          [
                                                                          'amount']
                                                                      .toString();
                                                                  var summery =
                                                                      calculate_total(
                                                                          _order);
                                                                  total_product =
                                                                      summery['total_product']
                                                                          .toString();
                                                                  order_amount =
                                                                      summery['total_amount']
                                                                          .toString();
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  'Update'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                if (value == 'delete') {
                                                  setState(() {
                                                    _order_id.remove(
                                                        _order[index]
                                                            ['product_id']);
                                                    _order.removeWhere(
                                                        (element) =>
                                                            element['id'] ==
                                                            _order[index]
                                                                ['id']);
                                                    var summery =
                                                        calculate_total(_order);
                                                    total_product =
                                                        summery['total_product']
                                                            .toString();
                                                    order_amount =
                                                        summery['total_amount']
                                                            .toString();
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_order.isEmpty) {
            await Flushbar(
              forwardAnimationCurve: Curves.decelerate,
              flushbarPosition: FlushbarPosition.TOP,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: EdgeInsets.all(15),
              positionOffset: 8,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: Colors.red,
              titleColor: Colors.white,
              duration: Duration(seconds: 2),
              icon: Icon(Icons.error, color: Colors.white),
              message: 'Order is not Added',
            ).show(context);
          } else {
            setState(() {
              _saving = true;
            });
            var _route = ModalRoute.of(context)?.settings.name.toString();
            var splitted = _route?.split('/');
            // print(splitted![3]);
            // print(_order);
            List filter_order = [];
            if (!_order.isEmpty) {
              for (var or in _order) {
                print(or);
                Map Single = {
                  'product_id': or['product_id'],
                  'quantity': or['qty']
                };
                filter_order.add(Single);
              }
            }

            print('Filter data: $filter_order');
            print('USER ID : ' + sess_user_id.toString());
            print('WEREHOUSE ID : ' + sess_werehouse_id.toString());
            print(' CUSTOMER ID :' + sess_customer_id.toString());
            var now = new DateTime.now();
            var formatter = new DateFormat('yyyy-MM-dd');
            String formattedDate = formatter.format(now);
            print(formattedDate); // 2016-01-25
            var res = await api.add_order(
                '',
                '',
                formattedDate.toString(),
                (widget.type == 'customer')
                    ? sess_customer_id.toString()
                    : sess_retailer_id.toString(),
                _supplier_id_controller.text.toString(),
                sess_user_id.toString(),
                jsonEncode(filter_order));
            print('Supplier Id ${_supplier_id_controller.text.toString()}');
            print('The response');

            final date = DateTime.now();
            final dueDate = date.add(Duration(days: 7));

            //Invoice Code
            final invoice = Invoice(
              supplier: Supplier(
                //Right Side code
                name: '${RetailerVisit.name}',
                address: '${RetailerVisit.address}',
                phone: '${RetailerVisit.phone}',
                email: '${RetailerVisit.email}',
                ntn: '${RetailerVisit.ntn}',
                gst: '${RetailerVisit.gst}',
                //Left Side code
                date: '${formattedDate}',
                po_number:
                    'Mobileapp-${Dashboard.user_idss}${AddOrder.counterss}',
              ),
              customer: Customer(
                name: '',
                address: '',
              ),
              info: InvoiceInfo(
                date: date,
                dueDate: dueDate,
                description: 'My description...',
                number: '${DateTime.now().year}-9999',
              ),
              items: [
                InvoiceItem(
                  description: 'Coffee',
                  date: DateTime.now(),
                  quantity: '3',
                  vat: 0.19,
                  unitPrice: '5.99',
                ),
                InvoiceItem(
                  description: 'Water',
                  date: DateTime.now(),
                  quantity: '8',
                  vat: 0.19,
                  unitPrice: '0.99',
                ),
                InvoiceItem(
                  description: 'Orange',
                  date: DateTime.now(),
                  quantity: '3',
                  vat: 0.19,
                  unitPrice: '2.99',
                ),
                InvoiceItem(
                  description: 'Apple',
                  date: DateTime.now(),
                  quantity: '8',
                  vat: 0.19,
                  unitPrice: '3.99',
                ),
                InvoiceItem(
                  description: 'Mango',
                  date: DateTime.now(),
                  quantity: '1',
                  vat: 0.19,
                  unitPrice: '1.59',
                ),
                InvoiceItem(
                  description: 'Blue Berries',
                  date: DateTime.now(),
                  quantity: '5',
                  vat: 0.19,
                  unitPrice: ' 0.99',
                ),
                InvoiceItem(
                  description: 'Lemon',
                  date: DateTime.now(),
                  quantity: '4',
                  vat: 0.19,
                  unitPrice: '1.29',
                ),
              ],
            );
            //Increment Function
            _incrementCounter();
            print('Increment');
            final pdfFile = await PdfInvoiceApi.generate(invoice);
            print(res);
            if (res['code_status'] == true) {
              setState(() {
                _saving = false;
              });
              AwesomeDialog(
                context: context,
                onDismissCallback: (type) {
                  setState(() {
                    _order.clear(); //
                    print('Order Clear $_order');
                  });
                  PdfApi.openFile(pdfFile);
                },
                dialogType: DialogType.success,
                animType: AnimType.rightSlide,
                title: 'Success',
                desc: 'Order Add Successfully',
                // btnCancelOnPress: () {},
                btnOkOnPress: () {
                  setState(() {
                    _order.clear(); //
                    print('Order Clear $_order');
                  });
                  PdfApi.openFile(pdfFile);

                  if (widget.type == 'customer') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerVisit(),
                      ),
                    );
                    // Navigator.pushNamed(context, '/reatiler_visit');
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RetailerVisit(),
                      ),
                    );
                    // Navigator.pushNamed(context, '/customer_visit');
                  }
                },
              )..show();
            } else {
              setState(() {
                _saving = false;
              });
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'Error',
                desc: res['message'],
                // btnCancelOnPress: () {},
                btnOkOnPress: () {},
              )..show();
            }
          }

          // Add your onPressed code here!
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  calculate_total(_arr) {
    double amount = 0;
    int total_product = 0;
    for (var element in _arr) {
      amount = amount + double.parse(element['amount']);
      total_product = total_product + 1;
    }

    Map res = {
      'total_product': total_product.toString(),
      'total_amount': amount.toString()
    };

    return res;
    // print(amount);
    // print('Function tun ok');
  }

  show_modal(context, _arr, type) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text('Distributor'),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _search_controller,
                      decoration: InputDecoration(
                        labelText: "Search Here",
                        border: OutlineInputBorder(), //label text of field
                      ),
                      onChanged: (value) => {
                        setState(() {
                          search = value.toString();
                          // toggleIcon = true;
                        })
                        // setModalState(() {
                        //     search = value
                        // });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _arr.length,
                      itemBuilder: (BuildContext ctx, index) {
                        var name =
                            (type == 'product') ? 'product_name' : 'name';
                        if (_search_controller.text.isEmpty ||
                            _arr[index][name]
                                .toString()
                                .toLowerCase()
                                .contains(_search_controller.text)) {
                          return InkWell(
                            onTap: () {
                              if (((type == 'product')
                                      ? _arr[index]['product_name']
                                      : _arr[index]['name']) !=
                                  null) {
                                if (type == 'category') {
                                  allow_sub_cate = true;
                                  _category_controller.text =
                                      _arr[index]['name'].toString();
                                  _fetchsubCategory(_arr[index]['id']);
                                }
                                if (type == 'sub_category') {
                                  _sub_category_controller.text =
                                      _arr[index]['name'].toString();
                                  _fetchproduct(_arr[index]['parent_id'],
                                      _arr[index]['id'], supplier_id);
                                }
                                if (type == 'product') {
                                  _product_controller.text =
                                      _arr[index]['product_name'].toString();
                                  setState(() {
                                    product_id = _arr[index]['product_id'];
                                    product_name = _arr[index]['product_name'];
                                    product_barcode =
                                        _arr[index]['product_barcode'];
                                    product_quantity = '0';
                                    product_rate = _arr[index]['product_mrp'];
                                    print('product mrp wajih $product_rate');
                                  });
                                }
                              }
                              Navigator.pop(context);
                            },
                            child: Card(
                              child: ListTile(
                                leading: (type == 'product')
                                    ? InkWell(
                                        child: Image.network(base_url +
                                            '' +
                                            _arr[index]['product_image']
                                                .toString()),
                                        onTap: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PhotoPreview(
                                                  url: base_url +
                                                      '' +
                                                      _arr[index]
                                                              ['product_image']
                                                          .toString()),
                                            ),
                                          )
                                        },
                                      )
                                    : Icon(Icons.inventory_2),
                                title: Text((type == 'product')
                                    ? _arr[index]['product_name'] +
                                        ' ( Rs ' +
                                        _arr[index]['product_mrp'] +
                                        ')'
                                    : _arr[index]['name']),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void getdata() async {
    final prefs = await SharedPreferences.getInstance();
    sess_user_id = prefs.getString('user_id');
    sess_werehouse_id = prefs.getString('werehouse_id');
    sess_customer_id = prefs.getString('customer_visit_id');
    sess_retailer_id = prefs.getString('retailer_visit_id');
    setState(() {});
  }
}

show_msg(status, message, context) {
  return AwesomeDialog(
    context: context,
    dialogType: (status == 'error') ? DialogType.error : DialogType.success,
    animType: AnimType.rightSlide,
    title: (status == 'error') ? 'Error' : 'Success',
    desc: message,
    // btnCancelOnPress: () {},
    btnOkOnPress: () {},
  )..show();
}
