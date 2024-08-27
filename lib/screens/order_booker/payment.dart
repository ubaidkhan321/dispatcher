import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:linear/helpers/globals.dart';
import 'customer_visit.dart';
import 'retailer_visit.dart';
import 'thankyou.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../helpers/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  final customer;
  final type;
  final order_id;
  const Payment({Key? key, this.order_id, this.customer, this.type})
      : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  File? image;
  final _picker = ImagePicker();

  bool load = false;
  bool _saving = false;

  String? customer_id = '';
  String? retailer_id = '';
  String? created_by = '';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _date_so = TextEditingController();
  final TextEditingController _invoice_controller = TextEditingController();
  final TextEditingController _cheque_controller = TextEditingController();
  final TextEditingController _amount_controller = TextEditingController();
  final TextEditingController _notes_controller = TextEditingController();

  final TextEditingController _balance_amount_controller =
      TextEditingController();

  //Online Transfer me Transection id ka Texfield visible hona chaye
  //Chqueue me Chqueue No ka Texfield visible hona chaye
  List _invoices = [];
  String _selected_invoice = '';
  List<String> periorty = [
    'Cash',
    'Online Transfer',
    'Payorder',
    'Cheque',
    'Others'
  ]; // Option 2
  var _selectedperirort;
  Future<void> _fetchCustomer(customer_id) async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_due_invoice(customer_id.toString());
    if (res['code_status'] == true) {
      setState(() {
        _saving = false;
      });
      setState(
        () {
          _invoices = res['invoices'];
        },
      );
    }
    // print(res);
  }

  Future getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      load = true;
      setState(() {});
    } else {
      print('no image selected');
    }
  }

  @override
  void initState() {
    getdata();
  }

  Future<void> uploadImage() async {
    // var uri = Uri.parse(
    //     'https://demo-rhotrack.rholabproducts.com/api/mobileapp/paymentcollections/create');

    var uri = Uri.parse(
        'https://rholabproducts.com/api/mobileapp/paymentcollections/create');

    var request = new http.MultipartRequest('post', uri);
    request.fields['secret_key'] = 'jfds3=jsldf38&r923m-cjowscdlsdfi03';
    request.fields['sale_id'] = '2';
    request.fields['customer_id'] = '403';
    request.fields['paid_by'] = 'cash';
    request.fields['cheque_no'] = '1213445';
    request.fields['amount'] = '1000';
    request.fields['created_by'] = '58';
    request.fields['note'] = 'Image Api Upload';
    if (image != null) {
      // var stream = new http.ByteStream(image!.openRead());
      // stream.cast();
      // var length = await image!.length();
      // var multiport = new http.MultipartFile('attachment', stream, length);
      request.files
          .add(await http.MultipartFile.fromPath('attachment', image!.path));
      // request.files.add('attachment',image.path);
    }

    var response = await request.send();
    print(image);
    if (response.statusCode == 200) {
      print('Image Uploads');
    } else {
      print('Failed');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('The Retailer Id');
    print(retailer_id);
    if (_invoices.isEmpty) {
      _fetchCustomer(retailer_id.toString());
    }
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
      body: Form(
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
                width: MediaQuery.of(context).size.width - 50,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SizedBox(
                        child: TextFormField(
                          controller: _date_so,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Enter Date",
                            border: OutlineInputBorder(), //label text of field
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
                            DateTime? pickeddate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickeddate != null) {
                              setState(
                                () {
                                  _date_so.text = DateFormat('yyyy-MM-dd')
                                      .format(pickeddate);
                                },
                              );
                            }
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
                          controller: _invoice_controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Against Invoice",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            // subject = value;
                          },
                          readOnly: true,
                          onTap: () => {
                            showMaterialModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  leading: IconButton(
                                    icon: Icon(Icons.arrow_back,
                                        color: Colors.black),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ),
                                body: Container(
                                  child: Center(
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: _invoices.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return InkWell(
                                          onTap: () {
                                            if (_invoices[index]
                                                    ['reference_no'] !=
                                                null) {
                                              setState(() {
                                                _invoice_controller.text =
                                                    _invoices[index]
                                                            ['reference_no']
                                                        .toString();

                                                _amount_controller.text =
                                                    _invoices[index]['balance']
                                                        .toString();

                                                _balance_amount_controller
                                                    .text = _invoices[index]
                                                        ['balance']
                                                    .toString();

                                                _selected_invoice =
                                                    _invoices[index]['id'];
                                                // customer = _customer[index]['id']!;
                                              });
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: Card(
                                            child: ListTile(
                                              leading: Icon(Icons.inventory_2),
                                              title: Text(_invoices[index]
                                                  ['reference_no']),
                                              subtitle: Text('PKR. ' +
                                                  _invoices[index]["balance"]),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Select Invoice";
                            }
                            return null;
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
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          controller: _balance_amount_controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Balance Amount",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            // subject = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Balance Amount Is Required";
                            }
                            return null;
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
                          keyboardType: TextInputType.number,
                          controller: _amount_controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Amount",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            // subject = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Amount Is Required";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 0.5),
                          borderRadius: BorderRadius.circular(3)),
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        hint: Text('Please choose Payment Type'),
                        value: _selectedperirort,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedperirort = newValue;
                          });
                        },
                        items: periorty.map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        validator: (value) =>
                            value == null ? 'Perority required' : null,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 42,
                      ),
                    ),
                    (_selectedperirort == 'Cheque')
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: SizedBox(
                              child: TextFormField(
                                controller: _cheque_controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Cheque No",
                                  border:
                                      OutlineInputBorder(), //label text of field
                                ),
                                onChanged: (value) {
                                  // message = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Chquue No Is Required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 20,
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SizedBox(
                        child: TextFormField(
                          controller: _notes_controller,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Note",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            // message = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Note Is Required";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 350,
                      child: ElevatedButton(
                        onPressed: () => {getImage()},
                        child: Text('uplaod Image'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: (load == false)
                          ? SizedBox()
                          : Image.file(
                              File(image!.path).absolute,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // setState(() {
                        //   _saving = true;
                        // });
                        if (this._formKey.currentState!.validate()) {
                          this._formKey.currentState!.save();

                          uploadImage();
                          // var res = await api.create_payment_w_o_image(
                          //   _selected_invoice.toString(),
                          //   (widget.type == 'customer')
                          //       ? customer_id.toString()
                          //       : retailer_id.toString(),
                          //   _selectedperirort.toString(),
                          //   _cheque_controller.text,
                          //   _amount_controller.text,
                          //   created_by.toString(),
                          //   _notes_controller.text,
                          // );
                          // if (res['code_status'] == true) {
                          //   EasyLoading.dismiss();
                          //   AwesomeDialog(
                          //     context: context,
                          //     dialogType: DialogType.success,
                          //     animType: AnimType.rightSlide,
                          //     title: 'Success',
                          //     desc: 'Payment Add Successfullyy',
                          //     // btnCancelOnPress: () {},
                          //     btnOkOnPress: () {
                          //       if (widget.type == 'customer') {
                          //         Navigator.pushReplacement(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => CustomerVisit(),
                          //           ),
                          //         );
                          //         // Navigator.pushNamed(context, '/customer_visit');
                          //       } else {
                          //         Navigator.pushReplacement(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => RetailerVisit(),
                          //           ),
                          //         );
                          //       }
                          //     },
                          //   )..show();
                          // } else {
                          //   EasyLoading.dismiss();
                          //   AwesomeDialog(
                          //     context: context,
                          //     dialogType: DialogType.error,
                          //     animType: AnimType.rightSlide,
                          //     title: 'Error',
                          //     desc: res['message'],
                          //     // btnCancelOnPress: () {},
                          //     btnOkOnPress: () {},
                          //   )..show();
                          // }

                          // FormData formData = new FormData.fromMap({
                          //   "secret_key": globals.secret_key,
                          //   "sale_id": '16',
                          //   "customer_id": '56',
                          //   "paid_by": '56',
                          //   "cheque_no": '1212',
                          //   "profile_picture": await Dio.MultipartFile.fromFile(
                          //       image!.path,
                          //       filename: image!.path.split('/').last)
                          // });

                          // var result = await api.create_payment(formData);
                          // // var res = await api.create_payment();

                          // print(result);
                          // var _route =
                          //     ModalRoute.of(context)?.settings.name.toString();
                          // var splitted = _route?.split('/');
                          // print(splitted![3]);
                          // AwesomeDialog(
                          //   context: context,
                          //   dialogType: DialogType.success,
                          //   animType: AnimType.rightSlide,
                          //   title: 'Success',
                          //   desc: 'Payment Add Successfully',
                          //   // btnCancelOnPress: () {},
                          //   btnOkOnPress: () {
                          //     if (splitted[3] == 'retailer') {
                          //       Navigator.pushNamed(context, '/reatiler_visit');
                          //     } else {
                          //       Navigator.pushNamed(context, '/customer_visit');
                          //     }
                          //   },
                          // )..show();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => ThankYouPage(
                          //           title: "Payment Add Successfully"),
                          //     ));
                        }
                      },
                      child: Text('Add Payment'),
                    )
                  ],
                ),
              ),
            ),
          ),
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
