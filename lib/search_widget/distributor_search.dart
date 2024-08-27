import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../helpers/api.dart';
import '../helpers/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class DistributorSearch extends StatefulWidget {
  final List arr;
  final TextEditingController controller;
  final TextEditingController id;
  DistributorSearch(
      {Key? key, required this.arr, required this.controller, required this.id})
      : super(key: key);

  @override
  _DistributorSearchState createState() => _DistributorSearchState();
}

class _DistributorSearchState extends State<DistributorSearch> {
  @override
  List _customer = [];
  bool _saving = false;
  TextEditingController _search_controller = new TextEditingController();

  Future<void> _fetchCustomer(text) async {
    setState(() {
      _saving = true;
    });
    // EasyLoading.show(status: 'loading...');
    var res = await api.get_customers('', '', text.toString(), '', '', '', '');
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
    print(res);
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
                decoration: InputDecoration(
                  labelText: "Search Here",
                  border: OutlineInputBorder(), //label text of field
                ),
                onChanged: (value) => {
                  setState(() {
                    // search = value.toString();
                    // toggleIcon = true;
                  })
                  // setModalState(() {
                  //     search = value
                  // });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _customer.length,
                itemBuilder: (BuildContext ctx, index) {
                  return InkWell(
                    onTap: () async {
                      setState(() {
                        _saving = true;
                      });
                      // EasyLoading.show(status: 'loading...');
                      if (_customer[index]['name'] != null) {
                        var get_details = await api.get_customer_by_id(
                            _customer[index]['id'].toString());
                        // print(get_details);
                        if (get_details['code_status'] == true) {
                          // EasyLoading.dismiss();
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
                                // EasyLoading.show(status: 'loading...');
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
                            widget.controller.text = _customer[index]['name'];
                            widget.id.text = _customer[index]['id'].toString();
                            Navigator.pop(context);
                          }
                        }

                        setState(() {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => CustomerVisit(
                          //       selected_customer_id: _customer[index]['id'],
                          //       selected_customer_name: _customer[index]['name'],
                          //     ),
                          //   ),
                          // );
                          // _customer_controller.text =
                          // _customer[index]['name'].toString();
                        });
                      }
                      // Navigator.pop(context);
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.inventory_2),
                        title: Text(_customer[index]['name']),
                        subtitle: Text(_customer[index]["sales_type"]),
                      ),
                    ),
                  );
                  // if (_search_controller
                  //     .text.isEmpty) {
                  //   return InkWell(
                  //     onTap: () {
                  //       if (_customer[index]
                  //               ['name'] !=
                  //           null) {
                  //         setState(() {
                  //           _customer_controller
                  //                   .text =
                  //               _customer[index]
                  //                       ['name']
                  //                   .toString();
                  //           selected_customer =
                  //               _customer[index]
                  //                   ['id'];
                  //           // customer = _customer[index]['id']!;
                  //         });
                  //       }
                  //       Navigator.pop(context);
                  //     },
                  //     child: Card(
                  //       child: ListTile(
                  //         leading: Icon(Icons
                  //             .inventory_2),
                  //         title: Text(
                  //             _customer[index]
                  //                 ['name']),
                  //         subtitle: Text(
                  //             _customer[index][
                  //                 "sales_type"]),
                  //       ),
                  //     ),
                  //   );
                  // } else if (_customer[index]
                  //         ['name']
                  //     .toString()
                  //     .toLowerCase()
                  //     .contains(
                  //         _search_controller
                  //             .text)) {
                  //   return InkWell(
                  //     onTap: () {
                  //       if (_customer[index]
                  //               ['name'] !=
                  //           null) {
                  //         setState(() {
                  //           _customer_controller
                  //                   .text =
                  //               _customer[index]
                  //                       ['name']
                  //                   .toString();
                  //           selected_customer =
                  //               _customer[index]
                  //                   ['id'];
                  //           // customer = _customer[index]['id']!;
                  //         });
                  //       }
                  //       Navigator.pop(context);
                  //     },
                  //     child: Card(
                  //       child: ListTile(
                  //         leading: Icon(Icons
                  //             .inventory_2),
                  //         title: Text(
                  //             _customer[index]
                  //                 ['name']),
                  //         subtitle: Text(
                  //             _customer[index][
                  //                 "sales_type"]),
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   return Container();
                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
