// import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/location.dart';
import 'package:battery_plus/battery_plus.dart';
import '../../helpers/api.dart';
import '../../search_widget/dm_retailer_search.dart';
import '../../search_widget/retailer_search.dart';
import 'order_list.dart';
import 'payment_collection.dart';

class ReatilerVisit extends StatefulWidget {
  final route_id;
  final route_name;
  const ReatilerVisit({Key? key, this.route_id, this.route_name})
      : super(key: key);

  @override
  _ReatilerVisitState createState() => _ReatilerVisitState();
}

class _ReatilerVisitState extends State<ReatilerVisit> {
  bool _saving = false;
  TextEditingController _customer_controller = new TextEditingController();
  TextEditingController _customer_id_controller = new TextEditingController();
  TextEditingController _assign_routes_id_controller =
      new TextEditingController();
  TextEditingController _assign_routes_controller = new TextEditingController();

  TextEditingController _caption_controller = new TextEditingController();

  var locationss;
  var get_batteries;
  var set_punches;

  var battery = Battery();

  String? user_id = '';
  bool? retailer_visit_puched = false;
  String? retailer_visit_name = '';
  String? retailer_visit_id = '';
  String? user_name = '';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user_id = await _read('user_id');
      _assign_routes_id_controller.text = widget.route_id;
      _assign_routes_controller.text = widget.route_name;
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
        title: Image(
          height: 30,
          fit: BoxFit.contain,
          image: AssetImage(
            'assets/images/distrho_logo.png',
          ),
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // height: double.infinity,

              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              // width: 200,
                              child: (_customer_controller.text.isEmpty)
                                  ? Center(
                                      child: Text(
                                      'Please Select Customer',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ))
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "You are Visiting At",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(_customer_controller.text)
                                      ],
                                    ),
                            ),
                            // SizedBox(
                            //   width: 100,
                            //   child: InkWell(
                            //     onTap: () async {
                            //       if (_customer_controller.text.isEmpty) {
                            //         show_msg('error', 'Please Select Customer',
                            //             context);
                            //       } else {
                            //         setState(() {
                            //           _saving = true;
                            //         });
                            //         var location = await get_location();
                            //         if (location != false) {
                            //           var get_bettery =
                            //               await battery.batteryLevel;
                            //           var set_punched = await api.set_punched(
                            //             user_id.toString(),
                            //             location['lat'].toString(),
                            //             location['long'].toString(),
                            //             location['lat'].toString(),
                            //             location['long'].toString(),
                            //             get_bettery.toString(),
                            //             '3',
                            //             '',
                            //             _customer_id_controller.text,
                            //             (retailer_visit_puched == true)
                            //                 ? '0'
                            //                 : '1',
                            //           );
                            //           if (set_punched['code_status'] == true) {
                            //             setState(() {
                            //               _saving = false;
                            //             });
                            //             if (retailer_visit_puched == true) {
                            //               show_msg(
                            //                   'success',
                            //                   'Sucessfully Punched Out',
                            //                   context);
                            //             } else {
                            //               show_msg(
                            //                   'success',
                            //                   'Sucessfully Punched In',
                            //                   context);
                            //             }

                            //             setState(() {
                            //               if (retailer_visit_puched == true) {
                            //                 retailer_visit_puched = false;
                            //               } else {
                            //                 retailer_visit_puched = true;
                            //               }
                            //             });

                            //             setdata(retailer_visit_puched);
                            //             setcustdata(_customer_controller.text,
                            //                 _customer_id_controller.text);
                            //           } else {
                            //             setState(() {
                            //               _saving = false;
                            //             });
                            //             show_msg('error',
                            //                 set_punched['message'], context);
                            //           }
                            //         } else {
                            //           setState(() {
                            //             _saving = false;
                            //           });
                            //           show_msg(
                            //               'error',
                            //               'Location Blocked Please Enable',
                            //               context);
                            //         }
                            //       }
                            //     },
                            //     child: Image(
                            //       height: 100,
                            //       fit: BoxFit.contain,
                            //       image: (retailer_visit_puched == true)
                            //           ? AssetImage(
                            //               'assets/images/punched_in.png',
                            //             )
                            //           : AssetImage(
                            //               'assets/images/punched_out.png',
                            //             ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SizedBox(
                        child: TextFormField(
                          controller: _assign_routes_controller,
                          readOnly: true,
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.person),
                            hintText: 'Your Routes',
                            labelText: 'Assigned Routes',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {},
                          validator: (value) {},
                          onTap: () => {},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SizedBox(
                        child: TextFormField(
                          controller: _customer_controller,
                          readOnly: true,
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.person),
                            hintText: 'Select Retailer',
                            labelText: 'Customer Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              // email = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "reatiler  Is Required";
                            }
                            return null;
                          },
                          onTap: () => {
                            if (retailer_visit_puched == true)
                              {
                                print('Please Punch out'),
                                show_msg('error', 'Please Punch Out', context)
                              }
                            else
                              {
                                // print("IDS : " + session_distributor.toString()),
                                // print("Routes : " + session_route_id.toString()),

                                showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      var now = new DateTime.now();
                                      var inputFormat =
                                          DateFormat('yyyy-MM-dd');
                                      String formattedDate =
                                          inputFormat.format(now);
                                      print("The user Id");
                                      print(user_id);
                                      return DmRetailerSearch(
                                        controller: _customer_controller,
                                        id: _customer_id_controller,
                                        route_id:
                                            _assign_routes_id_controller.text,
                                        user_id: user_id.toString(),
                                        // date: formattedDate,
                                        // status: '',
                                      );
                                    }).then((value) => setState(() {}))
                              },
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xff87C440),
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            width:
                                (MediaQuery.of(context).size.width - 50) / 3 -
                                    10,
                            // color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: () async => {
                                  if (retailer_visit_puched == false)
                                    {
                                      if (_customer_controller.text.isEmpty)
                                        {
                                          show_msg(
                                              'error',
                                              'Please Select Customer',
                                              context),
                                        }
                                      else
                                        {
                                          locationss = await get_location(),
                                          if (locationss != false)
                                            {
                                              get_batteries =
                                                  await battery.batteryLevel,
                                              set_punches =
                                                  await api.set_punched(
                                                user_id.toString(),
                                                locationss['lat'].toString(),
                                                locationss['long'].toString(),
                                                locationss['lat'].toString(),
                                                locationss['long'].toString(),
                                                get_batteries.toString(),
                                                '3',
                                                '',
                                                _customer_id_controller.text,
                                                // (retailer_visit_puched == true)
                                                //     ? '0'
                                                //     : '1',
                                                '0',
                                              ),
                                              setcustdata(
                                                  _customer_controller.text,
                                                  _customer_id_controller.text),
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => OrderList(
                                                      route_id: widget.route_id,
                                                      retailer_id:
                                                          _customer_id_controller
                                                              .text),
                                                ),
                                              )
                                            }
                                        },
                                    }
                                  else
                                    {
                                      show_msg(
                                          'error', "Please Punch In", context)
                                    }
                                },
                                child: Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/shape.svg',
                                        width: 50,
                                        height: 50,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text('Invoices'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xff87C440),
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            width:
                                (MediaQuery.of(context).size.width - 50) / 3 -
                                    10,
                            child: InkWell(
                              onTap: () async => {
                                if (retailer_visit_puched == false)
                                  {
                                    if (_customer_controller.text.isEmpty)
                                      {
                                        show_msg('error',
                                            'Please Select Customer', context),
                                      }
                                    else
                                      {
                                        locationss = await get_location(),
                                        if (locationss != false)
                                          {
                                            get_batteries =
                                                await battery.batteryLevel,
                                            set_punches = await api.set_punched(
                                              user_id.toString(),
                                              locationss['lat'].toString(),
                                              locationss['long'].toString(),
                                              locationss['lat'].toString(),
                                              locationss['long'].toString(),
                                              get_batteries.toString(),
                                              '3',
                                              '',
                                              _customer_id_controller.text,
                                              // (retailer_visit_puched == true)
                                              //     ? '0'
                                              //     : '1',
                                              '0',
                                            ),
                                            setcustdata(
                                                _customer_controller.text,
                                                _customer_id_controller.text),
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentCollection(
                                                  updateID: '',
                                                  userID: '',
                                                ),
                                              ),
                                            )
                                          }
                                      },
                                  }
                                else
                                  {
                                    show_msg(
                                        'error', "Please Punch In", context)
                                  }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/order.svg',
                                        width: 50,
                                        height: 50,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text('Payment'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getdata() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    user_name = prefs.getString('user_name');
    retailer_visit_puched = prefs.getBool('retailer_visit_punch');
    retailer_visit_id = prefs.getString('retailer_visit_id');
    retailer_visit_name = prefs.getString('retailer_visit_name');
    setState(() {});
  }

  Future<void> setdata(setValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('retailer_visit_punch', setValue);
  }

  Future<void> setcustdata(cust_name, cust_id) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString('retailer_visit_name', cust_name);
    pref.setString('retailer_visit_id', cust_id);
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
