import 'package:flutter/material.dart';
import 'retailer_visit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../helpers/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../helpers/location.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RoutePunch extends StatefulWidget {
  const RoutePunch({Key? key}) : super(key: key);

  @override
  _RoutePunchState createState() => _RoutePunchState();
}

class _RoutePunchState extends State<RoutePunch> {
  List _routes = [];
  bool _saving = false;
  List _distributor = [];
  String? user_id = '';
  String? user_name = '';
  String? session_type = '';
  String? session_distributor = '';
  String? session_route_id = '';
  String? session_route_name = '';
  bool? puched_in = false;
  bool? cust_puch = false;
  bool? routes_puched = false;
  bool? retailer_visit_puched = false;
  String? session_routes = '';

  String _distributor_id = '';
  var battery = Battery();

  SingingCharacter? _character = SingingCharacter.Direct;
  static _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'session_routes';
    final value = prefs.getString(key);
    print('saved tester $value');
    String usu = (value != null ? value : '');
    return usu;
  }

  static _get_session_distributor() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'session_distributor';
    final value = prefs.getString(key);
    print('saved tester $value');
    String usu = (value != null ? value : '');
    return usu;
  }

  static _get_session_type() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'session_type';
    final value = prefs.getString(key);
    print('saved tester $value');
    String usu = (value != null ? value : '');
    return usu;
  }

  TextEditingController _distributor_controller = new TextEditingController();
  TextEditingController _routes_controller = new TextEditingController();
  TextEditingController _search_controller = new TextEditingController();
  String search = '';
  Future<void> _fetchRoutes() async {
    var res = await api.get_routes('', '', '');
    if (res['code_status'] == true) {
      setState(
        () {
          _routes = res['routes'];
        },
      );
    }
  }

  Future<void> _fetchCustomer() async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_customers('', '', '', '', '', '', '');
    if (res['code_status'] == true) {
      setState(() {
        _saving = false;
      });
      setState(
        () {
          _distributor = res['customers'];
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _read();
    _get_session_distributor();
    _get_session_type();
    getdata();
    get_permission();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _routes_controller.text = await _read();
      _distributor_controller.text = await _get_session_distributor();
      var session_type = await _get_session_type();
      _character = (session_type == 'direct')
          ? SingingCharacter.Direct
          : SingingCharacter.Indirect;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_routes.isEmpty) {
      _fetchRoutes();
    }

    if (_distributor.isEmpty) {
      _fetchCustomer();
    }
    return WillPopScope(
      onWillPop: () {
        print('onWillPop');
        Navigator.of(context).pop();

        return Future.value(false);
      },
      child: Scaffold(
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
          child: Form(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
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
                          height: 40,
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
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 350,
                                                    child: ListTile(
                                                      title:
                                                          const Text('Direct'),
                                                      leading: Radio(
                                                        value: SingingCharacter
                                                            .Direct,
                                                        groupValue: _character,
                                                        onChanged:
                                                            (SingingCharacter?
                                                                value) {
                                                          setState(() {
                                                            _character = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 350,
                                                    child: ListTile(
                                                      title: const Text(
                                                          'In Direct'),
                                                      leading: Radio(
                                                        value: SingingCharacter
                                                            .Indirect,
                                                        groupValue: _character,
                                                        onChanged:
                                                            (SingingCharacter?
                                                                value) {
                                                          setState(() {
                                                            // print(value);
                                                            _character = value;
                                                            // _radio = value;
                                                            print(_character);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
                                      await getdata();
                                      if (routes_puched == true &&
                                          retailer_visit_puched == true) {
                                        setState(() {
                                          _saving = false;
                                        });
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.rightSlide,
                                          title: 'Error',
                                          desc:
                                              'Please Punch Our From Retailer Visit',
                                          // btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            Navigator.pushNamed(
                                                context, '/reatiler_visit');
                                          },
                                        )..show();

                                        return;
                                      }
                                      if (_character ==
                                              SingingCharacter.Indirect &&
                                          (_routes_controller.text.isEmpty ||
                                              _distributor_controller
                                                  .text.isEmpty)) {
                                        setState(() {
                                          _saving = false;
                                        });
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.rightSlide,
                                          title: 'Error',
                                          desc:
                                              'Please Enter Distributor And Routes',
                                          // btnCancelOnPress: () {},
                                          btnOkOnPress: () {},
                                        )..show();

                                        return;
                                      }
                                      if (_character ==
                                              SingingCharacter.Direct &&
                                          (_routes_controller.text.isEmpty)) {
                                        setState(() {
                                          _saving = false;
                                        });
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.rightSlide,
                                          title: 'Error',
                                          desc: 'Please Enter Route',
                                          // btnCancelOnPress: () {},
                                          btnOkOnPress: () {},
                                        )..show();

                                        return;
                                      }
                                      var location = await get_location();
                                      if (location != false) {
                                        // if (cust_puch == true) {
                                        //   EasyLoading.dismiss();
                                        //   show_msg('error', 'Please Punch Out From Route',
                                        //       context);
                                        // } else {
                                        var get_bettery =
                                            await battery.batteryLevel;
                                        var set_punched = await api.set_punched(
                                          user_id.toString(),
                                          location['lat'].toString(),
                                          location['long'].toString(),
                                          location['lat'].toString(),
                                          location['long'].toString(),
                                          get_bettery.toString(),
                                          '2',
                                          '',
                                          session_route_id.toString(),
                                          (routes_puched == true) ? '0' : '1',
                                        );
                                        if (set_punched['code_status'] ==
                                            true) {
                                          setState(() {
                                            _saving = false;
                                          });
                                          if (routes_puched == true) {
                                            show_msg(
                                                'success',
                                                'Sucessfully Punched Out',
                                                context);
                                          } else {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.success,
                                              animType: AnimType.scale,
                                              title: 'success',
                                              desc: 'Pucnhed in Successfully',
                                              dismissOnTouchOutside: false,
                                              // btnCancelOnPress: () {},
                                              btnOkOnPress: () {
                                                Navigator.pushNamed(
                                                    context, '/reatiler_visit');
                                              },
                                            )..show();
                                          }
                                          setState(() {
                                            if (routes_puched == true) {
                                              routes_puched = false;
                                            } else {
                                              routes_puched = true;
                                            }
                                          });
                                          var session_type = (_character ==
                                                  SingingCharacter.Direct)
                                              ? 'direct'
                                              : 'indirect';
                                          setdata(
                                              routes_puched,
                                              session_type,
                                              _distributor_controller.text,
                                              session_route_id,
                                              _routes_controller.text,
                                              (session_type != 'direct')
                                                  ? _distributor_id
                                                  : '');
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
                                    child: Image(
                                      height: 100,
                                      fit: BoxFit.contain,
                                      image: (routes_puched == true)
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
                        (_character == SingingCharacter.Direct)
                            ? SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: SizedBox(
                                  child: TextFormField(
                                    controller: _distributor_controller,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Distributor",
                                      border:
                                          OutlineInputBorder(), //label text of field
                                    ),
                                    readOnly: true,
                                    onChanged: (value) {
                                      // subject = value;
                                    },
                                    // initialValue: cust_name,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Distributor Is Required";
                                      }
                                      return null;
                                    },
                                    onTap: () => {
                                      showMaterialModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter setState) {
                                              return Scaffold(
                                                appBar: AppBar(
                                                  leading: IconButton(
                                                    icon: Icon(Icons.arrow_back,
                                                        color: Colors.black),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  ),
                                                  title: Text('Customers'),
                                                  centerTitle: true,
                                                ),
                                                body: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextFormField(
                                                        controller:
                                                            _search_controller,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Search Here",
                                                          border:
                                                              OutlineInputBorder(), //label text of field
                                                        ),
                                                        onChanged: (value) => {
                                                          setState(() {
                                                            search = value
                                                                .toString();
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
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            _distributor.length,
                                                        itemBuilder:
                                                            (BuildContext ctx,
                                                                index) {
                                                          if (_search_controller
                                                              .text.isEmpty) {
                                                            return InkWell(
                                                              onTap: () {
                                                                if (_distributor[
                                                                            index]
                                                                        [
                                                                        'name'] !=
                                                                    null) {
                                                                  setState(() {
                                                                    _distributor_controller
                                                                        .text = _distributor[index]
                                                                            [
                                                                            'name']
                                                                        .toString();
                                                                    // _distributor_controller =
                                                                    //     _distributor[
                                                                    //             index]
                                                                    //         [
                                                                    //         'id'];
                                                                    // customer = _customer[index]['id']!;'
                                                                    _distributor_id =
                                                                        _distributor[index]
                                                                            [
                                                                            'id']!;
                                                                  });
                                                                }
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Card(
                                                                child: ListTile(
                                                                  leading: Icon(
                                                                      Icons
                                                                          .inventory_2),
                                                                  title: Text(
                                                                      _distributor[
                                                                              index]
                                                                          [
                                                                          'name']),
                                                                  subtitle: Text(
                                                                      _distributor[
                                                                              index]
                                                                          [
                                                                          "sales_type"]),
                                                                ),
                                                              ),
                                                            );
                                                          } else if (_distributor[
                                                                  index]['name']
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(
                                                                  _search_controller
                                                                      .text)) {
                                                            return InkWell(
                                                              onTap: () {
                                                                if (_distributor[
                                                                            index]
                                                                        [
                                                                        'name'] !=
                                                                    null) {
                                                                  setState(() {
                                                                    _distributor_controller
                                                                        .text = _distributor[index]
                                                                            [
                                                                            'name']
                                                                        .toString();
                                                                    // _distributor_controller =
                                                                    //     _distributor[
                                                                    //             index]
                                                                    //         [
                                                                    //         'id'];

                                                                    _distributor_id =
                                                                        _distributor[index]
                                                                            [
                                                                            'id']!;
                                                                  });
                                                                }
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Card(
                                                                child: ListTile(
                                                                  leading: Icon(
                                                                      Icons
                                                                          .inventory_2),
                                                                  title: Text(
                                                                      _distributor[
                                                                              index]
                                                                          [
                                                                          'name']),
                                                                  subtitle: Text(
                                                                      _distributor[
                                                                              index]
                                                                          [
                                                                          "sales_type"]),
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            return Container();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      )
                                    },
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: SizedBox(
                            child: TextFormField(
                              controller: _routes_controller,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Routes",
                                border:
                                    OutlineInputBorder(), //label text of field
                              ),
                              readOnly: true,
                              onChanged: (value) {
                                // subject = value;
                              },
                              // initialValue: cust_name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Routes Is Required";
                                }
                                return null;
                              },
                              onTap: () => {
                                if (routes_puched == true)
                                  {
                                    print('Please Punch outr'),
                                    show_msg(
                                        'error', 'Please Punch Out', context)
                                  }
                                else
                                  {
                                    showMaterialModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.white,
                                      builder: (context) => Center(
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: _routes.length,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            return InkWell(
                                              onTap: () {
                                                if (_routes[index]['name'] !=
                                                    null) {
                                                  setState(() {
                                                    _routes_controller.text =
                                                        _routes[index]['name']
                                                            .toString();
                                                    session_route_id =
                                                        _routes[index]['id']
                                                            .toString();
                                                    // cust_id = _customer[index]['id'];
                                                    // customer = _customer[index]['id']!;
                                                  });
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Card(
                                                child: ListTile(
                                                  leading:
                                                      Icon(Icons.inventory_2),
                                                  title: Text(
                                                      _routes[index]['name']),
                                                  subtitle: Text(_routes[index]
                                                      ["address"]),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        // InkWell(
                        //   onTap: () async {
                        //     await getdata();
                        //     if (routes_puched == true &&
                        //         retailer_visit_puched == true) {
                        //       EasyLoading.dismiss();
                        //       AwesomeDialog(
                        //         context: context,
                        //         dialogType: DialogType.success,
                        //         animType: AnimType.rightSlide,
                        //         title: 'Error',
                        //         desc: 'Please Punch Our From Retailer Visit',
                        //         // btnCancelOnPress: () {},
                        //         btnOkOnPress: () {
                        //           Navigator.pushNamed(context, '/reatiler_visit');
                        //         },
                        //       )..show();

                        //       return;
                        //     }
                        //     var location = await get_location();
                        //     if (location != false) {
                        //       // if (cust_puch == true) {
                        //       //   EasyLoading.dismiss();
                        //       //   show_msg('error', 'Please Punch Out From Route',
                        //       //       context);
                        //       // } else {
                        //       var set_punched = await api.set_punched(
                        //         user_id.toString(),
                        //         location['lat'].toString(),
                        //         location['long'].toString(),
                        //         location['lat'].toString(),
                        //         location['long'].toString(),
                        //         '70',
                        //         '2',
                        //         '',
                        //         '',
                        //         (routes_puched == true) ? '0' : '1',
                        //       );
                        //       if (set_punched['code_status'] == true) {
                        //         EasyLoading.dismiss();
                        //         if (routes_puched == true) {
                        //           show_msg('success', 'Sucessfully Punched Out',
                        //               context);
                        //         } else {
                        //           AwesomeDialog(
                        //             context: context,
                        //             dialogType: DialogType.success,
                        //             animType: AnimType.scale,
                        //             title: 'success',
                        //             desc: 'Pucnhed in Successfully',
                        //             dismissOnTouchOutside: false,
                        //             // btnCancelOnPress: () {},
                        //             btnOkOnPress: () {
                        //               Navigator.pushNamed(
                        //                   context, '/reatiler_visit');
                        //             },
                        //           )..show();
                        //         }
                        //         setState(() {
                        //           if (routes_puched == true) {
                        //             routes_puched = false;
                        //           } else {
                        //             routes_puched = true;
                        //           }
                        //         });
                        //         var session_type =
                        //             (_character == SingingCharacter.Direct)
                        //                 ? 'direct'
                        //                 : 'indirect';
                        //         setdata(
                        //           routes_puched,
                        //           _routes_controller.text,
                        //           session_type,
                        //           _distributor_controller.text,
                        //           session_route_id,
                        //           _routes_controller.text,
                        //         );
                        //       }
                        //       // }
                        //     } else {
                        //       EasyLoading.dismiss();
                        //       show_msg('error', 'Location Blocked Please Enable',
                        //           context);
                        //     }
                        //   },
                        //   child: Icon(
                        //     Icons.fingerprint_rounded,
                        //     size: 50,
                        //     color: (routes_puched == true)
                        //         ? Colors.green
                        //         : Colors.black,
                        //   ),
                        // ),
                        SizedBox(height: 70),
                        (routes_puched == true)
                            ? ElevatedButton(
                                onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RetailerVisit(),
                                        ),
                                      )
                                    },
                                child: Text('Go To Retailer Visit'))
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getdata() async {
    setState(() {
      _saving = true;
    });
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    // cust_puch = prefs.getBool('cust_punched');
    routes_puched = prefs.getBool('routes_puched');
    session_routes = prefs.getString('session_routes');
    retailer_visit_puched = prefs.getBool('retailer_visit_punch');
    session_type = prefs.getString('session_type');
    session_distributor = prefs.getString('session_distributor');
    print('retailer_visit_puched');
    print(retailer_visit_puched);
    // print(session_routes);
    setState(() {});
    setState(() {
      _saving = false;
    });
  }

  Future<void> setdata(setValue, session_type, session_distributor,
      session_route_id, session_route_name, session_distributor_id) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('routes_puched', setValue);
    pref.setString('session_type', session_type);
    pref.setString('session_route_id', session_route_id);
    pref.setString('session_route_name', session_route_name);
    pref.setString('session_distributor', session_distributor);
    pref.setString('session_distributor_id', session_distributor_id);
  }
}
