import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linear/screens/orders/add_order.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helpers/api.dart';
import '../../../helpers/location.dart';
import 'order_details.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  bool _saving = false;
  List _orders = [];
  bool _fetch_status = false;
  String? order_booker_id = "";
  Future<void> _fetchData(String user_id) async {
    setState(() {
      _saving = true;
    });
    try {
      var res = await api.get_orders('', '', '', user_id).timeout(
            Duration(seconds: 10),
          );
      if (res['code_status'] == true) {
        setState(
          () {
            _orders = res['bookings'];
            setState(() {
              _saving = false;
            });
          },
        );
      } else {
        setState(() {
          _saving = false;
        });
      }
    } on TimeoutException catch (e) {
      show_msg('error', 'Connection Timeout', context);
      setState(() {
        _saving = false;
      });
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
    super.initState();
    get_permission();
    getdata();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String order_booker_id = await _read('am_order_booker_id');
      _fetchData(order_booker_id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Orders'),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SafeArea(
          child: (_orders.isEmpty && _saving == false)
              ? Center(
                  child: Text('No data Available'),
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
                          title: Text(_orders[index]['order_no'].toString()),
                          subtitle:
                              Text(_orders[index]["supplier_name"].toString()),
                          trailing: Icon(Icons.arrow_forward),
                        ),
                      ),
                    );
                  }),
        ),
      ),
    );
  }

  getdata() async {
    final prefs = await SharedPreferences.getInstance();
    order_booker_id = prefs.getString('am_order_booker_id');
    setState(() {});
  }
}
