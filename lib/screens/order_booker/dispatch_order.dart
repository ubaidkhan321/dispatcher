import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'payment.dart';
import 'order_details.dart';
import '../../helpers/globals.dart';
import '../../helpers/api.dart';
// for using HttpClient
import 'dart:convert'; // for using json.decode()
import 'package:http/http.dart' as http;

class DispatchOrder extends StatefulWidget {
  const DispatchOrder({Key? key}) : super(key: key);

  @override
  _DispatchOrderState createState() => _DispatchOrderState();
}

class _DispatchOrderState extends State<DispatchOrder> {
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

  @override
  Widget build(BuildContext context) {
    var popup = PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'Dispatch',
            child: Text('Dispatch'),
          )
        ];
      },
      onSelected: (String value) {
        if (value == 'Dispatch') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: 'Success',
            desc: 'Order Dispatch',
            // btnCancelOnPress: () {},
            btnOkOnPress: () {},
          )..show();
        }
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
        title: Text('Disptach Orders'),
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
    );
  }
}
