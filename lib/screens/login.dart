import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linear/screens/snackbar.dart';
import 'order_booker/dashboard.dart';
import 'area_manager/am_dashboard.dart';
import 'delivery_person/dp_dashboard.dart';
import '../helpers/api.dart';
import '../helpers/globals.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Login extends StatefulWidget {
  // static var order_booker_name;
  static var warehouseid_login;
  final String login_type;
  const Login({Key? key, required this.login_type}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String order_booker_name = '';
  bool _show_pass = false;
  bool _saving = false;
  String email = '';
  String password = '';
  String? user_id = '';
  var res;
  String? user_group = '';
  // var order_booker_name = '';

  bool onetime = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static _read(key_) async {
    final prefs = await SharedPreferences.getInstance();
    final key = key_;
    final value = prefs.getString(key);
    print('saved tester login.dart $value');
    // String my_customer = (widget.selected_customer_name != null) ? widget.selected_customer_name : '';
    String usu = (value != null ? value : '');
    return usu;
  }

  @override
  void initState() {
    // super.initState();
    _read('user_id');
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   print('The Userid  : ');
    //   print(await _read('user_id'));
    //   print('The UserGroup  : ');
    //   print(await _read('user_group'));
    //   if (await _read('user_id') != '') {
    //     if (await _read('user_group') == 'order_booker') {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => Dashboard(),
    //           // builder: (context) => AmDashboard(),
    //         ),
    //       );
    //     } else if (await _read('user_group') == 'area_manager') {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //           // builder: (context) => Dashboard(),
    //           builder: (context) => AmDashboard(),
    //         ),
    //       );
    //     }
    //   }
    //   // await print('The User Id : ' + user_id.toString());
    //   // print('The User id : ' + user_id);
    // });

    // TODO: implement initState
    // _read();
    // getdata();
    // print('User Id  : ' + user_id.toString());
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   if (_read() != '') {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => Dashboard(),
    //       ),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Material(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/screen_bg.jpg',
                    ),
                    fit: BoxFit.fill),
              ),
              padding: EdgeInsets.only(top: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Image(
                        height: 200,
                        fit: BoxFit.contain,
                        image: AssetImage(
                          'assets/images/distrho_logo_green.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: const InputDecoration(
                          // icon: Icon(Icons.person),
                          hintText: 'Enter username',
                          labelText: 'username',
                          border: OutlineInputBorder(),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                                top: 0), // add padding to adjust icon
                            child: Icon(Icons.man),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Username Is Required";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: 'Enter Your Password',
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _show_pass = !_show_pass;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 0), // add padding to adjust icon
                              child: Icon((_show_pass == true)
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                        ),
                        obscureText: !_show_pass,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password Is Required";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xff87C440), // Background color
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _saving = true;
                            });

                            // 3 area manager
                            // 4 booker
                            // 5 delivery man
                            String _group_id = '0';
                            if (widget.login_type == 'order_booker') {
                              _group_id = '4';
                            } else if (widget.login_type == 'area_manager') {
                              _group_id = '3';
                            } else if (widget.login_type == 'delivery_person') {
                              _group_id = '5';
                            }
                            res = await api.login(email, password, _group_id);
                            print('wajih login Data  $res');

                            if (res['code_status'] == true) {
                              setdata(
                                  res['login_data']['id'],
                                  res['login_data']['username'],
                                  (res['login_data']['warehouse_id'] != null)
                                      ? res['login_data']['warehouse_id']
                                      : globals.default_werehouse,
                                  widget.login_type.toString());
                              //
                              order_booker_name =
                                  res['login_data']['first_name'];
                              print(
                                  'Login order booker name $order_booker_name');
                              print(
                                  'Warehouse ID ${res['login_data']['warehouse_id']}');
                              Login.warehouseid_login =
                                  res['login_data']['warehouse_id'];

                              setState(() {
                                _saving = false;
                              });
                              showInSnackBar('Login Successfully');
                              if (widget.login_type == 'order_booker') {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => Dashboard())));
                              } else if (widget.login_type == 'area_manager') {
                                // Navigator.pushNamed(context, '/am_dashboard');
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => AmDashboard())));
                              } else if (widget.login_type ==
                                  'delivery_person') {
                                // Navigator.pushNamed(context, '/am_dashboard');
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => DpDashboard())));
                              }
                            } else {
                              setState(() {
                                _saving = false;
                              });
                              showInSnackBar('Invalid Credientials',
                                  color: Colors.red);
                            }
                          }
                          // MoveTohome(context);
                        },
                        child: Text('Login'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // return Material(
    //   child: Form(
    //     key: _formKey,
    //     child: Column(
    //       children: [
    //         SizedBox(height: 50),
    //         Image(
    //           height: 150,
    //           fit: BoxFit.contain,
    //           image: AssetImage(
    //             'assets/images/logo.png',
    //           ),
    //         ),
    //         Text(
    //           "Login",
    //           style: TextStyle(fontSize: 40),
    //         ),
    //         SizedBox(height: 30),
    //         SizedBox(
    //           width: 300,
    //           child: TextFormField(
    //             decoration: const InputDecoration(
    //               // icon: Icon(Icons.person),
    //               hintText: 'Enter username',
    //               labelText: 'User Name',
    //               border: OutlineInputBorder(),
    //             ),
    //             onChanged: (value) {
    //               setState(() {
    //                 email = value;
    //               });
    //             },
    //             validator: (value) {
    //               if (value!.isEmpty) {
    //                 return "Username Is Required";
    //               }
    //               return null;
    //             },
    //           ),
    //         ),
    //         SizedBox(height: 50),
    //         SizedBox(
    //           width: 300,
    //           child: TextFormField(
    //             decoration: const InputDecoration(
    //               hintText: 'Enter Your Password',
    //               labelText: 'Password',
    //               border: OutlineInputBorder(),
    //             ),
    //             obscureText: true,
    //             onChanged: (value) {
    //               setState(() {
    //                 password = value;
    //               });
    //             },
    //             validator: (value) {
    //               if (value!.isEmpty) {
    //                 return "Password Is Required";
    //               }
    //               return null;
    //             },
    //           ),
    //         ),
    //         SizedBox(height: 50),
    //         ElevatedButton(
    //           onPressed: () async {
    //             if (_formKey.currentState!.validate()) {
    //               EasyLoading.show(status: 'loading...');
    //               var res = await api.login(email, password);
    //               if (res['code_status'] == true) {
    //                 setdata(
    //                   res['login_data']['id'],
    //                   res['login_data']['username'],
    //                   (res['login_data']['warehouse_id'] != null)
    //                       ? res['login_data']['warehouse_id']
    //                       : globals.default_werehouse,
    //                 );
    //                 EasyLoading.dismiss();
    //                 AwesomeDialog(
    //                   context: context,
    //                   dialogType: DialogType.success,
    //                   animType: AnimType.scale,
    //                   title: 'success',
    //                   desc: 'Login Successful',
    //                   dismissOnTouchOutside: false,
    //                   // btnCancelOnPress: () {},
    //                   btnOkOnPress: () {
    //                     Navigator.pushNamed(context, '/dashboard');
    //                   },
    //                 )..show();
    //               } else {
    //                 EasyLoading.dismiss();
    //                 AwesomeDialog(
    //                   context: context,
    //                   dialogType: DialogType.error,
    //                   animType: AnimType.scale,
    //                   dismissOnTouchOutside: false,
    //                   title: 'Error',
    //                   desc: res['message'],
    //                   // btnCancelOnPress: () {},
    //                   btnOkOnPress: () {},
    //                 )..show();
    //               }
    //             }
    //             // MoveTohome(context);
    //           },
    //           child: Text('Login'),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }

  Future<void> setdata(user_id, user_name, werehouse_id, user_group) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('user_id', user_id);
    pref.setString('email', res['login_data']['email']);
    pref.setString('user_name', user_name);
    pref.setString('group', user_group);
    pref.setString('werehouse_id', werehouse_id);
    pref.setBool('punched', false);
    pref.setString('order_booker_name', order_booker_name);
  }

  void getdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id');
      user_group = prefs.getString('group');
    });
  }
}
