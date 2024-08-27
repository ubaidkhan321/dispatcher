import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linear/screens/area_manager/stocks/stock_report.dart';
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
import '../../helpers/location.dart';
// import '../area_manager/stocks/stock_report.dart';
import 'package:battery_plus/battery_plus.dart';

import '../../search_widget/distributor_search.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CustomerVisit extends StatefulWidget {
  const CustomerVisit({Key? key}) : super(key: key);

  @override
  _CustomerVisitState createState() => _CustomerVisitState();
}

class _CustomerVisitState extends State<CustomerVisit> {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _typeAheadController = TextEditingController();
  TextEditingController _customer_controller = new TextEditingController();
  TextEditingController _search_controller = new TextEditingController();
  TextEditingController _customer_id_controller = new TextEditingController();

  int status = 0;
  bool? customer_visit_punch = false;
  String? user_id = '';
  String? user_name = '';
  String? customer_visit_name = '';
  String? customer_visit_id = '';
  String? session_customer_name = '';
  String selected_customer = '';
  bool _saving = false;

  bool toggleIcon = false;
  var battery = Battery();
  String search = '';
  List _customer = [];

  static _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'customer_visit_name';
    final value = prefs.getString(key);
    print('saved tester $value');
    // String my_customer = (widget.selected_customer_name != null) ? widget.selected_customer_name : '';
    String usu = (value != null ? value : '');
    return usu;
  }

  @override
  void initState() {
    // TODO: implement initState
    _read();
    getdata();
    // _fetchCustomer();
    get_permission();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _customer_controller.text = await _read();
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (_customer.isEmpty) {
    //   _fetchCustomer();
    // }
    // print(selected_customer);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/screen_bg.jpg',
                    ),
                    fit: BoxFit.cover),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
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
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 175,
                                      child: Card(
                                        elevation: 0,
                                        color: Color(0xff87C440),
                                        child: InkWell(
                                          onTap: () => {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddCustomer(
                                                        customer: 1,
                                                        type: 'customer'),
                                              ),
                                            )
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                                // Image(
                                                //   image: AssetImage(
                                                //     'assets/images/complain.png',
                                                //   ),
                                                // ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text('Add Customer'),
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
                            SizedBox(
                              width: 100,
                              child: InkWell(
                                onTap: () async {
                                  if (_customer_controller.text.isEmpty) {
                                    show_msg('error', 'Please Select Customer',
                                        context);
                                  } else {
                                    setState(() {
                                      _saving = true;
                                    });
                                    var get_bettery =
                                        await battery.batteryLevel;
                                    var location = await get_location();
                                    if (location != false) {
                                      go_punch() async {
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
                                          (customer_visit_punch == true)
                                              ? '0'
                                              : '1',
                                        );
                                        if (set_punched['code_status'] ==
                                            true) {
                                          setState(() {
                                            _saving = false;
                                          });
                                          if (customer_visit_punch == true) {
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
                                            if (customer_visit_punch == true) {
                                              customer_visit_punch = false;
                                            } else {
                                              customer_visit_punch = true;
                                            }
                                          });
                                          setdata(customer_visit_punch);
                                          setcustdata(_customer_controller.text,
                                              _customer_id_controller.text);
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

                                      // if (customer_visit_punch == false) {
                                      //   print(location['lat'].toString());
                                      //   print(location['long'].toString());
                                      //   var confirm_loaction =
                                      //       await api.confirm_location(
                                      //           location['lat'].toString(),
                                      //           location['long'].toString(),
                                      //           _customer_id_controller.text);
                                      //   if (confirm_loaction['code_status'] ==
                                      //       true) {
                                      //     var distance =
                                      //         confirm_loaction['customers'][0]
                                      //             ['distance_in_km'];
                                      //     if (double.parse(distance) > 1.00) {
                                      //       setState(() {
                                      //         _saving = false;
                                      //       });
                                      //       show_msg(
                                      //           'error',
                                      //           'Please Reached Shop First',
                                      //           context);
                                      //     } else {
                                      //       go_punch();
                                      //     }
                                      //   } else {
                                      //     show_msg(
                                      //         'error',
                                      //         'Confirmation Failed Please try Again',
                                      //         context);
                                      //   }
                                      //   print(confirm_loaction);
                                      // } else {
                                      //   go_punch();
                                      // }
                                      go_punch();
                                    }
                                  }
                                },
                                child: Image(
                                  height: 100,
                                  fit: BoxFit.contain,
                                  image: (customer_visit_punch == true)
                                      ? AssetImage(
                                          'assets/images/fingerprint_green.png',
                                        )
                                      : AssetImage(
                                          'assets/images/fingerprint_black.png',
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
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SizedBox(
                        child: TextFormField(
                          controller: _customer_controller,
                          readOnly: true,
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.person),
                            hintText: 'Select Distributor',
                            labelText: 'Distibutor',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              // email = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Username Is Required";
                            }
                            return null;
                          },
                          onTap: () => {
                            if (customer_visit_punch == true)
                              {show_msg('error', 'Please Punch Out', context)}
                            else
                              {
                                showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DistributorSearch(
                                          arr: _customer,
                                          controller: _customer_controller,
                                          id: _customer_id_controller);
                                    })
                              }
                            // if (customer_visit_punch == true)
                            //   {
                            //     print('Please Punch out'),
                            //     show_msg('error', 'Please Punch Out', context)
                            //   }
                            // else
                            //   {
                            //     showMaterialModalBottomSheet(
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         return StatefulBuilder(
                            //           builder: (BuildContext context,
                            //               StateSetter setState) {
                            //             return Scaffold(
                            //               appBar: AppBar(
                            //                 leading: IconButton(
                            //                   icon: Icon(Icons.arrow_back,
                            //                       color: Colors.black),
                            //                   onPressed: () =>
                            //                       Navigator.of(context).pop(),
                            //                 ),
                            //                 title: Text('Distributo'),
                            //                 centerTitle: true,
                            //                 actions: [
                            //                   InkWell(
                            //                     onTap: () => async{
                            //                       if (_search_controller
                            //                           .text.isEmpty)
                            //                         {
                            //                           setState(
                            //                             () => {
                            //                               _fetchCustomer(),
                            //                               _customer = []
                            //                             },
                            //                           )
                            //                         }
                            //                       else
                            //                         {
                            //                           _fetchCustomer_with_text(
                            //                               _search_controller.text
                            //                                   .toString()),
                            //                         }
                            //                     },
                            //                     child: Icon(Icons.search),
                            //                   ),
                            //                 ],
                            //               ),
                            //               body: Column(
                            //                 children: [
                            //                   Padding(
                            //                     padding:
                            //                         const EdgeInsets.all(8.0),
                            //                     child: TextFormField(
                            //                       controller: _search_controller,
                            //                       decoration: InputDecoration(
                            //                         labelText: "Search Here",
                            //                         border:
                            //                             OutlineInputBorder(), //label text of field
                            //                       ),
                            //                       onChanged: (value) => {
                            //                         setState(() {
                            //                           search = value.toString();
                            //                           // toggleIcon = true;
                            //                         })
                            //                         // setModalState(() {
                            //                         //     search = value
                            //                         // });
                            //                       },
                            //                     ),
                            //                   ),
                            //                   Expanded(
                            //                     child: ListView.builder(
                            //                       scrollDirection: Axis.vertical,
                            //                       shrinkWrap: true,
                            //                       itemCount: _customer.length,
                            //                       itemBuilder:
                            //                           (BuildContext ctx, index) {
                            //                         return InkWell(
                            //                           onTap: () {
                            //                             if (_customer[index]
                            //                                     ['name'] !=
                            //                                 null) {
                            //                               setState(() {
                            //                                 _customer_controller
                            //                                         .text =
                            //                                     _customer[index]
                            //                                             ['name']
                            //                                         .toString();
                            //                                 selected_customer =
                            //                                     _customer[index]
                            //                                         ['id'];
                            //                                 // customer = _customer[index]['id']!;
                            //                               });
                            //                             }
                            //                             Navigator.pop(context);
                            //                           },
                            //                           child: Card(
                            //                             child: ListTile(
                            //                               leading: Icon(
                            //                                   Icons.inventory_2),
                            //                               title: Text(
                            //                                   _customer[index]
                            //                                       ['name']),
                            //                               subtitle: Text(
                            //                                   _customer[index]
                            //                                       ["sales_type"]),
                            //                             ),
                            //                           ),
                            //                         );
                            //                         // if (_search_controller
                            //                         //     .text.isEmpty) {
                            //                         //   return InkWell(
                            //                         //     onTap: () {
                            //                         //       if (_customer[index]
                            //                         //               ['name'] !=
                            //                         //           null) {
                            //                         //         setState(() {
                            //                         //           _customer_controller
                            //                         //                   .text =
                            //                         //               _customer[index]
                            //                         //                       ['name']
                            //                         //                   .toString();
                            //                         //           selected_customer =
                            //                         //               _customer[index]
                            //                         //                   ['id'];
                            //                         //           // customer = _customer[index]['id']!;
                            //                         //         });
                            //                         //       }
                            //                         //       Navigator.pop(context);
                            //                         //     },
                            //                         //     child: Card(
                            //                         //       child: ListTile(
                            //                         //         leading: Icon(Icons
                            //                         //             .inventory_2),
                            //                         //         title: Text(
                            //                         //             _customer[index]
                            //                         //                 ['name']),
                            //                         //         subtitle: Text(
                            //                         //             _customer[index][
                            //                         //                 "sales_type"]),
                            //                         //       ),
                            //                         //     ),
                            //                         //   );
                            //                         // } else if (_customer[index]
                            //                         //         ['name']
                            //                         //     .toString()
                            //                         //     .toLowerCase()
                            //                         //     .contains(
                            //                         //         _search_controller
                            //                         //             .text)) {
                            //                         //   return InkWell(
                            //                         //     onTap: () {
                            //                         //       if (_customer[index]
                            //                         //               ['name'] !=
                            //                         //           null) {
                            //                         //         setState(() {
                            //                         //           _customer_controller
                            //                         //                   .text =
                            //                         //               _customer[index]
                            //                         //                       ['name']
                            //                         //                   .toString();
                            //                         //           selected_customer =
                            //                         //               _customer[index]
                            //                         //                   ['id'];
                            //                         //           // customer = _customer[index]['id']!;
                            //                         //         });
                            //                         //       }
                            //                         //       Navigator.pop(context);
                            //                         //     },
                            //                         //     child: Card(
                            //                         //       child: ListTile(
                            //                         //         leading: Icon(Icons
                            //                         //             .inventory_2),
                            //                         //         title: Text(
                            //                         //             _customer[index]
                            //                         //                 ['name']),
                            //                         //         subtitle: Text(
                            //                         //             _customer[index][
                            //                         //                 "sales_type"]),
                            //                         //       ),
                            //                         //     ),
                            //                         //   );
                            //                         // } else {
                            //                         //   return Container();
                            //                         // }
                            //                       },
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             );
                            //           },
                            //         );
                            //       },
                            //     ),
                            //   },
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff87C440),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              width: 80,
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            width: 50,
                                            child: CircularPercentIndicator(
                                              radius: 20.0,
                                              lineWidth: 4.0,
                                              percent: 0.8,
                                              header: Center(
                                                child: new Text(
                                                  "Total Visit",
                                                  style: TextStyle(fontSize: 8),
                                                ),
                                              ),
                                              footer: Text('100'),
                                              backgroundColor: Colors.grey,
                                              progressColor: Colors.blue,
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
                              width: 80,
                              margin: const EdgeInsets.only(top: 10.0),
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            width: 50,
                                            child: CircularPercentIndicator(
                                              radius: 20.0,
                                              lineWidth: 4.0,
                                              percent: 0.8,
                                              header: Center(
                                                child: new Text(
                                                  "Effective Visit",
                                                  style: TextStyle(fontSize: 8),
                                                ),
                                              ),
                                              footer: Text('100'),
                                              backgroundColor: Colors.grey,
                                              progressColor: Colors.blue,
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
                              width: 80,
                              margin: const EdgeInsets.only(top: 10.0),
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            width: 50,
                                            child: CircularPercentIndicator(
                                              radius: 20.0,
                                              lineWidth: 4.0,
                                              percent: 0.8,
                                              header: Center(
                                                child: new Text(
                                                  "Total Orders",
                                                  style: TextStyle(fontSize: 8),
                                                ),
                                              ),
                                              footer: Text('100'),
                                              backgroundColor: Colors.grey,
                                              progressColor: Colors.blue,
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
                              width: 80,
                              margin: const EdgeInsets.only(top: 10.0),
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            width: 50,
                                            child: CircularPercentIndicator(
                                              radius: 20.0,
                                              lineWidth: 4.0,
                                              percent: 0.8,
                                              header: Center(
                                                child: new Text(
                                                  "Order Amount",
                                                  style: TextStyle(fontSize: 8),
                                                ),
                                              ),
                                              footer: Text('100000'),
                                              backgroundColor: Colors.grey,
                                              progressColor: Colors.blue,
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
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Container(
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
                            width: 90,
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () => {
                                    if (customer_visit_punch == false ||
                                        customer_visit_punch == null)
                                      {
                                        show_msg(
                                            'error', 'Please Punch In', context)
                                      }
                                    else
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StockReport(
                                                customer: '1',
                                                type: 'customer'),
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
                                            Text(
                                              'Stock',
                                            ),
                                            Text(
                                              'Report',
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
                            width: 90,
                            child: InkWell(
                              onTap: () => {
                                if (customer_visit_punch == false ||
                                    customer_visit_punch == null)
                                  {
                                    show_msg(
                                        'error', 'Please Punch In', context)
                                  }
                                else
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddOrder(
                                            customer: 1, type: 'customer'),
                                      ),
                                    )
                                  }
                              },
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
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
                                            Text(
                                              'Add',
                                            ),
                                            Text(
                                              'Order',
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
                            width: 90,
                            child: InkWell(
                              onTap: () => {
                                if (customer_visit_punch == false ||
                                    customer_visit_punch == null)
                                  {
                                    show_msg(
                                        'error', 'Please Punch In', context)
                                  }
                                else
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CustFeedback(
                                            customer: 1, type: 'customer'),
                                      ),
                                    )
                                  }
                              },
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
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
                                              Text(
                                                'Add',
                                              ),
                                              Text(
                                                'Feedbacks',
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
                            width: 90,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddCustomer(
                                        customer: 1, type: 'customer'),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    child: Card(
                                      elevation: 0,
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
                                              Text(
                                                'Add',
                                              ),
                                              Text(
                                                'Customer',
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
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
                            width: 90,
                            child: InkWell(
                              onTap: () => {
                                if (customer_visit_punch == false ||
                                    customer_visit_punch == null)
                                  {
                                    show_msg(
                                        'error', 'Please Punch In', context)
                                  }
                                else
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Payment(
                                            customer: 1, type: 'customer'),
                                      ),
                                    )
                                  }
                              },
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    child: Card(
                                      elevation: 0,
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
                                              Text(
                                                'Payments',
                                              ),
                                              Text(
                                                'Collection',
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
                            width: 90,
                            child: InkWell(
                              onTap: () => {
                                if (customer_visit_punch == false ||
                                    customer_visit_punch == null)
                                  {
                                    show_msg(
                                        'error', 'Please Punch In', context)
                                  }
                                else
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Servey(
                                            customer: 1, type: 'customer'),
                                      ),
                                    )
                                  }
                              },
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Card(
                                    elevation: 0,
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/servey.svg',
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
                                            Text(
                                              'Add',
                                            ),
                                            Text(
                                              'Servey',
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
                          // Container(
                          //   decoration: BoxDecoration(
                          //     border: Border.all(
                          //       color: Color(0xff87C440),
                          //       width: 1,
                          //     ),
                          //     borderRadius: BorderRadius.all(Radius.circular(10)),
                          //   ),
                          //   width: 80,
                          //   child: Card(
                          //     elevation: 0,
                          //     color: Colors.transparent,
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(4.0),
                          //       child: InkWell(
                          //         child: Card(
                          //           elevation: 0,
                          //           child: Column(
                          //             children: [
                          //               Image(
                          //                 height: 50,
                          //                 fit: BoxFit.fill,
                          //                 image: AssetImage(
                          //                   'assets/images/stock.png',
                          //                 ),
                          //               ),
                          //               Column(
                          //                 children: [
                          //                   Text(
                          //                     'Stock',
                          //                     style: TextStyle(fontSize: 11),
                          //                   ),
                          //                   Text(
                          //                     'Report',
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
                            width: 90,
                            child: InkWell(
                              onTap: () => {
                                if (customer_visit_punch == false ||
                                    customer_visit_punch == null)
                                  {
                                    show_msg(
                                        'error', 'Please Punch In', context)
                                  }
                                else
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Complain(
                                            customer: 1, type: 'customer'),
                                      ),
                                    )
                                  }
                              },
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    child: Card(
                                      elevation: 0,
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
                                              Text(
                                                'Create',
                                              ),
                                              Text(
                                                'Compain',
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
    customer_visit_punch = prefs.getBool('customer_visit_punch');
    customer_visit_id = prefs.getString('customer_visit_id');
    print("Customer Id" + customer_visit_id.toString());
    customer_visit_name = prefs.getString('customer_visit_name');
    setState(() {});
  }

  Future<void> setdata(setValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('customer_visit_punch', setValue);
  }

  Future<void> setcustdata(cust_name, cust_id) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('customer_visit_name', cust_name);
    pref.setString('customer_visit_id', cust_id);
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
    desc: message,
    // btnCancelOnPress: () {},
    btnOkOnPress: () {},
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
