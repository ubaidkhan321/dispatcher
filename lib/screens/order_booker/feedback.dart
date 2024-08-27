import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:linear/helpers/api.dart';
import 'customer_visit.dart';
import 'retailer_visit.dart';
import 'thankyou.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/globals.dart';
import '../../helpers/api.dart';
import '../../helpers/suggestions.dart';
// for using HttpClient
import 'dart:convert'; // for using json.decode()
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CustFeedback extends StatefulWidget {
  final customer;
  final type;
  const CustFeedback({Key? key, this.customer, this.type}) : super(key: key);

  @override
  _CustFeedbackState createState() => _CustFeedbackState();
}

class _CustFeedbackState extends State<CustFeedback> {
  var secret = globals.secret_key;
  bool _saving = false;
  String? customer_id = '';
  String? retailer_id = '';
  String? created_by = '';
  // Future<void> _fetchData() async {
  //   const apiUrl =
  //       'https://rhotrack.rholabproducts.com/api/mobileapp/complains/create';
  //   final response = await http.post(Uri.parse(apiUrl),
  //       encoding: Encoding.getByName('utf8'),
  //       headers: {
  //         "Accept": "application/json",
  //         "Content-Type": "application/x-www-form-urlencoded"
  //       },
  //       body: {
  //         "secret_key": secret,
  //         "customer": customer,
  //         "subject": subject,
  //         "message": message,
  //         "priority": _selectedperirort,
  //         "created_by": '1'
  //       });
  //   final data = json.decode(response.body);
  //   var _route = ModalRoute.of(context)?.settings.name.toString();
  //   var splitted = _route?.split('/');
  //   print(splitted![2]);
  //   if (data['code_status'] == true) {
  //     // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     AwesomeDialog(
  //       context: context,
  //       dialogType: DialogType.success,
  //       animType: AnimType.rightSlide,
  //       title: 'Success',
  //       desc: 'Feedback Add Successfully',
  //       // btnCancelOnPress: () {},
  //       btnOkOnPress: () {
  //         if (splitted[2] == 'retailer') {
  //           Navigator.pushNamed(context, '/reatiler_visit');
  //         } else {
  //           Navigator.pushNamed(context, '/customer_visit');
  //         }
  //       },
  //     )..show();
  //   } else {
  //     AwesomeDialog(
  //       context: context,
  //       dialogType: DialogType.error,
  //       animType: AnimType.rightSlide,
  //       title: 'Error',
  //       desc: 'Something Wents Wrong',
  //       // btnCancelOnPress: () {},
  //       btnOkOnPress: () {
  //         if (splitted[2] == 'retailer') {
  //           Navigator.pushNamed(context, '/reatiler_visit');
  //         } else {
  //           Navigator.pushNamed(context, '/customer_visit');
  //         }
  //       },
  //     )..show();
  //   }
  // }

  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _typeAheadController = TextEditingController();
  static String _displayStringForOption(orders) => orders.order_no;
  final snackBar = SnackBar(
    content: Text('Data Save Successfully'),
  );
  List<String> periorty = ['High', 'Medium', 'Low']; // Option 2
  var _selectedperirort; // Option 2
  String customer = '';
  String subject = '';
  String message = '';
  String perority = '';

  @override
  void initState() {
    // TODO: implement initState
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    // _fetchData();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //       image: AssetImage(
                  //         'assets/images/screen_bg.jpg',
                  //       ),
                  //       fit: BoxFit.cover),
                  // ),
                  child: Container(
                    // color: Colors.red,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Container(
                            // color: Colors.lightGreen,
                            width: double.infinity,
                            height: 80,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Subject",
                                border:
                                    OutlineInputBorder(), //label text of field
                              ),
                              onChanged: (value) {
                                setState(() {
                                  subject = value;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Subject Is Required";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Container(
                            // color: Colors.lightGreen,
                            width: double.infinity,
                            height: 80,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Message",
                                border:
                                    OutlineInputBorder(), //label text of field
                              ),
                              onChanged: (value) {
                                setState(() {
                                  message = value;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Message Is Required";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (this._formKey.currentState!.validate()) {
                              this._formKey.currentState!.save();
                              setState(() {
                                _saving = true;
                              });
                              var _route = await ModalRoute.of(context)
                                  ?.settings
                                  .name
                                  .toString();
                              var splitted = _route?.split('/');
                              print(splitted);
                              var res = await api.create_feedback(
                                  (widget.type == 'customer')
                                      ? customer_id.toString()
                                      : retailer_id.toString(),
                                  subject,
                                  message,
                                  created_by.toString());
                              print('CustomerId : ' + customer_id.toString());
                              print('Retailer : ' + retailer_id.toString());
                              print('Subjet : ' + subject.toString());
                              print('message : ' + message.toString());
                              print('created_by : ' + created_by.toString());
                              if (res['code_status'] == true) {
                                setState(() {
                                  _saving = false;
                                });
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.rightSlide,
                                  title: 'Success',
                                  desc: 'Feedback Added Successfullyy',
                                  // btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    if (widget.type == 'customer') {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CustomerVisit(),
                                        ),
                                      );
                                      // Navigator.pushNamed(context, '/reatiler_visit');
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RetailerVisit(),
                                        ),
                                      );

                                      // Navigator.pushNamed(context, '/customer_visit');
                                    }
                                  },
                                )..show();
                              } else {
                                setState(() {
                                  _saving = false;
                                });
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc: 'Invalid Data',
                                  // btnCancelOnPress: () {},
                                  btnOkOnPress: () {},
                                )..show();
                              }
                              // _fetchData();
                            }
                          },
                          child: Text('Add Feedback'),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  void getdata() async {
    final prefs = await SharedPreferences.getInstance();
    created_by = prefs.getString('user_id');
    customer_id = prefs.getString('customer_visit_id');
    retailer_id = prefs.getString('retailer_visit_id');
    setState(() {});
  }
}
