import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:linear/const/appColors.dart';
import 'package:linear/order_placed_wajih.dart';
import 'package:linear/screens/order_booker/order_history.dart';
import 'package:linear/screens/order_booker/retailer_lst_ord_his.dart';
import 'add_customer.dart';
import 'complain.dart';
import 'feedback.dart';
import 'package:linear/screens/orders/add_order.dart';
import 'payment.dart';
import 'servey.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../helpers/api.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../helpers/location.dart';
import '../area_manager/stocks/stock_report.dart';
import 'shops_locations.dart';
import 'package:battery_plus/battery_plus.dart';

import '../../search_widget/retailer_search.dart';

class RetailerVisit extends StatefulWidget {
  static var customers_idss = "";
  static var name = "";
  static var address = "";
  static var phone = "";
  static var ntn = "";
  static var gst = "";
  static var email = "";

  static var data;
  const RetailerVisit({Key? key}) : super(key: key);

  @override
  _RetailerVisitState createState() => _RetailerVisitState();
}

enum SingingCharacter { Direct, Indirect }

late Box box1;

String? routeid;
List RouteNameList = [];

class _RetailerVisitState extends State<RetailerVisit> {
  @override
  var customer_ids = "";

  ////
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _customer_controller = new TextEditingController();
  TextEditingController _customer_id_controller = new TextEditingController();
  // TextEditingController _assign_routes_controller = new TextEditingController();
  TextEditingController _caption_controller = new TextEditingController();
  // TextEditingController _assign_routes_id_controller =
  //     new TextEditingController();
  bool _saving = false;
  int status = 0;
  bool? retailer_visit_puched = false;
  String? retailer_visit_name = '';
  String? retailer_visit_id = '';
  String? session_distributor = '';
  bool? direct_indirect = false;
  var route_name;

  List _journey = [];

  String? user_id = '';
  String? user_name = '';
  String? cust_name = '';
  String? session_route_id = '';
  String? session_route_name = '';
  String? cust_id;
  // String selected_customer = '';
  String selected_type = '';
  String search = '';
  String visited_caption = 'Please Select Retailer';
  var battery = Battery();
  // late Box box1;

  List _customer = [];
  // Map _journey = {};
  SingingCharacter? _character = SingingCharacter.Direct;

  static _read(thekey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = thekey.toString();
    print("Key $key");
    final value = prefs.getString(key);
    print('saved tester $value');
    String usu = (value != null ? value : '');
    return usu;
  }

  Future<void> _fetchjourney(user_id) async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_journey(user_id);
    if (res['code_status'] == true) {
      setState(() {
        _saving = false;
      });
      setState(
        () {
          _journey = res['pop_journey'];
          print("Journey ${_journey}");
          // route_name = _journey[0]['routes_name'];
          // print(route_name);
        },
      );
    } else {
      print('asdsadasdas');
      print(res);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        body: Text(
          'Error',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        // title: (status == 'error') ? 'Error' : 'Success',
        desc: "No Route Assigned",
        // btnCancelOnPress: () {},
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      )..show();
      setState(() {
        _saving = false;
      });
    }
    // print(res);
  }

  @override
  void initState() {
    getdata();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String my_user = await _read('user_id');
      String reatiler_name = await _read('retailer_visit_name');
      print('The Retailer Name : $reatiler_name');
      // print(_journey);

      _customer_controller.text = reatiler_name;
      await _fetchjourney(my_user.toString());
      // _assign_routes_controller.text = _journey['routes_name'].toString();
      // _assign_routes_id_controller.text = _journey['routes_id'].toString();
      // createBox();
    });
  }

  Future<void> getCustomerdata() async {
    var res = await api.get_customer_by_id('${RetailerVisit.customers_idss}');
    //pdf UI
    if (res['code_status'] == true) {
      setState(() {
        print('Get customer Dataas $res');
        RetailerVisit.name = '${res['customers'][0]['name']}';
        RetailerVisit.email = '${res['customers'][0]['email']}';
        RetailerVisit.address = '${res['customers'][0]['address']}';
        RetailerVisit.phone = '${res['customers'][0]['phone']}';
        RetailerVisit.ntn = '${res['customers'][0]['cf1']}';
        RetailerVisit.gst = '${res['customers'][0]['gst_no']}';

        print('Retailer visit ${RetailerVisit.name}');

        // set_Customer();
      });
    } else {
      setState(() {
        print('Login Failed');
      });
    }
  }

  void createBox() async {
    box1 = await Hive.openBox('dropdown');
    getdatas();
  }

  void getdatas() async {
    if (box1.get('route') != null) {
      routeid = box1.get('route');
      // box1.delete('route');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool allowed = false;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
      body: RefreshIndicator(
        onRefresh: () async {
          await Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => RetailerVisit()));
          setState(() {});
        },
        child: ModalProgressHUD(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                // width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: (_customer_controller.text.isEmpty)
                                      ? Text(
                                          'Please Select Retailer',
                                        )
                                      : Column(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "You are Visiting At",
                                            ),
                                            Text(
                                              _customer_controller.text,
                                            )
                                          ],
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {});
                                    // print(
                                    //     'Route ID ${_assign_routes_id_controller.text}');
                                    print('Route ID ${routeid}');
                                    //

                                    //
                                    // print(
                                    //     'Route Name ${_journey['routes_name']}');
                                    // print(
                                    //     'Route Name ${_assign_routes_controller.text}');
                                    if (_customer_controller.text.isEmpty) {
                                      show_msg('error',
                                          'Please Select Customer', context);
                                    } else {
                                      setState(() {
                                        _saving = true;
                                      });
                                      var location = await get_location();
                                      if (location != false) {
                                        var get_bettery =
                                            await battery.batteryLevel;
                                        var set_punched = await api.set_punched(
                                          user_id.toString(),
                                          location['lat'].toString(),
                                          location['long'].toString(),
                                          location['lat'].toString(),
                                          location['long'].toString(),
                                          get_bettery.toString(),
                                          '3',
                                          '',
                                          _customer_id_controller.text,
                                          (retailer_visit_puched == true)
                                              ? '0'
                                              : '1',
                                        );
                                        print('Set Punches ${set_punched}');

                                        if (set_punched['code_status'] ==
                                            true) {
                                          setState(() {
                                            _saving = false;
                                          });
                                          if (retailer_visit_puched == true) {
                                            _customer_controller.clear();
                                            show_msg(
                                                'success',
                                                'Successfully Punched Out',
                                                context);
                                          } else {
                                            show_msg(
                                                'success',
                                                'Successfully Punched In',
                                                context);
                                          }

                                          setState(() {
                                            if (retailer_visit_puched == true) {
                                              retailer_visit_puched = false;
                                            } else {
                                              retailer_visit_puched = true;
                                            }
                                          });
                                          setdata(retailer_visit_puched);
                                          setcustdata(_customer_controller.text,
                                              _customer_id_controller.text);
                                        } else {
                                          setState(() {
                                            _saving = false;
                                          });
                                          show_msg(
                                              'error',
                                              'Opps Something Wents Wrong',
                                              context);
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
                                    }
                                  },
                                  child: Image(
                                    height: 100,
                                    fit: BoxFit.contain,
                                    image: (retailer_visit_puched == true)
                                        ? AssetImage(
                                            'assets/images/punched_in.png',
                                          )
                                        : AssetImage(
                                            'assets/images/punched_out.png',
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black38, width: 1),
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: <BoxShadow>[]),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text('Select Route'),
                                isExpanded: true,
                                value: routeid,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: _journey.map((route) {
                                  return DropdownMenuItem(
                                    alignment: Alignment.centerLeft,
                                    child: Text(route['routes_name']),
                                    value: route['routes_id'].toString(),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    routeid = newValue as String?;
                                    // storeDropDown();
                                    print('ROUTE ID $routeid');
                                    //
                                    //
                                    // print(
                                    //     'ASSIGN ROUTE ID CONTROLLER ${_assign_routes_id_controller.text.toString()}');
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 18),
                      //   child: SizedBox(
                      //     child: TextFormField(
                      //       controller: _assign_routes_controller,
                      //       readOnly: true,
                      //       decoration: const InputDecoration(
                      //         // icon: Icon(Icons.person),
                      //         hintText: 'Your Routes',
                      //         labelText: 'Assigned Routes',
                      //         border: OutlineInputBorder(),
                      //       ),
                      //       onChanged: (value) {},
                      //       validator: (value) {},
                      //       onTap: () => {},
                      //     ),
                      //   ),
                      // ),
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
                              labelText: 'Retailer',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                // email = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "retailer  Is Required";
                              }
                              return null;
                            },
                            onTap: () => {
                              if (retailer_visit_puched == true)
                                {
                                  print('Please Punch out'),
                                  show_msg(
                                      'error', 'Please Punch Out', context),
                                }
                              else
                                {
                                  // print("IDS : " + session_distributor.toString()),
                                  // print("Routes : " + session_route_id.toString()),
                                  showMaterialModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return RetailerSearch(
                                          arr: _customer,
                                          controller: _customer_controller,
                                          id: _customer_id_controller,
                                          route_id:
                                              routeid ?? 'Retailer Required',
                                          // _assign_routes_id_controller.text,
                                          // route_id: session_route_id.toString(),
                                          distributor_id: '',
                                          caption: _caption_controller,
                                          // distributor_id: session_distributor.toString(),
                                        );
                                        setState(() {
                                          visited_caption =
                                              _caption_controller.text;
                                        });
                                      })
                                },
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShopsLocations(
                                      id: routeid!,
                                      // _assign_routes_id_controller.text),
                                    ),
                                  ),
                                )
                              },
                          child: Text('Map View')),
                      // Text(_assign_routes_controller.text),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Container(
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: Color(0xff87C440),
                            //       width: 1,
                            //     ),
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(10)),
                            //   ),
                            //   width:
                            //       (MediaQuery.of(context).size.width - 50) / 3 -
                            //           10,
                            //   // color: Colors.white,
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(4.0),
                            //     child: InkWell(
                            //       onTap: () => {
                            //         if (retailer_visit_puched == false ||
                            //             retailer_visit_puched == null)
                            //           {
                            //             show_msg(
                            //                 'error', 'Please Punch In', context)
                            //           }
                            //         else
                            //           {
                            //             Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                 builder: (context) => StockReport(
                            //                     customer: '0', type: 'retailer'),
                            //               ),
                            //             )
                            //           }
                            //       },
                            //       child: Card(
                            //         elevation: 0,
                            //         color: Colors.transparent,
                            //         child: Column(
                            //           children: [
                            //             SvgPicture.asset(
                            //               'assets/images/shape.svg',
                            //               width: 50,
                            //               height: 50,
                            //             ),
                            //             SizedBox(
                            //               height: 5,
                            //             ),
                            //             Column(
                            //               children: [
                            //                 SizedBox(
                            //                   height: 5,
                            //                 ),
                            //                 FittedBox(
                            //                   fit: BoxFit.fitWidth,
                            //                   child: Text(
                            //                     'Stocks',
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
                                onTap: () => {
                                  if (retailer_visit_puched == false ||
                                      retailer_visit_puched == null)
                                    {
                                      show_msg(
                                          'error', 'Please Punch In', context)
                                    }
                                  else
                                    {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddOrder(
                                              customer: 0, type: 'retailer'),
                                        ),
                                      )
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
                                              child: Text(
                                                'Add Order',
                                              ),
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
                                onTap: () => {
                                  if (retailer_visit_puched == false ||
                                      retailer_visit_puched == null)
                                    {
                                      show_msg(
                                          'error', 'Please Punch In', context)
                                    }
                                  else
                                    {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CustFeedback(
                                              customer: 0, type: 'retailer'),
                                        ),
                                      )
                                    }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
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
                                                child: Text(
                                                  'Feedback',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width - 50) / 3 -
                                      10,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff87C440),
                                  width: 1,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddCustomer(
                                          customer: 0, type: 'retailer'),
                                    ),
                                  );
                                  // Navigator.pushNamed(
                                  // context, '/add_customer/customer');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/add_customer.svg',
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
                                                child: Text(
                                                  'Customer',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
                        width: MediaQuery.of(context).size.width - 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Container(
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: Color(0xff87C440),
                            //       width: 1,
                            //     ),
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(10)),
                            //   ),
                            //   // width: 90,
                            //   width:
                            //       (MediaQuery.of(context).size.width - 50) / 3 -
                            //           10,
                            //   child: InkWell(
                            //     onTap: () => {
                            //       if (retailer_visit_puched == false ||
                            //           retailer_visit_puched == null)
                            //         {
                            //           show_msg(
                            //               'error', 'Please Punch In', context)
                            //         }
                            //       else
                            //         {
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //               builder: (context) => Payment(
                            //                   customer: 0, type: 'retailer'),
                            //             ),
                            //           )
                            //         }
                            //     },
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(4.0),
                            //       child: InkWell(
                            //         child: Card(
                            //           elevation: 0,
                            //           color: Colors.transparent,
                            //           child: Column(
                            //             children: [
                            //               SvgPicture.asset(
                            //                 'assets/images/payment.svg',
                            //                 width: 50,
                            //                 height: 50,
                            //               ),
                            //               SizedBox(
                            //                 height: 5,
                            //               ),
                            //               Column(
                            //                 children: [
                            //                   SizedBox(
                            //                     height: 5,
                            //                   ),
                            //                   FittedBox(
                            //                     fit: BoxFit.fitWidth,
                            //                     child: Text('Payments'),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff87C440),
                                  width: 1,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              // width: 90,
                              width:
                                  (MediaQuery.of(context).size.width - 50) / 3 -
                                      10,
                              child: InkWell(
                                onTap: () => {
                                  if (retailer_visit_puched == false ||
                                      retailer_visit_puched == null)
                                    {
                                      show_msg(
                                          'error', 'Please Punch In', context)
                                    }
                                  else
                                    {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Servey(
                                              customer: 0, type: 'retailer'),
                                        ),
                                      )
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
                                          'assets/images/survey_icon.svg',
                                          width: 50,
                                          height: 50,
                                          color: AppColors.ThemeColor,
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
                                              child: Text(
                                                'Survey',
                                              ),
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
                              // width: 90,
                              width:
                                  (MediaQuery.of(context).size.width - 50) / 3 -
                                      10,
                              child: InkWell(
                                onTap: () => {
                                  if (retailer_visit_puched == false ||
                                      retailer_visit_puched == null)
                                    {
                                      show_msg(
                                          'error', 'Please Punch In', context)
                                    }
                                  else
                                    {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Complain(
                                              customer: 0, type: 'retailer'),
                                        ),
                                      )
                                    }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
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
                                                child: Text(
                                                  'Complain',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
                                    if (retailer_visit_puched == false ||
                                        retailer_visit_puched == null)
                                      {
                                        show_msg(
                                            'error', 'Please Punch In', context)
                                      }
                                    else
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrderHistory(
                                                customer: '0',
                                                type: 'retailer'),
                                          ),
                                        )
                                      }
                                  },
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/history_icon.svg',
                                          width: 50,
                                          height: 50,
                                          color: AppColors.ThemeColor,
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
                                              child: Text(
                                                'Order History',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //////
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            // width: 90,
                            width:
                                (MediaQuery.of(context).size.width - 50) / 3 -
                                    10,
                            child: InkWell(
                              onTap: () => {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RetailerLstOrdHis(
                                      arr: _customer,
                                      controller: _customer_controller,
                                      id: _customer_id_controller,
                                      route_id: routeid ?? 'Retailer Required',
                                      // _assign_routes_id_controller.text,
                                      // route_id: session_route_id.toString(),
                                      distributor_id: '',
                                      caption: _caption_controller,
                                    ),
                                  ),
                                ),
                                // if (retailer_visit_puched == false ||
                                //     retailer_visit_puched == null)
                                //   {show_msg('error', 'Please Punch In', context)}
                                // else
                                //   {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) => RetailerLstOrdHis(
                                //           arr: _customer,
                                //           controller: _customer_controller,
                                //           id: _customer_id_controller,
                                //           route_id: routeid ?? 'Retailer Required',
                                //           // _assign_routes_id_controller.text,
                                //           // route_id: session_route_id.toString(),
                                //           distributor_id: '',
                                //           caption: _caption_controller,
                                //         ),
                                //       ),
                                //     )
                                //   }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
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
                                              child: Text(
                                                'Edit Customer',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
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
                            // width: 90,
                            width:
                                (MediaQuery.of(context).size.width - 50) / 3 -
                                    10,
                            child: InkWell(
                              onTap: () => {
                                ////
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderPlacedWajih(
                                            user_id: user_id!,
                                          )),
                                  ////
                                ),
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
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
                                              child: Text(
                                                'Order Placed',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width - 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Container(
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: Color(0xff87C440),
                            //       width: 1,
                            //     ),
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(10)),
                            //   ),
                            //   width:
                            //       (MediaQuery.of(context).size.width - 50) / 3 -
                            //           10,
                            //   child: InkWell(
                            //     onTap: () => {
                            //       if (retailer_visit_puched == false ||
                            //           retailer_visit_puched == null)
                            //         {
                            //           show_msg(
                            //               'error', 'Please Punch In', context)
                            //         }
                            //       else
                            //         {
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //               builder: (context) => AddOrder(
                            //                   customer: 0, type: 'retailer'),
                            //             ),
                            //           )
                            //         }
                            //     },
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(4.0),
                            //       child: Card(
                            //         elevation: 0,
                            //         color: Colors.transparent,
                            //         child: Column(
                            //           children: [
                            //             SvgPicture.asset(
                            //               'assets/images/order.svg',
                            //               width: 50,
                            //               height: 50,
                            //             ),
                            //             SizedBox(
                            //               height: 5,
                            //             ),
                            //             Column(
                            //               children: [
                            //                 SizedBox(
                            //                   height: 5,
                            //                 ),
                            //                 FittedBox(
                            //                   fit: BoxFit.fitWidth,
                            //                   child: Text(
                            //                     'Add Order',
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: Color(0xff87C440),
                            //       width: 1,
                            //     ),
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(10)),
                            //   ),
                            //   width:
                            //       (MediaQuery.of(context).size.width - 50) / 3 -
                            //           10,
                            //   child: InkWell(
                            //     onTap: () => {
                            //       if (retailer_visit_puched == false ||
                            //           retailer_visit_puched == null)
                            //         {
                            //           show_msg(
                            //               'error', 'Please Punch In', context)
                            //         }
                            //       else
                            //         {
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //               builder: (context) => CustFeedback(
                            //                   customer: 0, type: 'retailer'),
                            //             ),
                            //           )
                            //         }
                            //     },
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(4.0),
                            //       child: InkWell(
                            //         child: Card(
                            //           elevation: 0,
                            //           color: Colors.transparent,
                            //           child: Column(
                            //             children: [
                            //               SvgPicture.asset(
                            //                 'assets/images/feedback.svg',
                            //                 width: 50,
                            //                 height: 50,
                            //               ),
                            //               SizedBox(
                            //                 height: 5,
                            //               ),
                            //               Column(
                            //                 children: [
                            //                   SizedBox(
                            //                     height: 5,
                            //                   ),
                            //                   FittedBox(
                            //                     fit: BoxFit.fitWidth,
                            //                     child: Text(
                            //                       'Feedback',
                            //                     ),
                            //                   ),
                            //                 ],
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
                      // Container(
                      //   width: MediaQuery.of(context).size.width - 10,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         width:
                      //             (MediaQuery.of(context).size.width - 50) / 3 -
                      //                 10,
                      //       ),
                      //       Container(
                      //         width:
                      //             (MediaQuery.of(context).size.width - 50) / 3 -
                      //                 10,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: Color(0xff87C440),
                      //             width: 1,
                      //           ),
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10)),
                      //         ),
                      //         child: InkWell(
                      //           onTap: () {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                 builder: (context) => AddCustomer(
                      //                     customer: 0, type: 'retailer'),
                      //               ),
                      //             );

                      //             // Navigator.pushNamed(
                      //             // context, '/add_customer/customer');
                      //           },
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(4.0),
                      //             child: InkWell(
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
                      //                         SizedBox(
                      //                           height: 5,
                      //                         ),
                      //                         FittedBox(
                      //                           fit: BoxFit.fitWidth,
                      //                           child: Text('Customer'),
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
                      //         width:
                      //             (MediaQuery.of(context).size.width - 50) / 3 -
                      //                 10,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      // body: Center(
      //   child: SingleChildScrollView(
      //     child: Container(
      //       child: Column(
      //         children: [
      //           SizedBox(
      //             height: 40,
      //           ),
      //           Container(
      //             width: 350,
      //             child: Form(
      //               child: TextFormField(
      //                 controller: _customer_controller,
      //                 decoration: InputDecoration(
      //                   labelText: "Customer",
      //                   border: OutlineInputBorder(), //label text of field
      //                 ),
      //                 readOnly: true,
      //                 onChanged: (value) {
      //                   // subject = value;
      //                 },
      //                 // initialValue: cust_name,
      //                 validator: (value) {
      //                   if (value!.isEmpty) {
      //                     return "Customer Is Required";
      //                   }
      //                   return null;
      //                 },
      //                 onTap: () => {
      //                   if (customer_visit_punch == true)
      //                     {
      //                       print('Please Punch outr'),
      //                       show_msg('error', 'Please Punch Out', context)
      //                     }
      //                   else
      //                     {
      //                       showMaterialModalBottomSheet(
      //                         context: context,
      //                         builder: (BuildContext context) {
      //                           return StatefulBuilder(
      //                             builder: (BuildContext context,
      //                                 StateSetter setState) {
      //                               return Scaffold(
      //                                 appBar: AppBar(
      //                                   leading: IconButton(
      //                                     icon: Icon(Icons.arrow_back,
      //                                         color: Colors.black),
      //                                     onPressed: () =>
      //                                         Navigator.of(context).pop(),
      //                                   ),
      //                                   title: Text('Customers'),
      //                                   centerTitle: true,
      //                                 ),
      //                                 body: Column(
      //                                   children: [
      //                                     Padding(
      //                                       padding: const EdgeInsets.all(8.0),
      //                                       child: TextFormField(
      //                                         controller: _search_controller,
      //                                         decoration: InputDecoration(
      //                                           labelText: "Search Here",
      //                                           border:
      //                                               OutlineInputBorder(), //label text of field
      //                                         ),
      //                                         onChanged: (value) => {
      //                                           setState(() {
      //                                             search = value.toString();
      //                                             // toggleIcon = true;
      //                                           })
      //                                           // setModalState(() {
      //                                           //     search = value
      //                                           // });
      //                                         },
      //                                       ),
      //                                     ),
      //                                     Expanded(
      //                                       child: ListView.builder(
      //                                         scrollDirection: Axis.vertical,
      //                                         shrinkWrap: true,
      //                                         itemCount: _customer.length,
      //                                         itemBuilder:
      //                                             (BuildContext ctx, index) {
      //                                           if (_search_controller
      //                                               .text.isEmpty) {
      //                                             return InkWell(
      //                                               onTap: () {
      //                                                 if (_customer[index]
      //                                                         ['name'] !=
      //                                                     null) {
      //                                                   setState(() {
      //                                                     _customer_controller
      //                                                             .text =
      //                                                         _customer[index]
      //                                                                 ['name']
      //                                                             .toString();
      //                                                     selected_customer =
      //                                                         _customer[index]
      //                                                             ['id'];
      //                                                     // customer = _customer[index]['id']!;
      //                                                   });
      //                                                 }
      //                                                 Navigator.pop(context);
      //                                               },
      //                                               child: Card(
      //                                                 child: ListTile(
      //                                                   leading: Icon(
      //                                                       Icons.inventory_2),
      //                                                   title: Text(
      //                                                       _customer[index]
      //                                                           ['name']),
      //                                                   subtitle: Text(
      //                                                       _customer[index]
      //                                                           ["sales_type"]),
      //                                                 ),
      //                                               ),
      //                                             );
      //                                           } else if (_customer[index]
      //                                                   ['name']
      //                                               .toString()
      //                                               .toLowerCase()
      //                                               .contains(_search_controller
      //                                                   .text)) {
      //                                             return InkWell(
      //                                               onTap: () {
      //                                                 if (_customer[index]
      //                                                         ['name'] !=
      //                                                     null) {
      //                                                   setState(() {
      //                                                     _customer_controller
      //                                                             .text =
      //                                                         _customer[index]
      //                                                                 ['name']
      //                                                             .toString();
      //                                                     selected_customer =
      //                                                         _customer[index]
      //                                                             ['id'];
      //                                                     // customer = _customer[index]['id']!;
      //                                                   });
      //                                                 }
      //                                                 Navigator.pop(context);
      //                                               },
      //                                               child: Card(
      //                                                 child: ListTile(
      //                                                   leading: Icon(
      //                                                       Icons.inventory_2),
      //                                                   title: Text(
      //                                                       _customer[index]
      //                                                           ['name']),
      //                                                   subtitle: Text(
      //                                                       _customer[index]
      //                                                           ["sales_type"]),
      //                                                 ),
      //                                               ),
      //                                             );
      //                                           } else {
      //                                             return Container();
      //                                           }
      //                                         },
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               );
      //                             },
      //                           );
      //                         },
      //                       )
      //                     }
      //                 },
      //               ),
      //             ),
      //           ),
      //           SizedBox(
      //             height: 50,
      //           ),
      //           InkWell(
      //             onTap: () async {
      //               // print('change event');
      //               // showAlertDialog(context);
      //               if (_customer_controller.text.isEmpty) {
      //                 show_msg('error', 'Please Select Customer', context);
      //               } else {
      //                 EasyLoading.show(status: 'loading...');
      //                 var location = await get_location();
      //                 if (location != false) {
      //                   var set_punched = await api.set_punched(
      //                     user_id.toString(),
      //                     location['lat'].toString(),
      //                     location['long'].toString(),
      //                     location['lat'].toString(),
      //                     location['long'].toString(),
      //                     '70',
      //                     '3',
      //                     '',
      //                     '',
      //                     (customer_visit_punch == true) ? '0' : '1',
      //                   );
      //                   if (set_punched['code_status'] == true) {
      //                     EasyLoading.dismiss();
      //                     if (customer_visit_punch == true) {
      //                       show_msg(
      //                           'success', 'Sucessfully Punched Out', context);
      //                     } else {
      //                       show_msg(
      //                           'success', 'Sucessfully Punched In', context);
      //                     }

      //                     setState(() {
      //                       if (customer_visit_punch == true) {
      //                         customer_visit_punch = false;
      //                       } else {
      //                         customer_visit_punch = true;
      //                       }
      //                     });
      //                     setdata(customer_visit_punch);
      //                     setcustdata(
      //                         _customer_controller.text, selected_customer);
      //                   }
      //                 } else {
      //                   EasyLoading.dismiss();
      //                   show_msg(
      //                       'error', 'Location Blocked Please Enable', context);
      //                 }
      //               }
      //             },
      //             child: Icon(
      //               Icons.fingerprint_rounded,
      //               size: 50,
      //               color: (customer_visit_punch == true)
      //                   ? Colors.green
      //                   : Colors.black,
      //             ),
      //           ),
      //           SizedBox(height: 70),
      //           SizedBox(
      //             width: 350,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceAround,
      //               children: [
      //                 Center(
      //                   child: Container(
      //                     decoration: decoration,
      //                     child: Card(
      //                       elevation: 0,
      //                       child: SizedBox(
      //                         child: Padding(
      //                           padding: EdgeInsets.symmetric(
      //                               horizontal: 1, vertical: 5),
      //                           // padding: const EdgeInsets.all(0),
      //                           child: Column(children: [
      //                             Text("Total Visit"),
      //                             Text("100"),
      //                           ]),
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 Center(
      //                   child: Container(
      //                     decoration: decoration,
      //                     child: Card(
      //                       elevation: 0,
      //                       child: SizedBox(
      //                         child: Padding(
      //                           padding: const EdgeInsets.all(0),
      //                           child: Column(children: [
      //                             Text("Effective Visit"),
      //                             Text("73"),
      //                           ]),
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 Center(
      //                   child: Container(
      //                     decoration: decoration,
      //                     child: Card(
      //                       elevation: 0,
      //                       child: SizedBox(
      //                         child: Padding(
      //                           padding: const EdgeInsets.all(0),
      //                           child: Column(children: [
      //                             Text("Total Order"),
      //                             Text("64"),
      //                           ]),
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 Center(
      //                   child: Card(
      //                     elevation: 0,
      //                     child: SizedBox(
      //                       child: Padding(
      //                         padding: const EdgeInsets.all(0),
      //                         child: Column(children: [
      //                           Text("Order Amount"),
      //                           Text("3456545"),
      //                         ]),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           SizedBox(height: 30),
      //           SizedBox(
      //             width: 350,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               children: [
      //                 Expanded(
      //                   child: InkWell(
      //                     onTap: () {
      //                       Navigator.pushNamed(
      //                           context, '/add_customer/customer');
      //                     },
      //                     child: Container(
      //                       decoration: BoxDecoration(
      //                         boxShadow: [
      //                           BoxShadow(
      //                             color: Color(0xff8AC037), //New
      //                             blurRadius: 2.0,
      //                           )
      //                         ],
      //                         color: Colors.white,
      //                         borderRadius: BorderRadius.all(
      //                           Radius.circular(10),
      //                         ),
      //                       ),
      //                       height: 100,
      //                       child: Center(
      //                         child: Column(
      //                           children: [
      //                             SizedBox(height: 10),
      //                             Icon(
      //                               Icons.location_city,
      //                               size: 50,
      //                               color: Color(0xff8AC037),
      //                             ),
      //                             Center(child: Text("Add Customer"))
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 SizedBox(width: 10),
      //                 (customer_visit_punch == false ||
      //                         customer_visit_punch == null)
      //                     ? SizedBox()
      //                     : Expanded(
      //                         child: InkWell(
      //                           onTap: () {
      //                             Navigator.push(
      //                               context,
      //                               MaterialPageRoute(
      //                                 builder: (context) => StockReport(
      //                                     customer: 1, type: 'customer'),
      //                               ),
      //                             );
      //                             // Navigator.pushNamed(context, '/stock');
      //                           },
      //                           child: Container(
      //                             decoration: BoxDecoration(
      //                               boxShadow: [
      //                                 BoxShadow(
      //                                   color: Color(0xff8AC037), //New
      //                                   blurRadius: 2.0,
      //                                 )
      //                               ],
      //                               color: Colors.white,
      //                               borderRadius: BorderRadius.all(
      //                                 Radius.circular(10),
      //                               ),
      //                             ),
      //                             height: 100,
      //                             child: Center(
      //                               child: Column(
      //                                 children: [
      //                                   SizedBox(height: 10),
      //                                   Icon(
      //                                     Icons.add_box,
      //                                     size: 50,
      //                                     color: Color(0xff8AC037),
      //                                   ),
      //                                   Center(child: Text("Stock Report"))
      //                                 ],
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                 SizedBox(width: 10),
      //                 (customer_visit_punch == false ||
      //                         customer_visit_punch == null)
      //                     ? SizedBox()
      //                     : Expanded(
      //                         child: InkWell(
      //                           onTap: () {
      //                             Navigator.pushNamed(
      //                                 context, '/orders/add_orders/customer');
      //                           },
      //                           child: Container(
      //                             decoration: BoxDecoration(
      //                               boxShadow: [
      //                                 BoxShadow(
      //                                   color: Colors.grey, //New
      //                                   blurRadius: 2.0,
      //                                 )
      //                               ],
      //                               color: Colors.white,
      //                               borderRadius: BorderRadius.all(
      //                                 Radius.circular(15),
      //                               ),
      //                             ),
      //                             height: 100,
      //                             child: Center(
      //                               child: Column(
      //                                 children: [
      //                                   SizedBox(height: 20),
      //                                   Icon(
      //                                     Icons.local_airport,
      //                                     size: 40,
      //                                     color: Color(0xff8AC037),
      //                                   ),
      //                                   Text("Make Order")
      //                                 ],
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                 SizedBox(width: 10),
      //                 (customer_visit_punch == false ||
      //                         customer_visit_punch == null)
      //                     ? SizedBox()
      //                     : Expanded(
      //                         child: InkWell(
      //                           onTap: () {
      //                             Navigator.pushNamed(
      //                                 context, '/feedback/customer');
      //                           },
      //                           child: Container(
      //                             decoration: BoxDecoration(
      //                               boxShadow: [
      //                                 BoxShadow(
      //                                   color: Colors.grey, //New
      //                                   blurRadius: 2.0,
      //                                 )
      //                               ],
      //                               color: Colors.white,
      //                               borderRadius: BorderRadius.all(
      //                                 Radius.circular(15),
      //                               ),
      //                             ),
      //                             height: 100,
      //                             child: Center(
      //                               child: Column(
      //                                 children: [
      //                                   SizedBox(height: 20),
      //                                   Icon(
      //                                     Icons.inventory_2,
      //                                     size: 40,
      //                                     color: Color(0xff8AC037),
      //                                   ),
      //                                   Text("Feedback")
      //                                 ],
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //               ],
      //             ),
      //           ),
      //           SizedBox(
      //             height: 30,
      //           ),
      //           SizedBox(
      //             width: 350,
      //             child: (customer_visit_punch == false ||
      //                     customer_visit_punch == null)
      //                 ? SizedBox()
      //                 : Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                     children: [
      //                       Expanded(
      //                         child: InkWell(
      //                           onTap: () async {
      //                             Navigator.pushNamed(
      //                                 context, '/complain/add/customer');
      //                           },
      //                           child: Container(
      //                             decoration: BoxDecoration(
      //                               boxShadow: [
      //                                 BoxShadow(
      //                                   color: Colors.grey, //New
      //                                   blurRadius: 2.0,
      //                                 )
      //                               ],
      //                               color: Colors.white,
      //                               borderRadius: BorderRadius.all(
      //                                 Radius.circular(15),
      //                               ),
      //                             ),
      //                             height: 100,
      //                             child: Center(
      //                               child: Column(
      //                                 children: [
      //                                   SizedBox(height: 20),
      //                                   Icon(
      //                                     Icons.turn_slight_left_outlined,
      //                                     size: 40,
      //                                     color: Color(0xff8AC037),
      //                                   ),
      //                                   Text("Complain")
      //                                 ],
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                       SizedBox(width: 10),
      //                       Expanded(
      //                         child: InkWell(
      //                           onTap: () {
      //                             Navigator.pushNamed(
      //                                 context, '/payment/add/customer');
      //                           },
      //                           child: Container(
      //                             decoration: BoxDecoration(
      //                               boxShadow: [
      //                                 BoxShadow(
      //                                   color: Colors.grey, //New
      //                                   blurRadius: 2.0,
      //                                 )
      //                               ],
      //                               color: Colors.white,
      //                               borderRadius: BorderRadius.all(
      //                                 Radius.circular(15),
      //                               ),
      //                             ),
      //                             height: 100,
      //                             child: Center(
      //                               child: Column(
      //                                 children: [
      //                                   SizedBox(height: 20),
      //                                   Icon(
      //                                     Icons.money_outlined,
      //                                     size: 40,
      //                                     color: Color(0xff8AC037),
      //                                   ),
      //                                   Text("Collection")
      //                                 ],
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                       SizedBox(width: 10),
      //                       Expanded(
      //                         child: InkWell(
      //                           onTap: () async {
      //                             Navigator.pushNamed(
      //                                 context, '/servey/add/customer');
      //                           },
      //                           child: Container(
      //                             decoration: BoxDecoration(
      //                               boxShadow: [
      //                                 BoxShadow(
      //                                   color: Colors.grey, //New
      //                                   blurRadius: 2.0,
      //                                 )
      //                               ],
      //                               color: Colors.white,
      //                               borderRadius: BorderRadius.all(
      //                                 Radius.circular(15),
      //                               ),
      //                             ),
      //                             height: 100,
      //                             child: Center(
      //                               child: Column(
      //                                 children: [
      //                                   SizedBox(height: 20),
      //                                   Icon(
      //                                     Icons.motorcycle,
      //                                     size: 40,
      //                                     color: Color(0xff8AC037),
      //                                   ),
      //                                   Text("Servey")
      //                                 ],
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                       SizedBox(width: 10),
      //                       Expanded(
      //                         child: InkWell(
      //                           onTap: () {
      //                             Navigator.pushNamed(
      //                                 context, '/dispatch/add/customer');
      //                           },
      //                           child: Container(
      //                             decoration: BoxDecoration(
      //                               boxShadow: [
      //                                 BoxShadow(
      //                                   color: Colors.grey, //New
      //                                   blurRadius: 2.0,
      //                                 )
      //                               ],
      //                               color: Colors.white,
      //                               borderRadius: BorderRadius.all(
      //                                 Radius.circular(15),
      //                               ),
      //                             ),
      //                             height: 100,
      //                             child: Center(
      //                               child: Column(
      //                                 children: [
      //                                   SizedBox(height: 20),
      //                                   Icon(
      //                                     Icons.fire_truck,
      //                                     size: 40,
      //                                     color: Color(0xff8AC037),
      //                                   ),
      //                                   Text("Dispatch")
      //                                 ],
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  void getdata() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    user_name = prefs.getString('user_name');
    retailer_visit_puched = prefs.getBool('retailer_visit_punch');
    retailer_visit_id = prefs.getString('retailer_visit_id');
    RetailerVisit.customers_idss = retailer_visit_id!;
    retailer_visit_name = prefs.getString('retailer_visit_name');
    print('Retailer visit id $retailer_visit_id');
    print('Retailet visit id wajih ${RetailerVisit.customers_idss}');
    customer_ids = retailer_visit_id!;
    getCustomerdata();
    // session_route_id = prefs.getString('session_route_id');
    // session_route_name = prefs.getString('session_route_name');
    // session_distributor = prefs.getString('session_distributor_id');
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

void storeDropDown() {
  if (box1.get('route') != null) {
    box1.put('route', routeid);
    print('if store drop down');
  } else if (box1.get('route') == null) {
    box1.delete('route');
    // final routeid = box1.get('route')(0);
    print('else store drop down');
    box1.put('route', routeid);
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
    onDismissCallback: (type) {
      //for pdf Refresh the UI
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RetailerVisit()));
    },
    // dismissOnTouchOutside: false,
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
    btnOkOnPress: () {
      //for pdf Refresh the UI
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RetailerVisit()));
    },
  )..show();
}

class MyBottomSheet extends StatefulWidget {
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  bool _flag = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlutterLogo(
          size: 300,
          style: FlutterLogoStyle.stacked,
          textColor: _flag ? Colors.black : Colors.red,
        ),
        ElevatedButton(
          onPressed: () => setState(() => _flag = !_flag),
          child: Text('Change Color'),
        )
      ],
    );
  }
}
