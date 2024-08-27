import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linear/screens/area_manager/servey/servey_list.dart';
import 'package:linear/screens/area_manager/stocks/stock_report.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../helpers/location.dart';
import '../../helpers/api.dart';
import '../../search_widget/order_booker_search.dart';
import '../../widgets/drawer_navigate.dart';
import 'complains/complain_list.dart';
import 'feedbacks/feedback_list.dart';
import 'orders/order_list.dart';
import 'payments/payment_list.dart';
import 'stocks/stock_list.dart';

class AmDashboard extends StatefulWidget {
  const AmDashboard({Key? key}) : super(key: key);

  @override
  _AmDashboardState createState() => _AmDashboardState();
}

class _AmDashboardState extends State<AmDashboard> {
  var longitude1;
  var latitude1;
  bool _saving = false;
  bool? puched_in = false;
  String? user_id = '';
  String? user_name = '';
  String? email = '';
  String? order_booker_id = '';
  String? order_booker_name = '';
  double order_percent = 0;
  double shop_percent = 0;
  double amount_percent = 0;
  var battery = Battery();
  TextEditingController _customer_controller = new TextEditingController();
  TextEditingController _order_booker_controller = new TextEditingController();
  TextEditingController _order_booker_id_controller =
      new TextEditingController();

  Map _targets = {};

  Future<void> _fetchtarget(user_id) async {
    order_percent = 0;
    shop_percent = 0;
    amount_percent = 0;
    EasyLoading.show(status: 'loading...');
    var res = await api.get_targets(user_id);
    if (res['code_status'] == true) {
      setState(
        () {
          EasyLoading.dismiss();
          if (res['targets'] != null) {
            show_msg('success', 'Fetch Successfully', context);
            _targets = res['targets'];
            order_percent = double.parse(_targets['order_percentage']) / 100;
            order_percent = double.parse(order_percent.toStringAsFixed(2));
            shop_percent = double.parse(_targets['shops_percentage']) / 100;
            shop_percent = double.parse(shop_percent.toStringAsFixed(2));
            amount_percent = double.parse(_targets['amount_percentafe']) / 100;
            amount_percent = double.parse(amount_percent.toStringAsFixed(2));
          } else {
            show_msg('error', 'NO Data Available', context);
            _targets = {};
          }
          print('The Percentage is : ');
          print(order_percent);
          print(shop_percent);
          print(amount_percent);
          print(_targets);
        },
      );
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
      String my_user = await _read('user_id');
      String order_booker_id = await _read('am_order_booker_id');
      String order_booker_name = await _read('am_order_booker_name');

      _order_booker_controller.text = order_booker_name;
      _order_booker_id_controller.text = order_booker_id;
      // _fetchData(my_user);
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
          // backgroundColor: Colors.red,
          title: Image(
            height: 60,
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
                                  height: 150,
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
                                      var location = await get_location();
                                      print('Location is : ');
                                      //wajih
                                      longitude1 = location['lat'].toString();
                                      latitude1 = location['long'].toString();

                                      if (location != false) {
                                        print('Wajih ${location} ');
                                        // if (cust_puch == true) {
                                        //   EasyLoading.dismiss();
                                        //   show_msg('error', 'Please Punch Out From Route',
                                        //       context);
                                        // } else {
                                        var set_punched = await api.set_punched(
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
                                                'Sucessfully Punched In',
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
                                        // }
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
                                              ? Text("Please Punch Out")
                                              : Text("Please Punch In"),
                                          SizedBox(
                                            height: 10,
                                          )
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: SizedBox(
                                child: TextFormField(
                                  controller: _order_booker_controller,
                                  decoration: InputDecoration(
                                    filled: true,
                                    labelText: "Select Order Booker",
                                    border:
                                        OutlineInputBorder(), //label text of field
                                  ),
                                  // initialValue: DateTime.now(),
                                  onChanged: (value) {
                                    // subject = value;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Date Is Required";
                                    }
                                    return null;
                                  },
                                  readOnly: true,
                                  onTap: () async {
                                    showMaterialModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return OrderBookerSearch(
                                          am_id: user_id.toString(),
                                          name_controller:
                                              _order_booker_controller,
                                          id_controller:
                                              _order_booker_id_controller,
                                          // distributor_id: session_distributor.toString(),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () => {
                                  if (puched_in == true)
                                    {
                                      _fetchtarget(
                                          _order_booker_id_controller.text),
                                      api.setdata('am_order_booker_id',
                                          _order_booker_id_controller.text),
                                      api.setdata('am_order_booker_name',
                                          _order_booker_controller.text),
                                    }
                                  else
                                    {
                                      show_msg(
                                          'error', 'Please Punch In', context)
                                    }
                                },
                                child: Text('Go'),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
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
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Location',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Longitude: ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '${longitude1 ?? 'Please Punch in'}',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Latitude: ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '${latitude1 ?? 'Please Punch in'}',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.50,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Your Monthly Target',
                                                style: TextStyle(
                                                    fontSize: 22,
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
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  // SizedBox(
                                                  //   width: 30,
                                                  // ),
                                                  Text(
                                                      (_targets['target_orders'] !=
                                                              null)
                                                          ? _targets[
                                                                  'target_orders']
                                                              .toString()
                                                          : '0',
                                                      style: TextStyle(
                                                          fontSize: 20)),
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
                                                          fontSize: 20)),
                                                  // SizedBox(
                                                  //   width: 30,
                                                  // ),
                                                  Text(
                                                      (_targets['achieved_orders'] !=
                                                              null)
                                                          ? _targets[
                                                                  'achieved_orders']
                                                              .toString()
                                                          : "0",
                                                      style: TextStyle(
                                                          fontSize: 20))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 15),
                                        child: Center(
                                          child: CircularPercentIndicator(
                                            radius: 60,
                                            animation: true,
                                            animationDuration: 1000,
                                            lineWidth: 10,
                                            // percent: (_targets['order_percentage'] !=
                                            //         null)
                                            //     ? (double.parse(
                                            //         (_targets['order_percentage']) /
                                            //             100))
                                            //     : 0,
                                            percent: order_percent,
                                            progressColor: Color(0xff44762c),
                                            backgroundColor: Color(0xffbdddae),
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                            center: Text(
                                              (_targets['order_percentage'] !=
                                                      null)
                                                  ? _targets['order_percentage']
                                                      .toString()
                                                  : "0" + '%',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
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
                                            child: CircularPercentIndicator(
                                              radius: 40,
                                              animation: true,
                                              animationDuration: 1000,
                                              lineWidth: 10,
                                              progressColor: Color(0xff44762c),
                                              backgroundColor:
                                                  Color(0xffbdddae),
                                              circularStrokeCap:
                                                  CircularStrokeCap.round,
                                              percent: amount_percent,
                                              // percent: (_targets[
                                              //             'amount_percentafe'] !=
                                              //         null) ? (double.parse(_targets[
                                              //             'amount_percentafe']) / 100) : 0,

                                              header: Container(
                                                // height: 100,
                                                margin:
                                                    EdgeInsets.only(bottom: 12),
                                                child: Center(
                                                  child: new Text(
                                                    "Amount To Be Covered",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ),

                                              center: Text(
                                                (_targets['amount_percentafe'] !=
                                                        null)
                                                    ? _targets[
                                                            'amount_percentafe'] +
                                                        '%'
                                                    : "0%",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              footer: Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
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
                                                        Text('target',
                                                            style: TextStyle(
                                                                fontSize: 18)),
                                                        Text(
                                                            (_targets['target_amount'] !=
                                                                    null)
                                                                ? _targets[
                                                                        'target_amount']
                                                                    .toString()
                                                                : "0",
                                                            style: TextStyle(
                                                                fontSize: 18)),
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
                                                                fontSize: 18)),
                                                        Text(
                                                            (_targets['achieved_amount'] !=
                                                                    null)
                                                                ? _targets[
                                                                        'achieved_amount']
                                                                    .toString()
                                                                : "0",
                                                            style: TextStyle(
                                                                fontSize: 18)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // backgroundColor: Colors.grey,
                                              // progressColor: Color(0xff87C440),
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
                              width: MediaQuery.of(context).size.width * 0.45,
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
                                            child: CircularPercentIndicator(
                                              radius: 40,
                                              animation: true,
                                              animationDuration: 1000,
                                              lineWidth: 10,
                                              progressColor: Color(0xff44762c),
                                              backgroundColor:
                                                  Color(0xffbdddae),
                                              circularStrokeCap:
                                                  CircularStrokeCap.round,
                                              percent: shop_percent,
                                              header: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 12),
                                                child: Center(
                                                  child: new Text(
                                                    "Shops To Be Covered",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                              center: Text('10%',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              footer: Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
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
                                                        Text('target',
                                                            style: TextStyle(
                                                                fontSize: 18)),
                                                        Text(
                                                            (_targets['target_shop'] !=
                                                                    null)
                                                                ? _targets[
                                                                        'target_shop']
                                                                    .toString()
                                                                : "0",
                                                            style: TextStyle(
                                                                fontSize: 18)),
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
                                                                fontSize: 18)),
                                                        Text(
                                                            (_targets['visited_shops'] !=
                                                                    null)
                                                                ? _targets[
                                                                        'visited_shops']
                                                                    .toString()
                                                                : "0",
                                                            style: TextStyle(
                                                                fontSize: 18)),
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
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  onTap: () => {
                                    if (order_booker_id != null &&
                                        puched_in == true)
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StockReport(),
                                          ),
                                        )
                                      }
                                    else
                                      {
                                        show_msg(
                                            'error',
                                            'Please Select order Booker And Punch In',
                                            context)
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
                                              child: Text('Stocks'),
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
                              // color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () => {
                                    if (order_booker_id != null &&
                                        puched_in == true)
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ServeyList(),
                                          ),
                                        )
                                      }
                                    else
                                      {
                                        show_msg(
                                            'error',
                                            'Please Select Order Booker And Punch In',
                                            context)
                                      }
                                  },
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/feedback.svg',
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
                                              child: Text('Servey'),
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
                              // color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () => {
                                    if (order_booker_id != null &&
                                        puched_in == true)
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PaymentList(),
                                          ),
                                        )
                                      }
                                    else
                                      {
                                        show_msg(
                                            'error',
                                            'Please Select Order Booker And Punch In',
                                            context)
                                      }
                                  },
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/payment.svg',
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
                                              child: Text('Payments'),
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.90,
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
                                  onTap: () => {
                                    if (order_booker_id != null &&
                                        puched_in == true)
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrderList(),
                                          ),
                                        )
                                      }
                                    else
                                      {
                                        show_msg(
                                            'error',
                                            'Please Select Order Booker And Punch In',
                                            context)
                                      }
                                  },
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
                                              child: Text('Order'),
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
                              // color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () => {
                                    if (order_booker_id != null &&
                                        puched_in == true)
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FeedbackList(),
                                          ),
                                        )
                                      }
                                    else
                                      {
                                        show_msg(
                                            'error',
                                            'Please Select Order Boooker And Punch In',
                                            context)
                                      }
                                  },
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/feedback.svg',
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
                                              child: Text('Feedbacks'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
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
                              // color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () => {
                                    if (order_booker_id != null &&
                                        puched_in == true)
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ComplainList(),
                                          ),
                                        )
                                      }
                                    else
                                      {
                                        show_msg(
                                            'error',
                                            'Please Select Order Booker And Punch In',
                                            context)
                                      }
                                  },
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/compain.svg',
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
                                              child: Text('Complain'),
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
                      SizedBox(
                        height: 10,
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
          dashboardss: '/am_dashboard',
        ),
      ),
    );
  }

  getdata() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    user_name = prefs.getString('user_name');
    email = prefs.getString('email');
    order_booker_id = prefs.getString('am_order_booker_id');
    order_booker_name = prefs.getString('am_order_booker_name');
    puched_in = prefs.getBool('punched');
    setState(() {});
  }

  Future<void> setdata(setValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('punched', setValue);
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
