import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:linear/screens/order_booker/retailer_visit.dart';
import '../helpers/api.dart';
import '../helpers/location.dart';
import '../helpers/map_util.dart';
import '../screens/order_booker/customer_visit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RetailerSearch extends StatefulWidget {
  final List arr;
  final TextEditingController controller;
  final TextEditingController id;
  final TextEditingController caption;
  final String route_id;
  final String distributor_id;
  const RetailerSearch({
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

class _RetailerSearchState extends State<RetailerSearch> {
  @override
  List _customer = [];
  bool _saving = false;
  TextEditingController _search_controller = new TextEditingController();

  Future<void> _fetchCustomer(text) async {
    setState(() {
      _saving = true;
    });
    String routes_id_ = await widget.route_id;
    var res = await api.get_customers(
        '', '', text.toString(), routes_id_.toString(), '2', '', '');
    print(res);
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
            child: Icon(Icons.search),
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
                    onTap: () async {
                      setState(() {
                        _saving = true;
                      });
                      if (_customer[index]['name'] != null) {
                        var get_details = await api.get_customer_by_id(
                            _customer[index]['id'].toString());
                        print('Reailer Search $get_details');
                        setState(() {
                          RetailerVisit();
                        });
                        if (get_details['code_status'] == true) {
                          setState(() {
                            _saving = false;
                          });
                          var latitude =
                              get_details['customers'][0]['latitude'];
                          var longitude =
                              get_details['customers'][0]['longitude'];

                          // print(latitude);
                          if (latitude == '0') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.rightSlide,
                              title: 'Info',
                              // desc: 'Please Pin Your Loaction for this Shop',
                              desc: 'Loaction is Pinned for this Shop',
                              descTextStyle: TextStyle(color: Colors.black),
                              // btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                setState(() {
                                  _saving = true;
                                });
                                var location = await get_location();
                                if (location != false) {
                                  var update_cordinates =
                                      await api.update_cordinates(
                                          _customer[index]['id'].toString(),
                                          location['lat'].toString(),
                                          location['long'].toString());
                                  print(update_cordinates);
                                  if (update_cordinates['code_status'] ==
                                      true) {
                                    setState(() {
                                      _saving = false;
                                    });
                                    widget.controller.text =
                                        _customer[index]['name'];
                                    widget.caption.text =
                                        _customer[index]['name'];
                                    widget.id.text =
                                        _customer[index]['id'].toString();
                                    Navigator.pop(context);
                                  }
                                } else {
                                  setState(() {
                                    _saving = false;
                                  });
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Info',
                                    desc:
                                        'Please Enbale Location From settings',
                                    // btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                  )..show();
                                }
                              },
                            )..show();
                          } else {
                            setState(() {
                              _saving = false;
                            });
                            setState(() {
                              widget.controller.text = _customer[index]['name'];
                              widget.caption.text = _customer[index]['name'];
                              widget.id.text =
                                  _customer[index]['id'].toString();
                            });
                            Navigator.pop(context);
                          }
                        }
                      }
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
