// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:linear/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login_as.dart';

class DrawerNavigate extends StatelessWidget {
  final String dashboardss;
  String? emails;
  String? names;
  DrawerNavigate({Key? key, required this.dashboardss, this.emails, this.names})
      : super(key: key);

  Future<void> remove_session() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(children: [
          SizedBox(
            height: 25,
          ),
          Container(
            height: 130,
            decoration: BoxDecoration(
                color: Color(0xff87C440),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: [
                  // CircleAvatar(
                  //   child: Image.asset('assets/images/logo.jpeg'),
                  // ),
                  Container(
                    margin: EdgeInsets.all(5.0),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/distrho_logo_green.png'),
                          fit: BoxFit.contain),
                    ),
                  ),
                  // Container(
                  //   height: 70.0,
                  //   child: Image.asset('assets/images/logo.jpeg'),
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //   ),
                  // ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            '${names ?? ' '}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '${emails ?? ' '}',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        // Container(
                        //   height: 30,
                        //   width: 80,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(5.0),
                        //     color: Colors.black,
                        //   ),
                        //   child: Center(
                        //     child: Text(
                        //       'Edit Profile',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Color(0xff87C440),
                width: 1, //                   <--- border width here
              ),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, dashboardss);
              },
              child: ListTile(
                leading: Icon(
                  Icons.home,
                ),
                title: Center(
                    child: Text(
                  'Dashboard',
                )),
              ),
            ),
          ),
          // SizedBox(
          //   height: 6,
          // ),
          // Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(6),
          //     border: Border.all(
          //       color: Color(0xff87C440),
          //       width: 1, //                   <--- border width here
          //     ),
          //   ),
          //   child: InkWell(
          //     onTap: () => {Navigator.pushNamed(context, '/tracking')},
          //     child: ListTile(
          //       leading: Icon(
          //         Icons.location_city,
          //         color: Colors.black,
          //       ),
          //       title: Center(child: Text('Tracking')),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 6,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Color(0xff87C440),
                width: 1, //                   <--- border width here
              ),
            ),
            child: InkWell(
              onTap: () => {
                remove_session(),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginAs(),
                  ),
                )
              },
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                ),
                title: Center(
                    child: Text(
                  'Logout',
                )),
              ),
            ),
          ),

          // SizedBox(
          //   height: 15,
          // ),
          // Container(
          //   height: 40,
          //   decoration: BoxDecoration(
          //     border: Border.all(
          //       color: Colors.green,
          //       width: 1, //                   <--- border width here
          //     ),
          //   ),
          //   width: MediaQuery.of(context).size.width,
          //   child: Center(
          //     child: Padding(
          //       padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Icon(Icons.map),
          //           Text('Routes'),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 15,
          // ),
          // Container(
          //   height: 40,
          //   decoration: BoxDecoration(
          //     border: Border.all(
          //       color: Colors.green,
          //       width: 1, //                   <--- border width here
          //     ),
          //   ),
          //   width: MediaQuery.of(context).size.width,
          //   child: Center(
          //     child: Padding(
          //       padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Icon(Icons.spatial_tracking),
          //           Text('Tracking'),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 15,
          // ),
          // Container(
          //   height: 40,
          //   decoration: BoxDecoration(
          //     border: Border.all(
          //       color: Colors.green,
          //       width: 1, //                   <--- border width here
          //     ),
          //   ),
          //   width: MediaQuery.of(context).size.width,
          //   child: Center(
          //     child: Padding(
          //       padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Icon(Icons.inventory),
          //           Text('My Orders'),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 15,
          // ),
          // Container(
          //   height: 40,
          //   decoration: BoxDecoration(
          //     border: Border.all(
          //       color: Colors.green,
          //       width: 1, //                   <--- border width here
          //     ),
          //   ),
          //   width: MediaQuery.of(context).size.width,
          //   child: InkWell(
          //     onTap: () async {
          //       SharedPreferences preferences =
          //           await SharedPreferences.getInstance();
          //       await preferences.clear();
          //       Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => Login(),
          //         ),
          //       );
          //       // Update the state of the app.
          //       // ...
          //     },
          //     child: Center(
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(''),
          //             Icon(Icons.dashboard),
          //             Text('Dashboard'),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ]),
      ),
    );
    // ListView(
    // padding: EdgeInsets.zero,
    // children: [
    //   // Container(
    //   //   child: Center(
    //   //     child: const UserAccountsDrawerHeader(
    //   //       accountName: Text(
    //   //         "Jhon Doe",
    //   //         style: TextStyle(
    //   //           fontWeight: FontWeight.bold,
    //   //         ),
    //   //       ),
    //   //       accountEmail: Text(
    //   //         "user@gmail.com",
    //   //         style: TextStyle(
    //   //           fontWeight: FontWeight.bold,
    //   //         ),
    //   //       ),
    //   //       currentAccountPicture: Icon(
    //   //         Icons.people,
    //   //         size: 50,
    //   //       ),
    //   //     ),
    //   //   ),
    //   // ),

    //   Container(
    //     height: 100,
    //     width: double.infinity,
    //     padding: EdgeInsets.all(8.0),
    //     //height: MediaQuery.of(context).size.height *0.09,
    //     //  width: MediaQuery.of(context).size.width *0.09,
    //     decoration: BoxDecoration(border: Border.all()),
    //     child: ListTile(
    //       leading: CircleAvatar(
    //         backgroundImage: NetworkImage(
    //             'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2xWOjEnumNtvEWoNeHlE5I9UA-tZcvVuG-8_BKP3yjA&s'),
    //       ),
    //       title: const Text(
    //         'Jhone DIoe',
    //       ),
    //       onTap: () {
    //         Navigator.pushNamed(context, '/dashboard');
    //       },
    //     ),
    //   ),
    //   Container(
    //     height: 70,
    //     width: 100,
    //     padding: EdgeInsets.all(8.0),
    //     //height: MediaQuery.of(context).size.height *0.09,
    //     //  width: MediaQuery.of(context).size.width *0.09,
    //     decoration: BoxDecoration(border: Border.all()),
    //     child: ListTile(
    //       leading: Icon(Icons.home),
    //       title: const Text('Dashboard'),
    //       onTap: () {
    //         Navigator.pushNamed(context, '/dashboard');
    //       },
    //     ),
    //   ),
    //   SizedBox(
    //     height: 10,
    //   ),
    //   //2
    //   Container(
    //     height: 70,
    //     width: 100,
    //     padding: EdgeInsets.all(8.0),
    //     //height: MediaQuery.of(context).size.height *0.09,
    //     //  width: MediaQuery.of(context).size.width *0.09,
    //     decoration: BoxDecoration(border: Border.all()),
    //     child: ListTile(
    //       leading: Icon(Icons.add_circle_outline_outlined),
    //       title: const Text('Routes'),
    //       onTap: () {
    //         Navigator.pushNamed(context, '/dashboard');
    //       },
    //     ),
    //   ),
    //   //3
    //   SizedBox(
    //     height: 10,
    //   ),
    //   Container(
    //     height: 70,
    //     width: 100,
    //     padding: EdgeInsets.all(8.0),
    //     //height: MediaQuery.of(context).size.height *0.09,
    //     //  width: MediaQuery.of(context).size.width *0.09,
    //     decoration: BoxDecoration(border: Border.all()),
    //     child: ListTile(
    //       leading: Icon(Icons.location_off_sharp),
    //       title: const Text('Tracking'),
    //       onTap: () {
    //         Navigator.pushNamed(context, '/dashboard');
    //       },
    //     ),
    //   ),
    //   //4

    //   SizedBox(
    //     height: 10,
    //   ),
    //   Container(
    //     height: 70,
    //     width: 100,
    //     padding: EdgeInsets.all(8.0),
    //     //height: MediaQuery.of(context).size.height *0.09,
    //     //  width: MediaQuery.of(context).size.width *0.09,
    //     decoration: BoxDecoration(border: Border.all()),
    //     child: ListTile(
    //       leading: Icon(Icons.badge_rounded),
    //       title: const Text('My orders'),
    //       onTap: () {
    //         Navigator.pushNamed(context, '/dashboard');
    //       },
    //     ),
    //   ),
//5 SizedBox(height: 10,),
//           Container(
//             height: 70,
//             width: 100,
//             padding: EdgeInsets.all(8.0),
//             //height: MediaQuery.of(context).size.height *0.09,
//             //  width: MediaQuery.of(context).size.width *0.09,
//             decoration: BoxDecoration(border: Border.all()),
//             child: ListTile(
//               leading: Icon(Icons.person),
//               title: const Text('Compalin'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/dashboard');
//               },
//             ),
//           ),
// //6
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             height: 70,
//             width: 100,
//             padding: EdgeInsets.all(8.0),
//             //height: MediaQuery.of(context).size.height *0.09,
//             //  width: MediaQuery.of(context).size.width *0.09,
//             decoration: BoxDecoration(border: Border.all()),
//             child: ListTile(
//               leading: Icon(Icons.bus_alert_rounded),
//               title: const Text('Servey'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/dashboard');
//               },
//             ),
//           ),
// //7
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             height: 70,
//             width: 100,
//             padding: EdgeInsets.all(8.0),
//             //height: MediaQuery.of(context).size.height *0.09,
//             //  width: MediaQuery.of(context).size.width *0.09,
//             decoration: BoxDecoration(border: Border.all()),
//             child: ListTile(
//               leading: Icon(Icons.person),
//               title: const Text('Profile'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/dashboard');
//               },
//             ),
//           ),
// //8
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             height: 70,
//             width: 100,
//             padding: EdgeInsets.all(8.0),
//             //height: MediaQuery.of(context).size.height *0.09,
//             //  width: MediaQuery.of(context).size.width *0.09,
//             decoration: BoxDecoration(border: Border.all()),
//             child: ListTile(
//               leading: Icon(Icons.logout),
//               title: const Text('Log out'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/dashboard');
//               },
//             ),
//           ),
// //9
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             height: 70,
//             width: 100,
//             padding: EdgeInsets.all(8.0),
//             //height: MediaQuery.of(context).size.height *0.09,
//             //  width: MediaQuery.of(context).size.width *0.09,
//             decoration: BoxDecoration(border: Border.all()),
//             child: ListTile(
//               leading: Icon(Icons.add_circle_outline),
//               title: const Text('Close Navigation'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/dashboard');
//               },
//             ),
//           ),

    // ListTile(
    //   leading: Icon(Icons.location_city),
    //   title: const Text('Routes'),
    //   onTap: () {
    //     Navigator.pushNamed(context, '/routes');
    //   },
    // ),
    // ListTile(
    //   leading: Icon(Icons.local_airport),
    //   title: const Text('Tracking'),
    //   onTap: () {
    //     Navigator.pushNamed(context, '/tracking');
    //   },
    // ),
    // ListTile(
    //   leading: Icon(Icons.inventory_2),
    //   title: const Text('My Orders'),
    //   onTap: () {
    //     Navigator.pushNamed(context, '/orders');
    //   },
    // ),
    // ListTile(
    //   leading: Icon(Icons.inventory_2),
    //   title: const Text('Complain'),
    //   onTap: () {
    //     Navigator.pushNamed(context, '/complain');
    //   },
    // ),
    // ListTile(
    //   leading: Icon(Icons.inventory_2),
    //   title: const Text('Servey'),
    //   onTap: () {
    //     Navigator.pushNamed(context, '/servey/add');
    //   },
    // ),
    // ListTile(
    //   leading: Icon(Icons.people),
    //   title: const Text('Profile'),
    //   onTap: () {
    //     Navigator.pushNamed(context, '/profile');
    //   },
    // ),
    // ListTile(
    //   leading: Icon(Icons.logout),
    //   title: const Text('Logout'),
    //   onTap: () async {
    //     SharedPreferences preferences =
    //         await SharedPreferences.getInstance();
    //     await preferences.clear();
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => Login(),
    //       ),
    //     );
    //     // Update the state of the app.
    //     // ...
    //   },
    // ),
    // ListTile(
    //   leading: Icon(Icons.close),
    //   title: Text('Close Navigation'),
    //   onTap: () {
    //     // change app state...
    //     Navigator.pop(context); // close the drawer
    //   },
    // )
    //   ],
    // ),
    //);
    //);

    /// New Drawer
  }
}
