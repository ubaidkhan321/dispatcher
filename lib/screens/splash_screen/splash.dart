import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:linear/screens/login.dart';
import 'package:linear/screens/order_booker/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../area_manager/am_dashboard.dart';
import '../delivery_person/dp_dashboard.dart';
import '../login_as.dart';

class Splash extends StatefulWidget {
  static var order_booker_name;
  // static var warehouse_ids;

  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  static _read(key_) async {
    final prefs = await SharedPreferences.getInstance();
    final key = key_;
    final value = prefs.getString(key);
    print('saved tester splash.dart $value');
    // String my_customer = (widget.selected_customer_name != null) ? widget.selected_customer_name : '';
    String usu = (value != null ? value : '');
    return usu;
  }

  // @override
  @override
  void initState() {
    super.initState();
    NavigateToHome();
    get_orderbooker_data();
  }

  Future<void> get_orderbooker_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var orderbooker_name = prefs.getString('order_booker_name');
    Splash.order_booker_name = orderbooker_name;
    print('Order Booker name ka bacha ${Splash.order_booker_name}');
  }

  NavigateToHome() async {
    var user_id = await _read('user_id');
    var warehouse_id = await _read('werehouse_id');

    print('Warehouse ID yoo $warehouse_id');
    Login.warehouseid_login = warehouse_id;
    var user_group = await _read('group');
    Dashboard.user_idss = user_id;
    print('Static User Id Splash.dart ${Dashboard.user_idss}');
    print("THE USER ID IS SPLASH $user_id");
    print("THE USER GROUP IS SPLASH $user_group");
    await Future.delayed(Duration(milliseconds: 1500), () {
      print('IN AWAIT CLOUSE ');
      setState(() {
        if (user_id != '') {
          if (user_group == 'order_booker') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) => Dashboard())));
          } else if (user_group == 'area_manager') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) => AmDashboard())));
          } else if (user_group == 'delivery_person') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) => DpDashboard())));
          }
        } else {
          print('Code To be Exevuted');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: ((context) => LoginAs())));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(children: [
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/distrho_logo_green.png'),
                    fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            top: -50.0,
            right: 0.0,
            child: Container(
              width: 550,
              child: Image(
                image: AssetImage(
                  'assets/images/splash_up.png',
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50.0,
            left: 0.0,
            child: Container(
              width: 550,
              child: Image(
                image: AssetImage(
                  'assets/images/splash_down.png',
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
