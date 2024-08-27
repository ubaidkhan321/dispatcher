import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linear/PdfData/utils/flush.dart';
import 'package:linear/helpers/location.dart';
import 'package:linear/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'area_manager/am_dashboard.dart';
import 'login.dart';
import 'order_booker/dashboard.dart';

class LoginAs extends StatefulWidget {
  const LoginAs({Key? key}) : super(key: key);

  @override
  _LoginAsState createState() => _LoginAsState();
}

class _LoginAsState extends State<LoginAs> {
  static _read(key_) async {
    final prefs = await SharedPreferences.getInstance();
    final key = key_;
    final value = prefs.getString(key);
    print('saved tester Login_as.dart $value');
    print("Order Booker Id $value");
    // String my_customer = (widget.selected_customer_name != null) ? widget.selected_customer_name : '';
    String usu = (value != null ? value : '');
    return usu;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                scrollable: true,
                // title: Text('Alert Dialog Title'),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '- Utilize foreground services to seamlessly retrieve and track the current location of the order booker within the app background.',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "- When the order booker reaches the selected customer, they can use the punch-in feature specifically designed for the selected location.",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the Dialog
                      },
                      child: Text('Deny')),
                  // TextButton(
                  //   onPressed: () {
                  //     // TODO: Add logic for the button
                  //     Navigator.of(context).pop(); // Close the dialog
                  //   },
                  //   child: Text('Deny'),
                  // ),
                  ElevatedButton(
                      onPressed: () async {
                        // TODO: Add logic for the button
                        bool isLocationPermitted =
                            await _requestLocationPermission();
                        //
                        if (isLocationPermitted) {
                          print('Location Permitted $isLocationPermitted');
                          // TODO: Add logic for accept button
                          print('Location permission granted!');
                          //
                          // flushs.flushbarmessagegreen(
                          //     'Location permission granted!', context);

                          Navigator.pop(context); // Close the Dialog

                          //
                        } else {
                          // TODO: Handle case where permission is not granted
                          print('Location permission denied.');
                          //
                          flushs.flushbarmessagered(
                              'Location permission denied!', context);
                        }
                      },
                      child: Text(
                        'Accept',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
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
            ),
            Column(
              children: [
                SizedBox(
                  height: 40,
                ),
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
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Login As',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff87C440),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  decoration: BoxDecoration(
                      color: Color(0xff87C440),
                      borderRadius: BorderRadius.circular(3)),
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Login(login_type: 'area_manager'),
                        ),
                      )
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: ListTile(
                        leading: Icon(
                          Icons.attribution,
                          color: Colors.white,
                          size: 50,
                        ),
                        tileColor: Color(0xff87C440),
                        title: Center(
                            child: Text(
                          "Area Manager",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        )),
                        trailing:
                            Icon(Icons.arrow_forward, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  decoration: new BoxDecoration(
                      color: Color(0xff87C440),
                      borderRadius: BorderRadius.circular(3)),
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Login(login_type: 'order_booker'),
                        ),
                      )
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: ListTile(
                        leading: Icon(
                          Icons.all_inbox_sharp,
                          color: Colors.white,
                          size: 50,
                        ),
                        tileColor: Color(0xff87C440),
                        title: Center(
                            child: Text(
                          "Order Booker",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        )),
                        trailing:
                            Icon(Icons.arrow_forward, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  decoration: new BoxDecoration(
                      color: Color(0xff87C440),
                      borderRadius: BorderRadius.circular(3)),
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Login(login_type: 'delivery_person'),
                        ),
                      )
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: ListTile(
                        leading: Icon(
                          Icons.emoji_transportation,
                          color: Colors.white,
                          size: 50,
                        ),
                        tileColor: Color(0xff87C440),
                        title: Center(
                            child: Text("Dispatcher",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22))),
                        trailing:
                            Icon(Icons.arrow_forward, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _requestLocationPermission() async {
    var status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }
}
