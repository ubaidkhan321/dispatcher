import 'package:flutter/material.dart';
import '../../helpers/globals.dart';
// for using HttpClient
import 'dart:convert'; // for using json.decode()
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'add_order.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SelectOrderProducts extends StatefulWidget {
  const SelectOrderProducts({Key? key}) : super(key: key);
  @override
  _SelectOrderProductsState createState() => _SelectOrderProductsState();
}

class _SelectOrderProductsState extends State<SelectOrderProducts> {
  List products = [];
  List _orders = [];
  final List _selected_product = [];
  var secret = globals.secret_key;
  Future<void> _fetchData() async {
    const apiUrl =
        'https://rholabproducts.com/api/mobileapp/products/listsrholab';
    final response = await http.post(Uri.parse(apiUrl),
        encoding: Encoding.getByName('utf8'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          "secret_key": secret
        });

    final data = json.decode(response.body);
    if (data['code_status'] == true) {
      setState(() {
        products = data['products'];
        var finalOrder = [];
        List<dynamic> jsonData;
        for (var order in products) {
          // order.add('selected', '1');
          order['isSelected'] = false;
          finalOrder.add(order);
          // print(order['product_id']);
          // final_order.add(order);
          // print(final_order);
        }
        _orders = finalOrder;
        // print(_orders);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Select Products'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _orders.isEmpty
            ? Center(
                child: ElevatedButton(
                  onPressed: _fetchData,
                  child: Text("Load Data"),
                ),
              )
            : ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (BuildContext ctx, index) {
                  return load_area(
                    _orders[index]['product_name'],
                    _orders[index]["product_barcode"],
                    _orders[index]["isSelected"],
                    index,
                    int.parse(_orders[index]["product_id"]),
                  );
                  // return InkWell(
                  //   onTap: () {
                  //     // Navigator.pushNamed(context, '/order_details');
                  //     // print(_orders[index]['product_id']);
                  //     _selected_product.add(_orders[index]['product_id']);
                  //   },
                  //   child: Card(
                  //     child: ListTile(
                  //       leading: Icon(Icons.inventory_2),
                  //       title: Text(_orders[index]['product_name']),
                  //       subtitle: Text(_orders[index]["product_barcode"]),
                  //       trailing:
                  //           (_selected_product.contains(_orders[index]['id']))
                  //               ? Icon(
                  //                   Icons.check_circle_outline,
                  //                   color: Colors.green,
                  //                 )
                  //               : Icon(
                  //                   Icons.check_circle_outline,
                  //                   color: Colors.black,
                  //                 ),
                  //     ),
                  //   ),
                  // );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          (_selected_product.length > 0)
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddOrder(ids: _selected_product),
                  ))
              : AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.scale,
                  dismissOnTouchOutside: false,
                  title: 'Error',
                  desc: 'Please Select Product',
                  // btnCancelOnPress: () {},
                  btnOkOnPress: () {},
                ).show();
          ;

          // Navigator.pushNamed(
          //     context, '/add_order'); // Add your onPressed code here!
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget load_area(String productName, String barcodeNumber, bool isSelected,
      int index, int id) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.inventory_2),
        title: Text(productName),
        subtitle: Text(barcodeNumber),
        trailing: (isSelected)
            ? Icon(
                Icons.delete_forever_outlined,
                color: Colors.red,
              )
            : Icon(
                Icons.add,
                color: Colors.green,
              ),
        onTap: () {
          setState(() {
            _orders[index]['isSelected'] = !_orders[index]['isSelected'];
            if (_orders[index]['isSelected'] == true) {
              String qty = '';
              showMaterialModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                builder: (context) => Center(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 100),
                        Text(
                          productName,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 50),
                        TextFormField(
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.person),
                            hintText: 'Quantity',
                            labelText: 'Quantity',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            // email = value;
                            setState(() {
                              qty = value;
                            });
                          },
                        ),
                        SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: () {
                            print("Tap On Button");
                            Map data = {'id': id, 'qty': qty};
                            _selected_product.add(data);
                            print(_selected_product);
                            Navigator.pop(context);
                          },
                          child: Text('Ok'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (_orders[index]['isSelected'] == false) {
              print("Delete Here");
              // showAlertDialog(context, _selected_product, id);
              _selected_product.removeWhere((element) => element['id'] == id);
              print(_selected_product);
            }
          });
        },
      ),
    );
    // return InkWell(
    //   onTap: () {
    //     setState(() {
    //       print(_orders[index]);
    //       _orders[index]['isSelected'] = !_orders[index]['isSelected'];
    //       if (_orders[index]['isSelected'] == true) {
    //         _selected_product.add(index);
    //       } else if (_orders[index][isSelected] == false) {
    //         _selected_product.removeWhere((element) => element == index);
    //       }
    //     });
    //     // Navigator.pushNamed(context, '/order_details');
    //     // print(_orders[index]['product_id']);
    //   },
    //   child: Card(
    //     child: ListTile(
    //       leading: Icon(Icons.inventory_2),
    //       title: Text(product_name),
    //       subtitle: Text(barcode_number),
    //       trailing: (isSelected)
    //           ? Icon(
    //               Icons.check_circle_outline,
    //               color: Colors.green,
    //             )
    //           : Icon(
    //               Icons.check_circle_outline,
    //               color: Colors.black,
    //             ),
    //     ),
    //   ),
    // );
  }
}

showAlertDialog(BuildContext context, selectproduct, id) {
  // set up the buttons

  Widget cancelButton = ElevatedButton(
    child: Text("Cancel"),
    onPressed: () {},
  );
  Widget continueButton = ElevatedButton(
    child: Text("Yes Delete It"),
    onPressed: () {
      // selectproduct.removeWhere((element) => element['id'] == id);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Are You Sure ?"),
    content: Text("You Want To Unselect This Product?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
