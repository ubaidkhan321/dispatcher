import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:linear/helpers/api.dart';
import 'package:linear/helpers/location.dart';
import 'package:linear/helpers/map_util.dart';
import 'package:linear/screens/order_booker/edit_customer.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RetailerLstOrdHis extends StatefulWidget {
  final List arr;
  final TextEditingController controller;
  final TextEditingController id;
  final TextEditingController caption;
  final String route_id;
  final String distributor_id;

  const RetailerLstOrdHis({
    Key? key,
    required this.arr,
    required this.controller,
    required this.id,
    required this.route_id,
    required this.distributor_id,
    required this.caption,
  }) : super(key: key);

  @override
  _RetailerSearchState createState() => _RetailerSearchState();
}

class _RetailerSearchState extends State<RetailerLstOrdHis> {
  TextEditingController name_controller = TextEditingController();
  TextEditingController phone_contrller = TextEditingController();
  TextEditingController email_contrller = TextEditingController();
  TextEditingController cnic_controller = TextEditingController();
  TextEditingController city_controller = TextEditingController();
  TextEditingController state_controller = TextEditingController();
  TextEditingController country_controller = TextEditingController();
  TextEditingController postal_code_controller = TextEditingController();
  TextEditingController ntn_controller = TextEditingController();
  TextEditingController gst_controller = TextEditingController();
  TextEditingController address_controller = TextEditingController();
  TextEditingController customer_id_controller = TextEditingController();
  TextEditingController route_ids_controller = TextEditingController();

  var routes_id_;
  @override
  List _customer = [];
  bool _saving = false;
  TextEditingController _search_controller = new TextEditingController();

  Future<void> _fetchCustomer(text) async {
    setState(() {
      _saving = true;
    });
    routes_id_ = await widget.route_id;
    var res = await api.get_customers(
        '', '', text.toString(), routes_id_.toString(), '2', '', '');
    print('Customer Data $res');
    if (res['code_status'] == true) {
      setState(() {
        _saving = false;
      });
      setState(
        () {
          _customer = res['customers'];
        },
      );
    }
  }

  reset() {
    setState(() {
      _customer = [];
    });
  }

  Widget build(BuildContext context) {
    print('Route ID $routes_id_');
    print('Customer data wajih $_customer');
    if (_customer.isEmpty) {
      _fetchCustomer('');
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          InkWell(
            onTap: () => {
              if (_search_controller.text.isEmpty)
                {reset()}
              else
                {_fetchCustomer(_search_controller.text)}
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _search_controller,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Search Here",
                  border: OutlineInputBorder(), //label text of field
                ),
                onChanged: (value) => {},
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _customer.length,
                itemBuilder: (BuildContext ctx, index) {
                  double lat = double.parse(_customer[index]["latitude"]);
                  double long = double.parse(_customer[index]["longitude"]);
                  return InkWell(
                    onTap: () {
                      print('Customer name ${_customer[index]['name']}');
                      print('Customer Phone ${_customer[index]['phone']}');
                      print('Customer City ${_customer[index]['city']}');
                      print("Customer Cnic ${_customer[index]['cnic']}");

                      name_controller.text = _customer[index]['name'];
                      phone_contrller.text = _customer[index]['phone'];
                      email_contrller.text = _customer[index]['email'];
                      cnic_controller.text = _customer[index]['cnic'];
                      address_controller.text =
                          _customer[index]['address'] ?? '';
                      city_controller.text = _customer[index]['city'] ?? '';
                      state_controller.text = _customer[index]['state'] ?? '';
                      country_controller.text =
                          _customer[index]['country'] ?? '';
                      postal_code_controller.text =
                          _customer[index]['postal_code'] ?? '';
                      gst_controller.text = _customer[index]['gst_no'] ?? '';
                      ntn_controller.text = _customer[index]['cf1'] ?? '';
                      customer_id_controller.text =
                          _customer[index]['id'] ?? '';
                      route_ids_controller.text =
                          _customer[index]['route_id'] ?? '';

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => EditCustomer(
                                    retailer_name_controller: name_controller,
                                    retailer_phone_controller: phone_contrller,
                                    retailer_cnic_controller: cnic_controller,
                                    retailer_email_controller: email_contrller,
                                    retailer_address_controller:
                                        address_controller,
                                    retailer_city_controller: city_controller,
                                    retailer_state_controller: state_controller,
                                    retailer_country_controller:
                                        country_controller,
                                    retailer_postalcode_controller:
                                        postal_code_controller,
                                    retailer_gst_controller: gst_controller,
                                    retailer_ntn_controller: ntn_controller,
                                    retailer_id_controller:
                                        customer_id_controller,
                                    retailer_route_id_controller:
                                        route_ids_controller,
                                  ))));
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.inventory_2),
                        title: Text(
                          _customer[index]['name'],
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          _customer[index]["sales_type"],
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: InkWell(
                          onTap: () => {
                            if (lat > 0)
                              {MapUtils.navigateTo(lat, long)}
                            else
                              {show_msg('error', 'Invalid Location', context)}
                          },
                          child: Icon(
                            Icons.location_on,
                            color: Colors.green,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
