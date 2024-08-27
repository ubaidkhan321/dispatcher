import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../const/appColors.dart';
import 'customer_visit.dart';
import 'photo_preview.dart';
import 'retailer_visit.dart';
import '../../helpers/api.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../search_widget/product_search.dart';
import '../../search_widget/werehouse_search.dart';
import '../../widgets/update_qty_modal.dart';

class OrderHistory extends StatefulWidget {
  final customer;
  final type;
  const OrderHistory({Key? key, this.customer, this.type}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  String base_url = 'https://rhotrack.rholabproducts.com/';
  // String base_url = '';
  var _stock = [];
  var _stock_list = [];
  var _stock_for_api = [];
  var _product = [];
  var _werehouses = [];
  bool _saving = false;
  var product_id = '';
  var product_name = '';
  var product_barcode = '';
  var product_quantity = '';
  int list_inc = 0;
  String? customer_id = '';
  String? retailer_id = '';
  String? created_by = '';

  Future<void> order_history(customer_id) async {
    setState(() {
      _saving = true;
    });
    var res = await api.order_history(customer_id);
    if (res['code_status'] == true) {
      setState(
        () {
          setState(() {
            _saving = false;
          });
          _stock_list = res['stocks'];
        },
      );
    }
    print('order_history:$_stock_list');
  }

  Future<void> _fetchproduct(text) async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_products('', '', text, '', '', '', '', '');
    if (res['code_status'] == true) {
      // print(res);
      setState(
        () {
          for (var i = 0; i < res['products'].length; i++) {
            res['products'][i]['qty'] = 0;
          }
          setState(() {
            _saving = false;
          });
          _product = res['products'];
          print(_product);
        },
      );
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _update_qty_controller = TextEditingController();
  TextEditingController _search_controller = new TextEditingController();

  TextEditingController _product_controller = TextEditingController();
  TextEditingController _product_id_controller = TextEditingController();
  TextEditingController _product_barcode_controller = TextEditingController();
  TextEditingController _werehouse_id_controller = TextEditingController();
  TextEditingController _werehouse_name_controller = TextEditingController();
  TextEditingController _product_search_controller = TextEditingController();

  String search = '';
  static _read(thekey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = thekey.toString();
    final value = prefs.getString(key);
    String usu = (value != null ? value : '');
    return usu;
  }

  @override
  void initState() {
    getdata();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String customer_id = await _read('retailer_visit_id');
      print("The Customer Id : $customer_id");
      await order_history(customer_id.toString());
      print("my stock $_stock_list");
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Product Data wajih  $_product');
    // if (_product.isEmpty) {
    //   _fetchproduct();
    // }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image(
          height: 30,
          fit: BoxFit.contain,
          image: AssetImage(
            'assets/images/distrho_logo.png',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 18),
                  //   child: SizedBox(
                  //     child: TextFormField(
                  //       controller: _werehouse_name_controller,
                  //       readOnly: true,
                  //       onTap: () async {
                  //         showMaterialModalBottomSheet(
                  //             context: context,
                  //             builder: (BuildContext context) {
                  //               return WerehouseSearch(
                  //                 controller: _werehouse_name_controller,
                  //                 id: _werehouse_id_controller,
                  //               );
                  //               // return ProductSearch(
                  //               //   product_controller: _product_controller,
                  //               //   product_id_controller: _product_id_controller,
                  //               //   product_barcode_controller:
                  //               //       _product_barcode_controller,
                  //               //   category_id: '',
                  //               //   sub_category_id: '',
                  //               //   product_rate_controller:
                  //               //       new TextEditingController(),
                  //               // );
                  //             });
                  //         // show_modal(context, _product, 'product');
                  //       },
                  //       decoration: const InputDecoration(
                  //         // icon: Icon(Icons.person),
                  //         filled: true,
                  //         fillColor: Colors.white,
                  //         hintText: 'Select Werehouse',
                  //         labelText: 'Werehouse',
                  //         border: OutlineInputBorder(),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 18),
                  //   child: SizedBox(
                  //     child: TextFormField(
                  //       decoration: const InputDecoration(
                  //         filled: true,
                  //         fillColor: Colors.white,

                  //         // icon: Icon(Icons.person),
                  //         hintText: 'Quantity',
                  //         labelText: 'Quantity',
                  //         border: OutlineInputBorder(),
                  //       ),
                  //       onChanged: (value) {
                  //         product_quantity = value;
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width - 50,
                  //   height: 50,
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       setState(() {
                  //         _fetchproduct('');
                  //       });
                  //       // list_inc++;
                  //       // Map _api_data = {
                  //       //   'product_id': _product_id_controller.text,
                  //       //   'quantity': product_quantity.toString(),
                  //       // };
                  //       // Map _data_2 = {
                  //       //   "id": list_inc,
                  //       //   "product_id": _product_id_controller.text,
                  //       //   "product": _product_controller.text,
                  //       //   "sku": _product_barcode_controller.text,
                  //       //   "qty": product_quantity.toString(),
                  //       // };
                  //       // setState(() {
                  //       //   _stock_for_api.add(_api_data);
                  //       //   _stock.add(_data_2);
                  //       //   print(_stock_for_api);
                  //       //   print(_stock);
                  //       // });
                  //     },
                  //     child: Text('Get Products'),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         flex: 8,
                  //         child: SizedBox(
                  //           child: TextFormField(
                  //             controller: _product_search_controller,
                  //             decoration: const InputDecoration(
                  //               // icon: Icon(Icons.person),
                  //               filled: true,
                  //               fillColor: Colors.white,
                  //               hintText: 'Search Products',
                  //               labelText: 'Search Products',
                  //               border: OutlineInputBorder(),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         flex: 2,
                  //         child: SizedBox(
                  //           height: 50,
                  //           child: ElevatedButton(
                  //               onPressed: () => {
                  //                     _fetchproduct(
                  //                         _product_search_controller.text)
                  //                   },
                  //               child: Icon(Icons.search)),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: _stock_list.isEmpty
                        ? Center(
                            child: Text('No Data'),
                          )
                        : ListView.builder(
                            itemCount: _stock_list.length,
                            itemBuilder: (BuildContext ctx, index) {
                              //
                              var quantity_stock =
                                  _stock_list[index]['unit_quantity'];

                              // Parse the string to a double
                              double convert_double_stock =
                                  double.parse(quantity_stock);

                              // Create a NumberFormat instance to format as an integer
                              NumberFormat formatter =
                                  NumberFormat.decimalPattern();

                              // Format the double as an integer (no decimal points)
                              String formattedstock =
                                  formatter.format(convert_double_stock);
                              print(
                                  'Order Quanity without decimal $formattedstock');
                              return Card(
                                child: ListTile(
                                  leading: InkWell(
                                    // child: Image.network(base_url +
                                    //     'assets/images/' +
                                    //     _stock_list[index]['product_image']
                                    //         .toString()),
                                    child: Image.network(
                                        'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930'),
                                    onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PhotoPreview(
                                              // url: base_url +
                                              //     'assets/images/' +
                                              //     _stock_list[index]
                                              //             ['product_image']
                                              //         .toString()
                                              url:
                                                  'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930'),
                                        ),
                                      )
                                    },
                                  ),
                                  title: Text(_stock_list[index]['name'],
                                      style: TextStyle(color: Colors.black)),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Order Quantity : ' +
                                          formattedstock.toString() +
                                          ''),
                                      // Text('Order Quantity : ' +
                                      //     _stock_list[index]['unit_quantity']
                                      //         .toString() +
                                      //     ''),
                                    ],
                                  ),
                                  // trailing: PopupMenuButton(
                                  //   itemBuilder: (context) {
                                  //     return [
                                  //       PopupMenuItem(
                                  //         value: 'update_qty',
                                  //         //wajih
                                  //         child: Text('Update Quantity'),
                                  //       ),
                                  //       PopupMenuItem(
                                  //         value: 'delete',
                                  //         child: Text('Delete'),
                                  //       )
                                  //     ];
                                  //   },
                                  //   onSelected: (String value) {
                                  //     if (value == 'update_qty') {
                                  //       _update_qty_controller.text =
                                  //           _stock_list[index]['stock_quanity']
                                  //               .toString();
                                  //       showModalBottomSheet(
                                  //         isScrollControlled: true,
                                  //         shape: RoundedRectangleBorder(
                                  //             borderRadius: BorderRadius.only(
                                  //                 topLeft: Radius.circular(20),
                                  //                 topRight:
                                  //                     Radius.circular(20))),
                                  //         context: context,
                                  //         backgroundColor: Colors.white,
                                  //         builder: (context) => Padding(
                                  //           padding: EdgeInsets.only(
                                  //               bottom: MediaQuery.of(context)
                                  //                   .viewInsets
                                  //                   .bottom),
                                  //           child: SizedBox(
                                  //             height: 250,
                                  //             child: Column(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.center,
                                  //               crossAxisAlignment:
                                  //                   CrossAxisAlignment.center,
                                  //               children: [
                                  //                 Text(
                                  //                   'Update Quantity',
                                  //                   style: TextStyle(
                                  //                       fontWeight:
                                  //                           FontWeight.w500,
                                  //                       fontSize: 25,
                                  //                       color: AppColors
                                  //                           .ThemeColor),
                                  //                 ),
                                  //                 SizedBox(
                                  //                   height: 30,
                                  //                 ),
                                  //                 TextFormField(
                                  //                   style: TextStyle(
                                  //                       fontSize: 25,
                                  //                       fontWeight:
                                  //                           FontWeight.w500),
                                  //                   textAlign: TextAlign.center,
                                  //                   keyboardType:
                                  //                       TextInputType.number,
                                  //                   controller:
                                  //                       _update_qty_controller,
                                  //                   decoration: InputDecoration(
                                  //                       // contentPadding:
                                  //                       //     EdgeInsets.symmetric(
                                  //                       //         horizontal:
                                  //                       //             20),
                                  //                       // labelText:
                                  //                       //     "Update Quantity",
                                  //                       // border:
                                  //                       //     OutlineInputBorder(), //label text of field
                                  //                       ),
                                  //                 ),
                                  //                 SizedBox(
                                  //                   height: 20,
                                  //                 ),
                                  //                 SizedBox(
                                  //                   height: 10,
                                  //                 ),
                                  //                 ElevatedButton(
                                  //                   onPressed: () {
                                  //                     setState(() {
                                  //                       _stock_list[index][
                                  //                               'stock_quanity'] =
                                  //                           _update_qty_controller
                                  //                               .text;
                                  //                     });
                                  //                     Navigator.pop(context);
                                  //                   },
                                  //                   child: Text('Update'),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       );
                                  //     }
                                  //     if (value == 'delete') {
                                  //       setState(() {
                                  //         _stock_list.removeWhere((element) =>
                                  //             element['id'] ==
                                  //             _product[index]['id']);
                                  //       });
                                  //     }
                                  //   },
                                  // ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     List my_arr = [];
      //     for (var i = 0; i < _stock_list.length; i++) {
      //       Map single = {
      //         "product_id": _stock_list[i]['product_id'],
      //         "quantity": _stock_list[i]['stock_quanity']
      //       };
      //       my_arr.add(single);
      //     }

      //     print(my_arr);r
      //       // print(_stock_for_api);
      //       final String jsonProduct = json.encode(my_arr);
      //       var res = await api.add_stock(
      //           (widget.type == 'customer')
      //               ? customer_id.toString()
      //               : retailer_id.toString(),
      //           created_by.toString(),
      //           jsonProduct);
      //       print('Add Stock $res');
      //       if (res['code_status'] == true) {
      //         AwesomeDialog(
      //           context: context,
      //           dialogType: DialogType.success,
      //           animType: AnimType.rightSlide,
      //           title: 'Success',
      //           desc: 'Stock Updated Successfullyy',
      //           // btnCancelOnPress: () {},
      //           btnOkOnPress: () {
      //             if (widget.type == 'customer') {
      //               Navigator.pushReplacement(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => CustomerVisit(),
      //                 ),
      //               );
      //               // Navigator.pushNamed(context, '/customer_visit');
      //             } else {
      //               Navigator.pushReplacement(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => RetailerVisit(),
      //                 ),
      //               );
      //             }
      //           },
      //         )..show();
      //       }
      //     } else {
      //       AwesomeDialog(
      //         context: context,
      //         dialogType: DialogType.error,
      //         animType: AnimType.rightSlide,
      //         title: 'Error',
      //         desc: 'Invalid Data',
      //         // btnCancelOnPress: () {},
      //         btnOkOnPress: () {},
      //       )..show();
      //     }
      //     // Add your onPressed code here!
      //   },
      //   child: const Icon(Icons.check),
      // ),
    );
  }

  show_modal(context, _arr, type) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        reset() {
          setState(() {
            _arr = [];
          });
        }

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text('Products'),
                centerTitle: true,
                actions: [
                  InkWell(
                    onTap: () => {
                      if (_search_controller.text.isEmpty) {reset()} else {}
                    },
                    child: Icon(Icons.search),
                  ),
                ],
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
                        if (_search_controller.text.isEmpty ||
                            _arr[index]['name']
                                .toString()
                                .toLowerCase()
                                .contains(_search_controller.text)) {
                          return InkWell(
                            onTap: () {
                              if (_arr[index]['name'] != null) {
                                setState(() {
                                  _product_controller.text =
                                      _arr[index]['name'].toString();
                                  product_id =
                                      _arr[index]['product_id'].toString();
                                  product_name = _arr[index]['name'].toString();
                                  product_barcode =
                                      _arr[index]['product_barcode'].toString();
                                  product_quantity = '0';
                                  // customer = _customer[index]['id']!;
                                });
                              }
                              Navigator.pop(context);
                            },
                            child: Card(
                              child: ListTile(
                                leading: InkWell(
                                  child: Image.network(base_url +
                                      '' +
                                      _arr[index]['product_image'].toString()),
                                  onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PhotoPreview(
                                            url: base_url +
                                                '' +
                                                _arr[index]['product_image']
                                                    .toString()),
                                      ),
                                    )
                                  },
                                ),
                                title: Text(_arr[index]['name']),
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
    created_by = prefs.getString('user_id');
    customer_id = prefs.getString('customer_visit_id');
    retailer_id = prefs.getString('retailer_visit_id');
    setState(() {});
  }
}
