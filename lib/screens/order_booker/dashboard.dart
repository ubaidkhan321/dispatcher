import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linear/screens/order_booker/retailer_visit.dart';
// import 'package:flutter_svg/svg.dart';
import 'customer_visit.dart';
import 'route_punch.dart';
import 'routes_plan.dart';
import '../../widgets/drawer_navigate.dart';
// import '../helpers/location.dart';
import '../../helpers/location.dart';
import '../../helpers/api.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../area_manager/stocks/stock_report.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Dashboard extends StatefulWidget {
  static var user_idss;
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _saving = false;
  int status = 0;
  late DateTime dt;
  var show_date = '';
  String? user_id = '';
  String? user_name = '';
  String? email = '';
  bool? puched_in = false;
  bool? cust_puch = false;

  bool? routes_puched = false;
  bool? customer_visit_punch = false;
  bool? retailer_visit_punch = false;

  var battery = Battery();

  Map _targets = {};
  double order_percent = 0.0;
  double shop_percent = 0.0;
  double amount_percent = 0.0;
  Future<void> _fetchData(user_id) async {
    var res = await api.get_targets(user_id.toString());
    if (res['code_status'] == true) {
      setState(
        () {
          _targets = res['targets'];
          print(_targets);
          order_percent = (double.parse(_targets['order_percentage']) < 100)
              ? (double.parse(_targets['order_percentage']) / 100)
              : 1.0;
          order_percent = double.parse(order_percent.toStringAsFixed(2));
          shop_percent = (double.parse(_targets['shops_percentage']) < 100)
              ? (double.parse(_targets['shops_percentage']) / 100)
              : 1.0;
          shop_percent = double.parse(shop_percent.toStringAsFixed(2));
          amount_percent = (double.parse(_targets['amount_percentafe']) < 100)
              ? (double.parse(_targets['amount_percentafe']) / 100)
              : 1.0;
          amount_percent = double.parse(amount_percent.toStringAsFixed(2));
        },
      );
    }
  }

  static _read(thekey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = thekey.toString();
    final value = prefs.getString(key);
    Dashboard.user_idss = value;
    print('Static user id dashboard.dart ${Dashboard.user_idss}');
    print('saved tester dashboard.dart $value');
    String usu = (value != null ? value : '');
    return usu;
  }

  @override
  void initState() {
    super.initState();
    // get_permission();
    getdata();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String my_user = await _read('user_id');
      _fetchData(my_user);
    });
    // _fetchData(user_id);
  }

  @override
  Widget build(BuildContext context) {
    // get_permission();
    // var time = 0;
    // Timer.periodic(new Duration(seconds: 10), (timer) async {
    //   var loc = await get_location();
    //   if (loc != false) {
    //     Map cordinates = loc;
    //     // print(cordinates['lat']);
    //     time++;
    //     var _test = await test(user_id, cordinates['lat'].toString(),
    //         cordinates['long'].toString(), '', '', time.toString());
    //     print(_test);
    //   }
    // });
    // get_data(context);
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
                                        // decoration: const BoxDecoration(
                                        //     borderRadius: BorderRadius.only(
                                        //         bottomLeft: Radius.circular(20),
                                        //         bottomRight:
                                        //             Radius.circular(20))),
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

                                            // Column(
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.center,
                                            //   children: [
                                            //     Text('Welcome'),
                                            //     Text(
                                            //       user_name.toString(),
                                            //       style: TextStyle(
                                            //           fontWeight:
                                            //               FontWeight.bold),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        _saving = true;
                                      });

                                      // EasyLoading.show(status: 'loading...');
                                      var get_bettery =
                                          await battery.batteryLevel;

                                      await getdata();
                                      print('working below getdata');
                                      var location = await get_location();
                                      print('Location is : $location');
                                      if (puched_in == true &&
                                          customer_visit_punch == true) {
                                        setState(() {
                                          _saving = false;
                                        });
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.rightSlide,
                                          title: 'Error',
                                          desc:
                                              'Please Punch Out From Customer Visit',
                                          // btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            Navigator.pushNamed(
                                                context, '/customer_visit');
                                          },
                                        )..show();

                                        return;
                                      }
                                      if (puched_in == true &&
                                          routes_puched == true) {
                                        setState(() {
                                          _saving = false;
                                        });
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.rightSlide,
                                          title: 'Error',
                                          desc: 'Please Punch Out From Routes',
                                          // btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            Navigator.pushNamed(
                                                context, '/routes_punch');
                                          },
                                        )..show();

                                        return;
                                      }
                                      if (location != false) {
                                        if (cust_puch == true) {
                                          // EasyLoading.dismiss();
                                          show_msg(
                                              'error',
                                              'Please Punch Out From Route',
                                              context);
                                        } else {
                                          var set_punched =
                                              await api.set_punched(
                                            user_id.toString(),
                                            location['lat'].toString(),
                                            location['long'].toString(),
                                            location['lat'].toString(),
                                            location['long'].toString(),
                                            get_bettery.toString(),
                                            '1',
                                            '',
                                            '',
                                            (puched_in == true) ? '0' : '1',
                                          );
                                          if (set_punched['code_status'] ==
                                              true) {
                                            setState(() {
                                              _saving = false;
                                            });
                                            if (puched_in == true) {
                                              show_msg(
                                                  'success',
                                                  'Sucessfully Punched Out',
                                                  context);
                                            } else {
                                              show_msg(
                                                  'success',
                                                  'Successfully Punched In',
                                                  context);
                                            }
                                            setState(() {
                                              if (puched_in == true) {
                                                puched_in = false;
                                              } else {
                                                puched_in = true;
                                              }
                                            });
                                            setdata(puched_in);
                                          }
                                        }
                                      } else {
                                        setState(() {
                                          _saving = false;
                                        });
                                        show_msg(
                                            'error',
                                            'Location Blocked Please Enable',
                                            context);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, right: 20),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Image(
                                            height: 100,
                                            // fit: BoxFit.contain,
                                            image: (puched_in == true)
                                                ? AssetImage(
                                                    'assets/images/punched_in.png',
                                                  )
                                                : AssetImage(
                                                    'assets/images/punched_out.png',
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          (puched_in == true)
                                              //wajih
                                              ? Text(
                                                  "Please Punch Out",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : Text("Please Punch In",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
                                  _targets.isEmpty
                                      ? Text('Target not assign')
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Your Monthly Target',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Total Target',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                        // SizedBox(
                                                        //   width: 30,
                                                        // ),
                                                        Text(
                                                            _targets[
                                                                    'target_orders']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 15)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text('Achieved Target',
                                                            style: TextStyle(
                                                                fontSize: 15)),
                                                        // SizedBox(
                                                        //   width: 30,
                                                        // ),
                                                        Text(
                                                            _targets[
                                                                    'achieved_orders']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 15))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              child: Center(
                                                child: CircularPercentIndicator(
                                                  radius: 60,
                                                  animation: true,
                                                  animationDuration: 1000,
                                                  lineWidth: 10,
                                                  percent: order_percent,
                                                  progressColor:
                                                      Color(0xff44762c),
                                                  backgroundColor:
                                                      Color(0xffbdddae),
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  center: Text(
                                                    _targets['order_percentage']
                                                            .toString() +
                                                        '%',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                        height: 180,
                        alignment: Alignment.center,
                        child: (_targets.isEmpty)
                            ? CircularProgressIndicator(
                                semanticsLabel: 'Circular progress indicator',
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xff87C440),
                                        width: 1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    // width: 80,
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Center(
                                                child: SizedBox(
                                                  // width: 50,
                                                  child:
                                                      CircularPercentIndicator(
                                                    radius: 40,
                                                    animation: true,
                                                    animationDuration: 1000,
                                                    lineWidth: 10,
                                                    progressColor:
                                                        Color(0xff44762c),
                                                    backgroundColor:
                                                        Color(0xffbdddae),
                                                    circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                    percent: amount_percent,
                                                    header: Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 15),
                                                      child: Center(
                                                        child: new Text(
                                                          "Amount To Be Covered",
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                    center: Text(
                                                      (_targets['amount_percentage'] !=
                                                              null)
                                                          ? _targets[
                                                                  'amount_percentage'] +
                                                              '%'
                                                          : "0%",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    footer: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Target',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        13),
                                                              ),
                                                              Text(
                                                                  _targets[
                                                                          'target_amount']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          13)),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text('Covered',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          13)),
                                                              Text(
                                                                  _targets[
                                                                          'achieved_amount']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          13)),
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
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xff87C440),
                                        width: 1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    // width: 80,
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Center(
                                                child: SizedBox(
                                                  // width: 50,
                                                  child:
                                                      CircularPercentIndicator(
                                                    radius: 40,
                                                    animation: true,
                                                    animationDuration: 1000,
                                                    lineWidth: 10,
                                                    progressColor:
                                                        Color(0xff44762c),
                                                    backgroundColor:
                                                        Color(0xffbdddae),
                                                    circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                    percent: shop_percent,
                                                    header: Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 17),
                                                      child: Center(
                                                        child: new Text(
                                                          "Shops To Be Covered",
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                    center: Text(
                                                        _targets[
                                                            'shops_percentage'],
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                    footer: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text('Target',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          13)),
                                                              Text(
                                                                  _targets[
                                                                          'target_shop']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          13)),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text('Visited',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          13)),
                                                              Text(
                                                                  _targets[
                                                                          'visited_shops']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          13)),
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
                                      ),
                                    ),
                                  ),
                                  // Expanded(
                                  //   flex: 2,
                                  //   child: Container(
                                  //     // width: 80,
                                  //     margin: const EdgeInsets.only(top: 10.0),
                                  //     child: Card(
                                  //       elevation: 0,
                                  //       color: Colors.transparent,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(3.0),
                                  //         child: Center(
                                  //           child: Column(
                                  //             children: [
                                  //               Center(
                                  //                 child: SizedBox(
                                  //                   // width: 50,
                                  //                   child: CircularPercentIndicator(
                                  //                     radius: 20.0,
                                  //                     lineWidth: 4.0,
                                  //                     percent: 0.8,
                                  //                     header: Center(
                                  //                       child: new Text(
                                  //                         "Total Orders",
                                  //                         style: TextStyle(fontSize: 8),
                                  //                       ),
                                  //                     ),
                                  //                     footer: Text('100'),
                                  //                     backgroundColor: Colors.grey,
                                  //                     progressColor: Color(0xff87C440),
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Expanded(
                                  //   flex: 2,
                                  //   child: Container(
                                  //     // width: 80,
                                  //     margin: const EdgeInsets.only(top: 10.0),
                                  //     child: Card(
                                  //       elevation: 0,
                                  //       color: Colors.transparent,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(3.0),
                                  //         child: Center(
                                  //           child: Column(
                                  //             children: [
                                  //               Center(
                                  //                 child: SizedBox(
                                  //                   // width: 50,
                                  //                   child: CircularPercentIndicator(
                                  //                     radius: 20.0,
                                  //                     lineWidth: 4.0,
                                  //                     percent: 0.8,
                                  //                     header: Center(
                                  //                       child: new Text(
                                  //                         "Order Amount",
                                  //                         style: TextStyle(fontSize: 8),
                                  //                       ),
                                  //                     ),
                                  //                     footer: Text('100000'),
                                  //                     backgroundColor: Colors.grey,
                                  //                     progressColor: Color(0xff87C440),
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //                   ElevatedButton(onPressed: (){

                      // print(_target);
                      //                   }, child: Text('Click me')),
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 40,
                        child: ElevatedButton(
                          child: Text('Start Your Journey',
                              style: TextStyle(fontSize: 18)),
                          onPressed: () {
                            if (puched_in == true) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => RetailerVisit()));

                              // Navigator.pushNamed(context, '/reatiler_visit');
                            } else {
                              show_msg('error', 'Please Punch In', context);
                            }
                          },
                        ),
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width - 20,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: Color(0xff87C440),
                      //             width: 1,
                      //           ),
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10)),
                      //         ),
                      //         width: 90,
                      //         child: Card(
                      //           elevation: 0,
                      //           color: Colors.transparent,
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(4.0),
                      //             child: InkWell(
                      //               onTap: () async {
                      //                 if (puched_in == true) {
                      //                   Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                       builder: (context) => CustomerVisit(),
                      //                     ),
                      //                   );
                      //                   // Navigator.pushNamed(context, '/customer_visit');
                      //                 } else {
                      //                   show_msg(
                      //                       'error', 'Please Punche In', context);
                      //                 }
                      //               },
                      //               child: Card(
                      //                 elevation: 0,
                      //                 color: Colors.transparent,
                      //                 child: Column(
                      //                   children: [
                      //                     SvgPicture.asset(
                      //                       'assets/images/add_customer.svg',
                      //                       width: 50,
                      //                       height: 50,
                      //                     ),
                      //                     SizedBox(
                      //                       height: 5,
                      //                     ),
                      //                     // Image(
                      //                     //   height: 50,
                      //                     //   fit: BoxFit.fill,
                      //                     //   image: AssetImage(
                      //                     //     'assets/images/retailer_visit.png',
                      //                     //   ),
                      //                     // ),
                      //                     Column(
                      //                       children: [
                      //                         Text(
                      //                           'Distributoir',
                      //                           // style: TextStyle(fontSize: 12),
                      //                         ),
                      //                         Text(
                      //                           'Visit',
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Container(
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: Color(0xff87C440),
                      //             width: 1,
                      //           ),
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10)),
                      //         ),
                      //         width: 90,
                      //         child: InkWell(
                      //           onTap: () async {
                      //             if (puched_in == true) {
                      //               Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                   builder: (context) => RoutePunch(),
                      //                 ),
                      //               );
                      //               // Navigator.pushNamed(context, '/routes_punch');
                      //             } else {
                      //               show_msg(
                      //                   'error', 'Please Punche In', context);
                      //             }
                      //           },
                      //           child: Card(
                      //             elevation: 0,
                      //             color: Colors.transparent,
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(4.0),
                      //               child: Card(
                      //                 elevation: 0,
                      //                 color: Colors.transparent,
                      //                 child: Column(
                      //                   children: [
                      //                     SvgPicture.asset(
                      //                       'assets/images/add_customer.svg',
                      //                       width: 50,
                      //                       height: 50,
                      //                     ),
                      //                     SizedBox(
                      //                       height: 5,
                      //                     ),
                      //                     Column(
                      //                       children: [
                      //                         Text(
                      //                           'Retailer',
                      //                         ),
                      //                         Text(
                      //                           'Visit',
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Container(
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: Color(0xff87C440),
                      //             width: 1,
                      //           ),
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10)),
                      //         ),
                      //         width: 90,
                      //         child: Card(
                      //           elevation: 0,
                      //           color: Colors.transparent,
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(4.0),
                      //             child: InkWell(
                      //               onTap: () async {
                      //                 await getdata();
                      //                 if (puched_in == true) {
                      //                   showDialog(
                      //                     context: context,
                      //                     builder: (ctx) => AlertDialog(
                      //                       title: const Text("Please Select"),
                      //                       actions: <Widget>[
                      //                         TextButton(
                      //                           onPressed: () {
                      //                             if (puched_in == true &&
                      //                                 customer_visit_punch ==
                      //                                     true) {
                      //                               Navigator.push(
                      //                                 context,
                      //                                 MaterialPageRoute(
                      //                                   builder: (context) =>
                      //                                       StockReport(
                      //                                           customer: 1,
                      //                                           type: 'customer'),
                      //                                 ),
                      //                               );
                      //                             } else {
                      //                               AwesomeDialog(
                      //                                 context: context,
                      //                                 dialogType:
                      //                                     DialogType.error,
                      //                                 animType:
                      //                                     AnimType.rightSlide,
                      //                                 title: 'Error',
                      //                                 desc:
                      //                                     'Need To Punch In From Distrubutor Visit',
                      //                                 // btnCancelOnPress: () {},
                      //                                 btnOkOnPress: () {},
                      //                               ).show();
                      //                             }
                      //                           },
                      //                           child: Container(
                      //                             color: Colors.green,
                      //                             padding:
                      //                                 const EdgeInsets.all(14),
                      //                             child: const Text("Distribtor"),
                      //                           ),
                      //                         ),
                      //                         TextButton(
                      //                           onPressed: () {
                      //                             if (puched_in == true &&
                      //                                 routes_puched == true &&
                      //                                 retailer_visit_punch ==
                      //                                     true) {
                      //                               Navigator.push(
                      //                                 context,
                      //                                 MaterialPageRoute(
                      //                                   builder: (context) =>
                      //                                       StockReport(
                      //                                           customer: 1,
                      //                                           type: 'retailer'),
                      //                                 ),
                      //                               );
                      //                             } else {
                      //                               AwesomeDialog(
                      //                                 context: context,
                      //                                 dialogType:
                      //                                     DialogType.error,
                      //                                 animType:
                      //                                     AnimType.rightSlide,
                      //                                 title: 'Error',
                      //                                 desc:
                      //                                     'Need To Punch In From Retailer Visit',
                      //                                 // btnCancelOnPress: () {},
                      //                                 btnOkOnPress: () {},
                      //                               )..show();
                      //                             }
                      //                           },
                      //                           child: Container(
                      //                             color: Colors.green,
                      //                             padding:
                      //                                 const EdgeInsets.all(14),
                      //                             child: const Text("Retailer"),
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   );
                      //                 } else {
                      //                   show_msg('error', 'Please Punched in',
                      //                       context);
                      //                 }
                      //               },
                      //               child: Card(
                      //                 elevation: 0,
                      //                 color: Colors.transparent,
                      //                 child: Column(
                      //                   children: [
                      //                     SvgPicture.asset(
                      //                       'assets/images/shape.svg',
                      //                       width: 50,
                      //                       height: 50,
                      //                     ),
                      //                     SizedBox(
                      //                       height: 5,
                      //                     ),
                      //                     Column(
                      //                       children: [
                      //                         Text(
                      //                           'Stock',
                      //                         ),
                      //                         Text(
                      //                           'Report',
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Container(
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: Color(0xff87C440),
                      //             width: 1,
                      //           ),
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10)),
                      //         ),
                      //         width: 90,
                      //         child: Card(
                      //           elevation: 0,
                      //           color: Colors.transparent,
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(4.0),
                      //             child: InkWell(
                      //               onTap: () async {
                      //                 await getdata();
                      //                 if (puched_in == true) {
                      //                   showDialog(
                      //                     context: context,
                      //                     builder: (ctx) => AlertDialog(
                      //                       title: const Text("Please Select"),
                      //                       actions: <Widget>[
                      //                         TextButton(
                      //                           onPressed: () {
                      //                             if (puched_in == true &&
                      //                                 customer_visit_punch ==
                      //                                     true) {
                      //                               Navigator.pushNamed(context,
                      //                                   '/orders/add_orders/customer');
                      //                             } else {
                      //                               AwesomeDialog(
                      //                                 context: context,
                      //                                 dialogType:
                      //                                     DialogType.error,
                      //                                 animType:
                      //                                     AnimType.rightSlide,
                      //                                 title: 'Error',
                      //                                 desc:
                      //                                     'Need To Punch In From Distrubutor Visit',
                      //                                 // btnCancelOnPress: () {},
                      //                                 btnOkOnPress: () {},
                      //                               ).show();
                      //                             }
                      //                           },
                      //                           child: Container(
                      //                             color: Colors.green,
                      //                             padding:
                      //                                 const EdgeInsets.all(14),
                      //                             child: const Text("Distribtor"),
                      //                           ),
                      //                         ),
                      //                         TextButton(
                      //                           onPressed: () {
                      //                             if (puched_in == true &&
                      //                                 routes_puched == true &&
                      //                                 retailer_visit_punch ==
                      //                                     true) {
                      //                               Navigator.pushNamed(context,
                      //                                   '/orders/add_orders/retailer');
                      //                             } else {
                      //                               AwesomeDialog(
                      //                                 context: context,
                      //                                 dialogType:
                      //                                     DialogType.error,
                      //                                 animType:
                      //                                     AnimType.rightSlide,
                      //                                 title: 'Error',
                      //                                 desc:
                      //                                     'Need To Punch In From Retailer Visit',
                      //                                 // btnCancelOnPress: () {},
                      //                                 btnOkOnPress: () {},
                      //                               ).show();
                      //                             }
                      //                           },
                      //                           child: Container(
                      //                             color: Colors.green,
                      //                             padding:
                      //                                 const EdgeInsets.all(14),
                      //                             child: const Text("Retailer"),
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   );
                      //                   // Navigator.pushNamed(context, '/orders');
                      //                 } else {
                      //                   show_msg(
                      //                       'error', 'Please Punch in', context);
                      //                 }
                      //               },
                      //               child: Card(
                      //                 elevation: 0,
                      //                 color: Colors.transparent,
                      //                 child: Column(
                      //                   children: [
                      //                     SvgPicture.asset(
                      //                       'assets/images/order.svg',
                      //                       width: 50,
                      //                       height: 50,
                      //                     ),
                      //                     SizedBox(
                      //                       height: 5,
                      //                     ),
                      //                     Column(
                      //                       children: [
                      //                         Text(
                      //                           'Create',
                      //                         ),
                      //                         Text(
                      //                           'Order',
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width - 20,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: Color(0xff87C440),
                      //             width: 1,
                      //           ),
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10)),
                      //         ),
                      //         width: 90,
                      //         child: Card(
                      //           elevation: 0,
                      //           color: Colors.transparent,
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(4.0),
                      //             child: InkWell(
                      //               onTap: () async {
                      //                 await getdata();
                      //                 if (puched_in == true) {
                      //                   showDialog(
                      //                     context: context,
                      //                     builder: (ctx) => AlertDialog(
                      //                       title: const Text("Please Select"),
                      //                       actions: <Widget>[
                      //                         TextButton(
                      //                           onPressed: () {
                      //                             if (puched_in == true &&
                      //                                 customer_visit_punch ==
                      //                                     true) {
                      //                               Navigator.pushNamed(context,
                      //                                   '/complain/add/customer');
                      //                             } else {
                      //                               AwesomeDialog(
                      //                                 context: context,
                      //                                 dialogType:
                      //                                     DialogType.error,
                      //                                 animType:
                      //                                     AnimType.rightSlide,
                      //                                 title: 'Error',
                      //                                 desc:
                      //                                     'Need To Punch In From Distrubutor Visit',
                      //                                 // btnCancelOnPress: () {},
                      //                                 btnOkOnPress: () {},
                      //                               )..show();
                      //                             }
                      //                           },
                      //                           child: Container(
                      //                             color: Colors.green,
                      //                             padding:
                      //                                 const EdgeInsets.all(14),
                      //                             child: const Text("Distribtor"),
                      //                           ),
                      //                         ),
                      //                         TextButton(
                      //                           onPressed: () {
                      //                             if (puched_in == true &&
                      //                                 routes_puched == true &&
                      //                                 retailer_visit_punch ==
                      //                                     true) {
                      //                               Navigator.pushNamed(context,
                      //                                   '/complain/add/retailer');
                      //                             } else {
                      //                               AwesomeDialog(
                      //                                 context: context,
                      //                                 dialogType:
                      //                                     DialogType.error,
                      //                                 animType:
                      //                                     AnimType.rightSlide,
                      //                                 title: 'Error',
                      //                                 desc:
                      //                                     'Need To Punch In From Retailer Visit',
                      //                                 // btnCancelOnPress: () {},
                      //                                 btnOkOnPress: () {},
                      //                               )..show();
                      //                             }
                      //                           },
                      //                           child: Container(
                      //                             color: Colors.green,
                      //                             padding:
                      //                                 const EdgeInsets.all(14),
                      //                             child: const Text("Retailer"),
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   );
                      //                   // Navigator.pushNamed(context, '/complain');
                      //                 } else {
                      //                   show_msg(
                      //                       'error', 'Please Punch in', context);
                      //                 }
                      //               },
                      //               child: Card(
                      //                 elevation: 0,
                      //                 color: Colors.transparent,
                      //                 child: Column(
                      //                   children: [
                      //                     SvgPicture.asset(
                      //                       'assets/images/compain.svg',
                      //                       width: 50,
                      //                       height: 50,
                      //                     ),
                      //                     SizedBox(
                      //                       height: 5,
                      //                     ),
                      //                     Column(
                      //                       children: [
                      //                         Text(
                      //                           'Create',
                      //                         ),
                      //                         Text(
                      //                           'Complain',
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Container(
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: Color(0xff87C440),
                      //             width: 1,
                      //           ),
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10)),
                      //         ),
                      //         width: 90,
                      //         child: Card(
                      //           elevation: 0,
                      //           color: Colors.transparent,
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(4.0),
                      //             child: InkWell(
                      //               onTap: () async {
                      //                 await getdata();
                      //                 if (puched_in == true) {
                      //                   showDialog(
                      //                     context: context,
                      //                     builder: (ctx) => AlertDialog(
                      //                       title: const Text("Please Select"),
                      //                       actions: <Widget>[
                      //                         TextButton(
                      //                           onPressed: () {
                      //                             if (puched_in == true &&
                      //                                 customer_visit_punch ==
                      //                                     true) {
                      //                               Navigator.pushNamed(context,
                      //                                   '/payment/add/customer');
                      //                             } else {
                      //                               AwesomeDialog(
                      //                                 context: context,
                      //                                 dialogType:
                      //                                     DialogType.error,
                      //                                 animType:
                      //                                     AnimType.rightSlide,
                      //                                 title: 'Error',
                      //                                 desc:
                      //                                     'Need To Punch In From Distrubutor Visit',
                      //                                 // btnCancelOnPress: () {},
                      //                                 btnOkOnPress: () {},
                      //                               )..show();
                      //                             }
                      //                           },
                      //                           child: Container(
                      //                             color: Colors.green,
                      //                             padding:
                      //                                 const EdgeInsets.all(14),
                      //                             child: const Text("Distribtor"),
                      //                           ),
                      //                         ),
                      //                         TextButton(
                      //                           onPressed: () {
                      //                             if (puched_in == true &&
                      //                                 routes_puched == true &&
                      //                                 retailer_visit_punch ==
                      //                                     true) {
                      //                               Navigator.pushNamed(context,
                      //                                   '/payment/add/retailer');
                      //                             } else {
                      //                               AwesomeDialog(
                      //                                 context: context,
                      //                                 dialogType:
                      //                                     DialogType.error,
                      //                                 animType:
                      //                                     AnimType.rightSlide,
                      //                                 title: 'Error',
                      //                                 desc:
                      //                                     'Need To Punch In From Retailer Visit',
                      //                                 // btnCancelOnPress: () {},
                      //                                 btnOkOnPress: () {},
                      //                               )..show();
                      //                             }
                      //                           },
                      //                           child: Container(
                      //                             color: Colors.green,
                      //                             padding:
                      //                                 const EdgeInsets.all(14),
                      //                             child: const Text("Retailer"),
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   );
                      //                   // Navigator.pushNamed(context, '/complain');
                      //                 } else {
                      //                   show_msg(
                      //                       'error', 'Please Punch in', context);
                      //                 }
                      //                 // Navigator.pushNamed(context, '/payment');
                      //               },
                      //               child: Card(
                      //                 elevation: 0,
                      //                 color: Colors.transparent,
                      //                 child: Column(
                      //                   children: [
                      //                     SvgPicture.asset(
                      //                       'assets/images/payment.svg',
                      //                       width: 50,
                      //                       height: 50,
                      //                     ),
                      //                     SizedBox(
                      //                       height: 5,
                      //                     ),
                      //                     Column(
                      //                       children: [
                      //                         Text(
                      //                           'Payment',
                      //                         ),
                      //                         Text(
                      //                           'Collection',
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Container(
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: Color(0xff87C440),
                      //             width: 1,
                      //           ),
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10)),
                      //         ),
                      //         width: 90,
                      //         child: Card(
                      //           elevation: 0,
                      //           color: Colors.transparent,
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(4.0),
                      //             child: InkWell(
                      //               onTap: () async {
                      //                 await getdata();
                      //                 if (puched_in == true) {
                      //                   showDialog(
                      //                     context: context,
                      //                     builder: (ctx) => AlertDialog(
                      //                       title: const Text("Please Select"),
                      //                       actions: <Widget>[
                      //                         TextButton(
                      //                           onPressed: () {
                      //                             if (puched_in == true &&
                      //                                 customer_visit_punch ==
                      //                                     true) {
                      //                               Navigator.pushNamed(context,
                      //                                   '/servey/add/customer');
                      //                             } else {
                      //                               AwesomeDialog(
                      //                                 context: context,
                      //                                 dialogType:
                      //                                     DialogType.error,
                      //                                 animType:
                      //                                     AnimType.rightSlide,
                      //                                 title: 'Error',
                      //                                 desc:
                      //                                     'Need To Punch In From Distrubutor Visit',
                      //                                 // btnCancelOnPress: () {},
                      //                                 btnOkOnPress: () {},
                      //                               )..show();
                      //                             }
                      //                           },
                      //                           child: Container(
                      //                             color: Colors.green,
                      //                             padding:
                      //                                 const EdgeInsets.all(14),
                      //                             child: const Text("Distribtor"),
                      //                           ),
                      //                         ),
                      //                         TextButton(
                      //                           onPressed: () {
                      //                             if (puched_in == true &&
                      //                                 routes_puched == true &&
                      //                                 retailer_visit_punch ==
                      //                                     true) {
                      //                               Navigator.pushNamed(context,
                      //                                   '/servey/add/retailer');
                      //                             } else {
                      //                               AwesomeDialog(
                      //                                 context: context,
                      //                                 dialogType:
                      //                                     DialogType.error,
                      //                                 animType:
                      //                                     AnimType.rightSlide,
                      //                                 title: 'Error',
                      //                                 desc:
                      //                                     'Need To Punch In From Retailer Visit',
                      //                                 // btnCancelOnPress: () {},
                      //                                 btnOkOnPress: () {},
                      //                               )..show();
                      //                             }
                      //                           },
                      //                           child: Container(
                      //                             color: Colors.green,
                      //                             padding:
                      //                                 const EdgeInsets.all(14),
                      //                             child: const Text("Retailer"),
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   );
                      //                   // Navigator.pushNamed(context, '/servey/add');
                      //                 } else {
                      //                   show_msg(
                      //                       'error', 'Please Punch in', context);
                      //                 }
                      //               },
                      //               child: Card(
                      //                 elevation: 0,
                      //                 color: Colors.transparent,
                      //                 child: Column(
                      //                   children: [
                      //                     SvgPicture.asset(
                      //                       'assets/images/servey.svg',
                      //                       width: 50,
                      //                       height: 50,
                      //                     ),
                      //                     SizedBox(
                      //                       height: 5,
                      //                     ),
                      //                     Column(
                      //                       children: [
                      //                         Text(
                      //                           'Create',
                      //                         ),
                      //                         Text(
                      //                           'Servey',
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 40,
                      // ),
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
          dashboardss: '/dashboard',
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
    print(' my $puched_in');
    setState(() {});
  }

  Future<void> setdata(setValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('punched', setValue);
  }
}

var decoration = BoxDecoration(
  border: Border(
    right: BorderSide(color: Colors.black, width: 1),
  ),
);

show_msg(status, message, context) {
  return AwesomeDialog(
    context: context,
    dialogType: (status == 'error') ? DialogType.error : DialogType.success,
    animType: AnimType.rightSlide,
    title: (status == 'error') ? 'Error' : 'Success',
    titleTextStyle: TextStyle(
        color: (status == 'error') ? Colors.red : Colors.black,
        fontWeight: FontWeight.bold),
    desc: message,

    descTextStyle: TextStyle(
        color: (status == 'error') ? Colors.red : Colors.black,
        fontWeight: FontWeight.bold),
    // btnCancelOnPress: () {},
    btnOkOnPress: () {},
  )..show();
}
