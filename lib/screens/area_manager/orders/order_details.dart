import 'package:flutter/material.dart';
import '../../../helpers/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderDetails extends StatefulWidget {
  final String id;
  const OrderDetails({Key? key, required this.id}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Map _complains = {};
  var secret = globals.secret_key;
  bool _isLoading = false;
  var _order = [];
  var items = [];
  Future<void> _fetchData() async {
    const apiUrl = 'https://rholabproducts.com/api/mobileapp/salesorders/order';
    // const apiUrl =
    //     'https://rhotrack.rholabproducts.com/api/mobileapp/salesorders/order';
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
    print(widget.id);
    // print('Data is here');
    if (data['code_status'] == true) {
      setState(() {
        _complains['data'] = data['order'];
        print(_complains);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
