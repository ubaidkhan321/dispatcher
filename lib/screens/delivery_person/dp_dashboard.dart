import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import 'package:linear/screens/delivery_person/payment_collection.dart';
import 'package:linear/screens/delivery_person/reatiler_visit.dart';
import 'package:linear/screens/snackbar.dart';
import '../../widgets/drawer_navigate.dart';
import '../../helpers/location.dart';
import '../../helpers/api.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'route_list.dart';

class DpDashboard extends StatefulWidget {
  const DpDashboard({Key? key}) : super(key: key);
  @override
  _DpDashboardState createState() => _DpDashboardState();
}

class _DpDashboardState extends State<DpDashboard> {
  bool isLoading = false;
  bool _saving = false;
  int status = 0;
  late DateTime dt;
  var show_date = '';
  String? email = '';
  String? user_id = '';
  String? user_name = '';
  bool? puched_in = false;
  bool? cust_puch = false;
  bool? routes_puched = false;
  bool? customer_visit_punch = false;
  bool? retailer_visit_punch = false;
  var locationss;
  var get_betterys;

  double pending = 0;
  double delivered = 0;
  double cancel = 0;
  double total = 0;
  var battery = Battery();
  var set_punchedss;

  Map _targets = {};
  Future<void> _fetchData(user_id) async {
    setState(() {
      isLoading = true;
    });
    pending = 0;
    delivered = 0;
    cancel = 0;
    total = 0;
    var now = new DateTime.now();
    var inputFormat = DateFormat('yyyy-MM-dd');
    String formattedDate = inputFormat.format(now);
    var res =
        await api.get_dp_targets(user_id.toString(), formattedDate.toString());
    print('res:$res');
    if (res['code_status'] == true) {
      setState(
        () {
          if (res['rows'].isNotEmpty) {
            _targets = res['rows'][0];
            pending = double.parse(
                _targets['pending'] == null ? '0' : '${_targets['pending']}');
            pending = double.parse(pending.toStringAsFixed(2));

            delivered = double.parse(_targets['delivered'] == null
                ? '0'
                : '${_targets['delivered']}');
            delivered = double.parse(delivered.toStringAsFixed(2));

            cancel = double.parse(
                _targets['cancel'] == null ? '0' : '${_targets['cancel']}');
            cancel = double.parse(cancel.toStringAsFixed(2));
            print('cancel:$cancel');

            total = double.parse(
                _targets['total'] == null ? '0' : '${_targets['total']}');
            total = double.parse(total.toStringAsFixed(2));
            print(_targets);
          }
        },
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  static _read(thekey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = thekey.toString();
    final value = prefs.getString(key);
    print('saved tester dp_dashboard.dart $value');
    String usu = (value != null ? value : '');
    return usu;
  }

  @override
  void initState() {
    super.initState();
    get_permission();
    getdata();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String my_user = await _read('user_id');
      _fetchData(my_user);
    });
    // _fetchData(user_id);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff87C440),
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
                // width: 350,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          // height: 200,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xff87C440),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              boxShadow: [
                                //BoxShadow
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: const Offset(0.0, 5.0),
                                  blurRadius: 4.0,
                                  spreadRadius: 0.2,
                                ), //BoxShadow
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 160,
                                  // width: 200,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  10, 15, 0, 0),
                                              child: Image(
                                                width: 70,
                                                image: AssetImage(
                                                  'assets/images/man1.png',
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 38,
                                            // ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.50,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(30),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Welcome'),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      user_name.toString(),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: Color(
                                                              0xffb4003c)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                //   child: InkWell(
                                //     onTap: () async {
                                //       setState(() {
                                //         _saving = true;
                                //       });
                                //       // EasyLoading.show(status: 'loading...');

                                //       var get_bettery =
                                //           await battery.batteryLevel;

                                //       await getdata();
                                //       var location = await get_location();
                                //       print('Location is : ');
                                //       print(location);
                                //       if (puched_in == true &&
                                //           customer_visit_punch == true) {
                                //         setState(() {
                                //           _saving = false;
                                //         });
                                //         showInSnackBar(
                                //             'Please Punch Out From Customer Visit');
                                //         Navigator.pushNamed(
                                //             context, '/customer_visit');
                                //         // AwesomeDialog(
                                //         //   context: context,
                                //         //   dialogType: DialogType.success,
                                //         //   animType: AnimType.rightSlide,
                                //         //   title: 'Error',
                                //         //   desc:
                                //         //       'Please Punch Out From Customer Visit',
                                //         //   // btnCancelOnPress: () {},
                                //         //   btnOkOnPress: () {
                                //         //     Navigator.pushNamed(
                                //         //         context, '/customer_visit');
                                //         //   },
                                //         // )..show();

                                //         return;
                                //       }
                                //       if (puched_in == true &&
                                //           routes_puched == true) {
                                //         setState(() {
                                //           _saving = false;
                                //         });
                                //         showInSnackBar(
                                //             'Please Punch Out From Routes');
                                //         Navigator.pushNamed(
                                //             context, '/routes_punch');
                                //         // AwesomeDialog(
                                //         //   context: context,
                                //         //   dialogType: DialogType.success,
                                //         //   animType: AnimType.rightSlide,
                                //         //   title: 'Error',
                                //         //   desc: 'Please Punch Out From Routes',
                                //         //   // btnCancelOnPress: () {},
                                //         //   btnOkOnPress: () {
                                //         //     Navigator.pushNamed(
                                //         //         context, '/routes_punch');
                                //         //   },
                                //         // )..show();

                                //         return;
                                //       }
                                //       if (location != false) {
                                //         print(location);
                                //         // if (cust_puch == true) {
                                //         //   EasyLoading.dismiss();
                                //         //   show_msg('error', 'Please Punch Out From Route',
                                //         //       context);
                                //         // } else {
                                //         var set_punched = await api.set_punched(
                                //           user_id.toString(),
                                //           location['lat'].toString(),
                                //           location['long'].toString(),
                                //           location['lat'].toString(),
                                //           location['long'].toString(),
                                //           get_bettery.toString(),
                                //           '1',
                                //           '',
                                //           '',
                                //           (puched_in == true) ? '0' : '1',
                                //         );
                                //         if (set_punched['code_status'] ==
                                //             true) {
                                //           setState(() {
                                //             _saving = false;
                                //           });
                                //           if (puched_in == true) {
                                //             showInSnackBar(
                                //                 'Sucessfully Punched Out');
                                //             // show_msg(
                                //             //     'success',
                                //             //     'Sucessfully Punched Out',
                                //             //     context);
                                //           } else {
                                //             showInSnackBar(
                                //                 'Sucessfully Punched In');
                                //             // show_msg(
                                //             //     'success',
                                //             //     'Sucessfully Punched In',
                                //             //     context);
                                //           }
                                //           setState(() {
                                //             if (puched_in == true) {
                                //               puched_in = false;
                                //             } else {
                                //               puched_in = true;
                                //             }
                                //           });
                                //           setdata(puched_in);
                                //         }
                                //         // }
                                //       } else {
                                //         setState(() {
                                //           _saving = false;
                                //         });
                                //         showInSnackBar(
                                //             'Location Blocked Please Enable',
                                //             color: Colors.red);
                                //         // show_msg(
                                //         //     'error',
                                //         //     'Location Blocked Please Enable',
                                //         //     context);
                                //       }
                                //     },
                                //     child: Padding(
                                //       padding: const EdgeInsets.only(
                                //           top: 0, right: 20),
                                //       child: Column(
                                //         children: [
                                //           SizedBox(
                                //             height: 10,
                                //           ),
                                //           Image(
                                //             height: 100,
                                //             // fit: BoxFit.contain,
                                //             image: (puched_in == true)
                                //                 ? AssetImage(
                                //                     'assets/images/punched_in.png',
                                //                   )
                                //                 : AssetImage(
                                //                     'assets/images/punched_out.png',
                                //                   ),
                                //           ),
                                //           SizedBox(
                                //             height: 4,
                                //           ),
                                //           (puched_in == true)
                                //               ? Text("Please Punch Out")
                                //               : Text("Please Punch In"),
                                //           SizedBox(
                                //             height: 10,
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xff87C440),
                          boxShadow: [
                            //BoxShadow
                            BoxShadow(
                              color: Colors.grey,
                              offset: const Offset(0.0, 5.0),
                              blurRadius: 4.0,
                              spreadRadius: 0.2,
                            ), //BoxShadow
                          ],
                        ),
                        height: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  isLoading == true
                                      ? CircularProgressIndicator(
                                          color: Colors.black,
                                          semanticsLabel:
                                              'Circular progress indicator',
                                        )
                                      : (_targets.isEmpty)
                                          ? Text(
                                              'No orders assign to deliver',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Center(
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: 40,
                                                      animation: true,
                                                      animationDuration: 1000,
                                                      lineWidth: 10,
                                                      percent: 1,
                                                      progressColor:
                                                          Color(0xff44762c),
                                                      backgroundColor:
                                                          Color(0xffbdddae),
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      header: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 15),
                                                        child: Center(
                                                          child: new Text(
                                                            "Pending",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      center: Text(
                                                        pending.toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Center(
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: 40,
                                                      animation: true,
                                                      animationDuration: 1000,
                                                      lineWidth: 10,
                                                      percent: 1,
                                                      progressColor:
                                                          Color(0xff44762c),
                                                      backgroundColor:
                                                          Color(0xffbdddae),
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      header: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 15),
                                                        child: Center(
                                                          child: new Text(
                                                            "Delivered",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      center: Text(
                                                        delivered.toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Center(
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: 40,
                                                      animation: true,
                                                      animationDuration: 1000,
                                                      lineWidth: 10,
                                                      percent: 1,
                                                      progressColor:
                                                          Color(0xff44762c),
                                                      backgroundColor:
                                                          Color(0xffbdddae),
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      header: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 15),
                                                        child: Center(
                                                          child: new Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      center: Text(
                                                        cancel.toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Center(
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: 40,
                                                      animation: true,
                                                      animationDuration: 1000,
                                                      lineWidth: 10,
                                                      percent: 1,
                                                      progressColor:
                                                          Color(0xff44762c),
                                                      backgroundColor:
                                                          Color(0xffbdddae),
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      header: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 15),
                                                        child: Center(
                                                          child: new Text(
                                                            "Total",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      center: Text(
                                                        total.toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 40,
                        child: ElevatedButton(
                          child: Text('Start Your Journey',
                              style: TextStyle(fontSize: 18)),
                          onPressed: () async => {
                            if (puched_in == false)
                              {
                                get_betterys = await battery.batteryLevel,
                                await getdata(),
                                locationss = await get_location(),
                                print('Location is : $locationss'),
                                if (locationss != false)
                                  {
                                    print(locationss),
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RouteList(),
                                      ),
                                    ),
                                    // if (cust_puch == true) {
                                    //   EasyLoading.dismiss();
                                    //   show_msg('error', 'Please Punch Out From Route',
                                    //       context);
                                    // } else {
                                    set_punchedss = await api.set_punched(
                                      user_id.toString(),
                                      locationss['lat'].toString(),
                                      locationss['long'].toString(),
                                      locationss['lat'].toString(),
                                      locationss['long'].toString(),
                                      get_betterys.toString(),
                                      '1',
                                      '',
                                      '',
                                      // (puched_in == true) ? '0' : '1',
                                      '0',
                                    ),
                                  },
                              }
                            else
                              {show_msg('error', 'Please Punch In', context)}
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        drawer: DrawerNavigate(
          names: user_name,
          emails: email,
          dashboardss: '/dp_dashboard',
        ),
      ),
    );
  }

  getdata() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    email = prefs.getString('email');
    user_name = prefs.getString('user_name');
    puched_in = prefs.getBool('punched');
    cust_puch = prefs.getBool('cust_punched');
    routes_puched = prefs.getBool('routes_puched');
    customer_visit_punch = prefs.getBool('customer_visit_punch');
    retailer_visit_punch = prefs.getBool('retailer_visit_punch');
    print(routes_puched);
    setState(() {});
  }

  Future<void> setdata(setValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('punched', setValue);
  }
}

show_msg(status, message, context, {VoidCallback? onTap}) {
  return AwesomeDialog(
    context: context,
    dialogType: (status == 'error') ? DialogType.error : DialogType.success,
    animType: AnimType.rightSlide,
    title: (status == 'error') ? 'Error' : 'Success',
    desc: message,
    // btnCancelOnPress: () {},
    btnOkOnPress: onTap,
  )..show();
}
