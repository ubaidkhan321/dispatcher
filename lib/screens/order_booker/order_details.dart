import 'package:flutter/material.dart';
import '../../helpers/globals.dart';
import 'dart:convert'; // for using json.decode()
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class OrderDetails extends StatefulWidget {
  final String id;

  const OrderDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Map _complains = {};
  var secret = globals.secret_key;
  bool _isLoading = false;
  var _order = [];
  var items = [];
  Future<void> _fetchData() async {
    // const apiUrl =
    //     'https://demo-rhotrack.rholabproducts.com/api/mobileapp/salesorders/order';

    const apiUrl = 'https://rholabproducts.com/api/mobileapp/salesorders/order';
    // const apiUrl =
    // 'https://rhotrack.rholabproducts.com/api/mobileapp/salesorders/order';
    final response = await http.post(Uri.parse(apiUrl),
        encoding: Encoding.getByName('utf8'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          "secret_key": secret,
          "id": widget.id
        });

    final data = json.decode(response.body);
    print(data);
    print('Wajih Resonse $response');
    print('Wajih data $data');
    print(data['order']);
    print(data['order']);
    // print('Data is here');
    if (data['code_status'] == true) {
      setState(() {
        _complains['data'] = data['order'];
        // print('Complains DATA $_');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var popup = PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          )
        ];
      },
      onSelected: (String value) {
        print('You Click on po up menu item');
      },
    );

    if (_complains.isEmpty) {
      _fetchData();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Orders Details'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
              // onSelected: handleClick,
              itemBuilder: (BuildContext context) {
            return {'Add New Order', 'Edit Order'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          }, onSelected: (String value) {
            if (value == 'Add New Order') {
              Navigator.pushNamed(context, '/select_order_product');
            }
          }),
        ],
      ),
      body: _complains.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Customer Info"),
                      subtitle: Text('Name : ' +
                          _complains['data']['customer_name'] +
                          ' \nEmail : ' +
                          _complains['data']['customer_email'] +
                          ' \nPhone : ' +
                          _complains['data']['customer_phone'] +
                          ''),
                    ),
                  ),
                ),
                Container(
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.supervised_user_circle),
                      title: Text("Supplier Info"),
                      subtitle: Text(
                          'Name : ' + _complains['data']['supplier_name'] + ''),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _complains['data']['items'].length,
                      itemBuilder: (BuildContext ctx, index) {
                        return InkWell(
                          onTap: () {},
                          child: Card(
                            child: ListTile(
                              leading: Icon(Icons.inventory_2),
                              title: Text(_complains['data']['items'][index]
                                  ['product_name']),
                              subtitle: Text(_complains['data']['items'][index]
                                  ["product_barcode"]),
                            ),
                          ),
                        );
                      }),
                  // child: ListView(
                  //   scrollDirection: Axis.vertical,
                  //   shrinkWrap: true,
                  //   children: [
                  //     Card(
                  //       child: ListTile(
                  //         leading: Icon(Icons.inventory_2),
                  //         title: Text('Product No 01'),
                  //         subtitle: Text('Product No 02'),
                  //         trailing: popup,
                  //         dense: true,
                  //       ),
                  //     ),
                  //     Card(
                  //       child: ListTile(
                  //         leading: Icon(Icons.inventory_2),
                  //         title: Text('Product No 01'),
                  //         subtitle: Text('Product No 02'),
                  //         trailing: popup,
                  //         dense: true,
                  //       ),
                  //     ),
                  //     Card(
                  //       child: ListTile(
                  //         leading: Icon(Icons.inventory_2),
                  //         title: Text('Product No 01'),
                  //         subtitle: Text('Product No 02'),
                  //         trailing: popup,
                  //         dense: true,
                  //       ),
                  //     ),
                  //     Card(
                  //       child: ListTile(
                  //         leading: Icon(Icons.inventory_2),
                  //         title: Text('Product No 01'),
                  //         subtitle: Text('Product No 02'),
                  //         trailing: popup,
                  //         dense: true,
                  //       ),
                  //     ),
                  //     Card(
                  //       child: ListTile(
                  //         leading: Icon(Icons.inventory_2),
                  //         title: Text('Product No 01'),
                  //         subtitle: Text('Product No 02'),
                  //         trailing: popup,
                  //         dense: true,
                  //       ),
                  //     ),
                  //     Card(
                  //       child: ListTile(
                  //         leading: Icon(Icons.inventory_2),
                  //         title: Text('Product No 01'),
                  //         subtitle: Text('Product No 02'),
                  //         trailing: popup,
                  //         dense: true,
                  //       ),
                  //     ),
                  //     Card(
                  //       child: ListTile(
                  //         leading: Icon(Icons.inventory_2),
                  //         title: Text('Product No 01'),
                  //         subtitle: Text('Product No 02'),
                  //         trailing: popup,
                  //         dense: true,
                  //       ),
                  //     ),
                  //     Card(
                  //       child: ListTile(
                  //         leading: Icon(Icons.inventory_2),
                  //         title: Text('Product No 01'),
                  //         subtitle: Text('Product No 02'),
                  //         trailing: popup,
                  //         dense: true,
                  //       ),
                  //     )
                  //   ],
                  // ),
                ),
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Total"),
                      subtitle: Text('Total Items : ' +
                          _complains['data']['items'].length.toString()),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
