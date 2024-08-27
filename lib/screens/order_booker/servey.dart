import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'retailer_visit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../helpers/api.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'customer_visit.dart';

class Servey extends StatefulWidget {
  final customer;
  final type;
  const Servey({Key? key, this.customer, this.type}) : super(key: key);

  @override
  _ServeyState createState() => _ServeyState();
}

enum SingingCharacter { yes, no }

class _ServeyState extends State<Servey> {
  @override
  List _servey = [];
  List _request = [];
  List _answer = [];
  String? customer_id = '';
  String? retailer_id = '';
  String? created_by = '';

  List _customer = [];
  bool _saving = false;

  Future<void> _fetchServey() async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_servey('text');
    if (res['code_status'] == true) {
      setState(() {
        _saving = false;
      });
      setState(
        () {
          _servey = res['survey'];
        },
      );
    }
    print(res);
  }

  String selectedRadio = 'Yes';

  @override
  void initState() {
    getdata();
    selectedRadio = 'Yes';
  }

  setSelectedRadio(String val, _request) {
    setState(() {
      selectedRadio = val;
      _request['answer'] = val;
    });
  }

  reset() {
    setState(() {
      _customer = [];
    });
  }

  Future<void> _fetchCustomer(text) async {
    setState(() {
      _saving = true;
    });
    // EasyLoading.show(status: 'loading...');
    var res = await api.get_customers('', '', text.toString(), '', '', '', '');
    if (res['code_status'] == true) {
      setState(() {
        _saving = false;
      });
      setState(
        () {
          _customer = res['customers'];
        },
      );
    }
    print(res);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    if (_servey.isEmpty) {
      _fetchServey();
    }

    // if (_customer.isEmpty) {
    //   _fetchCustomer('');
    // }

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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: List.generate(_servey.length, (index) {
                  var Question_no = index + 1;

                  //
                  SingingCharacter? _character = SingingCharacter.yes;
                  Map single_ques = {
                    'question_id': _servey[index]['id'],
                    'answer': selectedRadio
                  };
                  _request.add(single_ques);
                  // _answer.add();
                  return Container(
                    child: Card(
                      child: ListTile(
                        title: Text("Q" +
                            Question_no.toString() +
                            " : " +
                            _servey[index]['question'] +
                            ""),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 'bad',
                                    groupValue: _request[index]['answer'],
                                    activeColor: Colors.green,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      setSelectedRadio(
                                          val.toString(), _request[index]);
                                    },
                                  ),
                                  Text('Bad'),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 'good',
                                    groupValue: _request[index]['answer'],
                                    activeColor: Colors.green,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      setSelectedRadio(
                                          val.toString(), _request[index]);
                                    },
                                  ),
                                  Text('Good'),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 'fair',
                                    groupValue: _request[index]['answer'],
                                    activeColor: Colors.green,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      setSelectedRadio(
                                          val.toString(), _request[index]);
                                    },
                                  ),
                                  Text('Fair'),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 'excellent',
                                    groupValue: _request[index]['answer'],
                                    activeColor: Colors.green,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      setSelectedRadio(
                                          val.toString(), _request[index]);
                                    },
                                  ),
                                  Text('Excellent'),
                                ],
                              ),
                            ],
                          ),
                        ), // subtitle: Text('asdasd'),
                        // subtitle: TextFormField(
                        //   decoration: InputDecoration(
                        //     labelText: "Your Answer Here",
                        //     border: OutlineInputBorder(), //label text of field
                        //   ),
                        //   onTap: () => {
                        //     // request.removeWhere((element) =>
                        //     //     element['question_id'] ==
                        //     //     _servey[index]['id']),
                        //   },
                        //   onChanged: (value) {},
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return "Answer Is Required";
                        //     }
                        //     return null;
                        //   },
                        // ),
                      ),
                    ),
                  );
                }),
                // children: [

                //   // Expanded(
                //   //   child: ListView.builder(
                //   //     itemCount: _servey.length,
                //   //     itemBuilder: (BuildContext ctx, index) {
                //   //       var Question_no = index + 1;
                //   //       Map single_ques = {
                //   //         'question_id': _servey[index]['id'],
                //   //         'answer': ''
                //   //       };
                //   //       _request.add(single_ques);
                //   //       return Card(
                //   //         child: ListTile(
                //   //           title: Text("Q" +
                //   //               Question_no.toString() +
                //   //               " : " +
                //   //               _servey[index]['question'] +
                //   //               ""),
                //   //           // subtitle: Text('asdasd'),
                //   //           subtitle: TextFormField(
                //   //             decoration: InputDecoration(
                //   //               labelText: "Your Answer Here",
                //   //               border:
                //   //                   OutlineInputBorder(), //label text of field
                //   //             ),
                //   //             onTap: () => {
                //   //               // request.removeWhere((element) =>
                //   //               //     element['question_id'] ==
                //   //               //     _servey[index]['id']),
                //   //             },
                //   //             onChanged: (value) {},
                //   //             validator: (value) {
                //   //               if (value!.isEmpty) {
                //   //                 return "Answer Is Required";
                //   //               }
                //   //               return null;
                //   //             },
                //   //           ),
                //   //         ),
                //   //       );
                //   //     },
                //   //   ),
                //   // ),
                //   // Expanded(
                //   //     child: SizedBox(
                //   //   height: 10,
                //   // ))
                //   // SizedBox(
                //   //   height: 30,
                //   // )
                // ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _saving = true;
          });
          final String jsonProduct = json.encode(_request);
          print(jsonProduct);
          var res = await api.add_servey(
              (widget.type == 'customer')
                  ? customer_id.toString()
                  : retailer_id.toString(),
              created_by.toString(),
              jsonProduct);
          if (res['code_status'] == true) {
            setState(() {
              _saving = false;
            });
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.rightSlide,
              title: 'Success',
              desc: 'Servey Add Successfully',
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
          // Add your onPressed code here!
        },
        child: const Icon(Icons.check),
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
