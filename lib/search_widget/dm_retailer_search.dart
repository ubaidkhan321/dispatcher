import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:linear/screens/delivery_person/reatiler_visit.dart';
import '../helpers/api.dart';
import '../helpers/location.dart';
import '../helpers/map_util.dart';
import '../screens/order_booker/customer_visit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class DmRetailerSearch extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController id;
  final String route_id;
  final String user_id;
  // final String date;
  // final String status;

  const DmRetailerSearch({
    Key? key,
    required this.controller,
    required this.route_id,
    required this.user_id,
    // required this.date,
    // required this.status,
    required this.id,
  }) : super(key: key);

  @override
  _DmRetailerSearchState createState() => _DmRetailerSearchState();
}

class _DmRetailerSearchState extends State<DmRetailerSearch> {
  @override
  List _customer = [];
  bool _saving = false;
  TextEditingController _search_controller = new TextEditingController();

  Future<void> _fetchCustomer(text) async {
    setState(() {
      _saving = true;
    });
    String routes_id_ = widget.route_id;
    String user_id = widget.user_id;
    // String date = widget.date;
    // String status = widget.status;
    var res = await api.get_dm_shops(user_id, routes_id_);
    print(routes_id_);
    print(user_id);
    // print(date);
    // print(status);
    print(res);
    if (res['code_status'] == true) {
      setState(() {
        _saving = false;
      });
      setState(
        () {
          _customer = res['rows'];
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
                  double lat = double.parse(_customer[index]["customer_lat"]);
                  double long = double.parse(_customer[index]["customer_log"]);
                  return InkWell(
                    onTap: () async {
                      setState(() {
                        _saving = true;
                      });
                      if (_customer[index]['customer_name'] != null) {
                        var get_details = await api.get_customer_by_id(
                            _customer[index]['customer_id'].toString());
                        // print(get_details);
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
                              desc: 'Please Pin Your Loaction for this Shop',
                              // btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                setState(() {
                                  _saving = true;
                                });
                                var location = await get_location();
                                if (location != false) {
                                  var update_cordinates =
                                      await api.update_cordinates(
                                          _customer[index]['customer_id']
                                              .toString(),
                                          location['lat'].toString(),
                                          location['long'].toString());
                                  print(
                                      'Update Co ordinates $update_cordinates');
                                  if (update_cordinates['code_status'] ==
                                      true) {
                                    setState(() {
                                      _saving = false;
                                    });
                                    widget.controller.text =
                                        _customer[index]['customer_name'];
                                    widget.id.text = _customer[index]
                                            ['customer_id']
                                        .toString();
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
                              widget.controller.text =
                                  _customer[index]['customer_name'];
                              widget.id.text =
                                  _customer[index]['customer_id'].toString();

                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => ReatilerVisit()));
                            });

                            Navigator.pop(context);
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ReatilerVisit()));
                          }
                        }
                      }
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.inventory_2),
                        title: Text(_customer[index]['customer_name']),
                        subtitle: Text(_customer[index]["customer_address"]),
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
