import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helpers/api.dart';
import '../../../helpers/location.dart';
import 'payment_details.dart';

class PaymentList extends StatefulWidget {
  const PaymentList({Key? key}) : super(key: key);

  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  List _payment = [];
  bool _saving = false;
  String? order_booker_id = "";
  Future<void> _fetchData(String user_id) async {
    try {
      var res = await api.get_payment_list('', '', '', '', '', user_id).timeout(
            Duration(seconds: 10),
          );
      if (res['code_status'] == true) {
        setState(
          () {
            _payment = res['rows'];
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
    // if (_payment.isEmpty) {
    //   _fetchData(order_booker_id.toString());
    // }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Payments'),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SafeArea(
          child: (_payment.isEmpty && _saving == false)
              ? Center(
                  child: Text('No data Available'),
                )
              : ListView.builder(
                  itemCount: _payment.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentDetails(
                                  id: _payment[index]['id'].toString()),
                            ));
                      },
                      child: Card(
                        child: ListTile(
                          leading: Icon(Icons.inventory_2),
                          title:
                              Text(_payment[index]['reference_no'].toString()),
                          subtitle: Text(_payment[index]["amount"].toString()),
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
