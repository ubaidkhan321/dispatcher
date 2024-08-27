import 'package:flutter/material.dart';
import 'payment.dart';
import 'order_details.dart';
import '../../helpers/globals.dart';
import '../../helpers/api.dart';
// for using HttpClient
import 'dart:convert'; // for using json.decode()
import 'package:http/http.dart' as http;

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List _orders = [];
  var secret = globals.secret_key;
  bool _isLoading = false;
  Future<void> _fetchData() async {
    var res = await api.get_orders('', '', '', '');
    if (res['code_status'] == true) {
      setState(
        () {
          _orders = res['bookings'];
        },
      );
    }
  }

  // Future<void> _fetchData() async {
  //   const apiUrl =
  //       'https://rhotrack.rholabproducts.com/api/mobileapp/salesorders/orders';
  //   final response = await http.post(Uri.parse(apiUrl),
  //       encoding: Encoding.getByName('utf8'),
  //       headers: {
  //         "Accept": "application/json",
  //         "Content-Type": "application/x-www-form-urlencoded"
  //       },
  //       body: {
  //         "secret_key": secret
  //       });

  //   final data = json.decode(response.body);
  //   // print(data);
  //   if (data['code_status'] == true) {
  //     setState(() {
  //       _orders = data['bookings'];
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var popup = PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'Collect Payment',
            child: Text('Payment'),
          )
        ];
      },
      onSelected: (String value) {
        // if (value == 'Collect Payment') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Payment(order_id: "1"),
          ),
        );
        // }
      },
    );
    if (_orders.isEmpty) {
      _fetchData();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Orders'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _orders.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (BuildContext ctx, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetails(
                                id: _orders[index]['order_id'].toString()),
                          ));
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.inventory_2),
                        trailing: popup,
                        title: Text(_orders[index]['order_no']),
                        subtitle: Text(_orders[index]["supplier_name"]),
                      ),
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context,
              '/select_order_product'); // Add your onPressed code here!
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
