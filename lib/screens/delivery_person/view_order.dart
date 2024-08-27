import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:linear/const/appColors.dart';
import 'package:linear/screens/delivery_person/Remarks/remarks_screen.dart';
import 'package:linear/screens/delivery_person/Remarks/sales_return.dart';
import 'package:linear/screens/delivery_person/dp_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helpers/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../helpers/api.dart';

import 'payment_collection.dart';
import 'reatiler_visit.dart';

class ViewOrder extends StatefulWidget {
  final String payment_status;
  final String id;
  final String update_id;

  const ViewOrder(
      {Key? key,
      required this.id,
      required this.update_id,
      required this.payment_status})
      : super(key: key);

  @override
  _ViewOrderState createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  // Define the list of items
  final List<String> _dropdownItems = [
    "Hold",
    "Cancel",
    "Partial",
    "Delivered"
  ];

  // Default selected item
  String? _selectedItem;

  //
  Map _order = {};
  var secret = globals.secret_key;
  bool _isLoading = false;
  var items = [];
  String? user_id = '';

  Future<void> _fetchData(String id) async {
    print('IDDDD $id');
    var res = await api.get_single_sale(id);
    print('Order Details $res');
    if (res['code_status'] == true) {
      setState(
        () {
          _order['data'] = res['order'];
        },
      );
    } else {
      show_msg('error', res['message'], context);
    }
  }

  Future<void> _updateStatus(String id, String user_id, String status) async {
    print(id);
    var res = await api.dm_update_status(user_id, id, status);
    print('Update Status $res');
    if (res['code_status'] == true) {
      show_msg('success', res['message'], context);
    } else {
      show_msg('error', res['message'], context);
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

// Define the phone number and message
  // final String phoneNumber = "${}";
  // final String message = "Hello";
  //

  // Function to open WhatsApp
  //Open Whatsapp
  void openWhatsApp(BuildContext context, phonenumber) async {
    final Uri _url = Uri.parse("https://wa.me/$phonenumber");
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      // Show a message if WhatsApp is not installed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open WhatsApp'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user_id = await _read('user_id');
      await _fetchData(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Rebuild after pop');
    return WillPopScope(
      onWillPop: () async {
       Navigator.pop(context, true);
        return false; // Return false to prevent the default pop behavior
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context, true)
          ),
          title: Text('Orders Details'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.home, color: Colors.black),
                onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReatilerVisit(),
                      ),
                    )),
          ],
        ),
        body: _order.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Card(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  'Payment Status : ${_order['data']['payment_status'][0].toUpperCase() + _order['data']['payment_status'].substring(1)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _order['data']['payment_status'] ==
                                            "paid"
                                        ? Colors.green
                                        : _order['data']['payment_status'] ==
                                                "pending"
                                            ? Colors.amber
                                            : _order['data']['payment_status'] ==
                                                    "partial"
                                                ? Colors.orange
                                                : Colors
                                                    .black, // default color if none of the above
                                  ),
                                ),
                              )
                            ],
                          ),
                          ListTile(
                              title: Text("Customer Info"),
                              subtitle: Text('Name : ' +
                                  _order['data']['customer_name'].toString() +
                                  ' \nEmail : ' +
                                  _order['data']['customer_email'].toString() +
                                  ' \nPhone : ' +
                                  _order['data']['customer_phone'].toString() +
                                  '\nAddress : ' +
                                  _order['data']['customer_address'].toString()),
                              trailing: Column(
                                children: [
                                  // ElevatedButton(
                                  //   onPressed: () => {
                                  //     print('This is main id '),
                                  //     print(widget.update_id),
                                  //     (_order['data']['delivery_status'] ==
                                  //             "delivered")
                                  //         ? show_msg('error', 'Delivered Already',
                                  //             context)
                                  //         : _updateStatus(widget.update_id,
                                  //             user_id.toString(), 'delivered')
                                  //   },
                                  //   child: (_order['data']['delivery_status'] ==
                                  //           "delivered")
                                  //       ? Text('Delivered')
                                  //       : Text('Dispatch'),
                                  // ),

                                  // Condition For Delivery
                                  SizedBox(height: 5),
                                  _order['data']['delivery_status'] == 'delivered'
                                      ? Container(
                                          height: 30,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: AppColors.ThemeColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _order['data']['delivery_status'][0]
                                                      .toUpperCase() +
                                                  _order['data']
                                                          ['delivery_status']
                                                      .substring(1),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: DropdownButton<String>(
                                            hint: Text(
                                              _order['data']['delivery_status'][0]
                                                      .toUpperCase() +
                                                  _order['data']
                                                          ['delivery_status']
                                                      .substring(1),
                                            ),
                                            // hint: Text('Select Status'),
                                            value: _selectedItem,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectedItem = newValue!;
                                                if (_selectedItem == "Hold" ||
                                                    _selectedItem == "Cancel") {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RemarksScreen(
                                                              sale_id: widget.id,
                                                            )),
                                                  );
                                                } else if (_selectedItem ==
                                                    "Partial") {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SalesReturn(
                                                        orders: _order['data'],
                                                        sale_id: widget.id,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                            items: _dropdownItems
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.supervised_user_circle),
                        title: Text("Supplier Info"),
                        subtitle: Text(
                            'Name : ' + _order['data']['supplier_name'] + ''),
                      ),
                    ),
                  ),
                  // Somewhere in your widget build method
                  Expanded(
                    child: ListView.builder(
                      // shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: _order['data']['items'].length,
                      itemBuilder: (BuildContext ctx, index) {
                        // Get the quantity as a string
                        String quantityString =
                            _order['data']['items'][index]['quantity'];
                        // Convert the string to a double
                        double quantityDouble = double.parse(quantityString);
                        // Format the double to remove decimal points
                        String formattedQuantity =
                            NumberFormat("#,##0", "en_US").format(quantityDouble);

                        String priceString =
                            _order['data']['items'][index]['price'];
                        // Convert the string to a double
                        double priceDouble = double.parse(priceString);

                        double calculate = priceDouble * quantityDouble;
                        // Format the double to remove decimal points
                        String formattedPrice_calculate =
                            NumberFormat("#,##0", "en_US").format(calculate);

                        return InkWell(
                          onTap: () {
                            print(_order);
                          },
                          child: Card(
                            child: ListTile(
                              leading: Icon(Icons.inventory_2),
                              title: Text(
                                  _order['data']['items'][index]['product_name']),
                              subtitle: Text(_order['data']['items'][index]
                                  ['product_barcode']),
                              trailing: Column(
                                children: [
                                  Text('Quantity: $formattedQuantity'),
                                  Text('Price: $formattedPrice_calculate'),
                                  // Text('Product mrp: $priceDouble'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          color: AppColors.ThemeColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Invoice:',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                child: Text(
                                  _order['data']['order_no'],
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Balance Amount:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(_order['data']['balance'],
                                  style: TextStyle(fontSize: 18))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Amount:',
                                  style: TextStyle(fontSize: 18)),
                              Text(_order['data']['grand_total'],
                                  style: TextStyle(fontSize: 18))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Total"),
                      subtitle: Text('Total Items : ' +
                          _order['data']['items'].length.toString()),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentCollection(
                                      customer: _order['data']['customer_id'],
                                      inv_id: _order['data']['order_id'],
                                      inv_no: _order['data']['order_no'],
                                      balance_amount: _order['data']['balance'],
                                      updateID: widget.update_id,
                                      userID: user_id.toString(),
                                    )),
                          );

                          if (result == true) {
                            setState(() {
                              _fetchData(widget.id);
                              print('HELLO Rebuild');
                            });
                          }

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => PaymentCollection(
                          //       customer: _order['data']['customer_id'],
                          //       inv_id: _order['data']['order_id'],
                          //       inv_no: _order['data']['order_no'],
                          //       balance_amount: _order['data']['balance'],
                          //       updateID: widget.update_id,
                          //       userID: user_id.toString(),
                          //     ),
                          //   ),
                          // );
                          print('Hello navigator');
                          print(_order['data']['customer_id']);

                          print(_order['data']['order_id']);
                          print(_order['data']['order_no']);
                          print(_order['data']['balance']);
                          print(
                            widget.update_id,
                          );
                          print(user_id.toString());
                          //       inv_no: _order['data']['order_no'],
                          //       balance_amount: _order['data']['balance'],
                          //       updateID: widget.update_id,
                          //       userID: user_id.toString(),
                        },
                        child: Text('Collect Payment'),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          openWhatsApp(context,
                              _order['data']['customer_phone'].toString());
                        },
                        child: Text(
                          'Chat with Customer',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
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
}
