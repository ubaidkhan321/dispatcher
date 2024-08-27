// import 'package:flutter/material.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'thankyou.dart';
import '../../helpers/suggestions.dart';
import '../../helpers/api.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddOrder extends StatefulWidget {
  final List ids;
  const AddOrder({Key? key, required this.ids}) : super(key: key);

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _typeAheadController = TextEditingController();
  TextEditingController _typeAheadController_supp = TextEditingController();
  TextEditingController _typeAheadController_werehouse =
      TextEditingController();
  static String _displayStringForOption(orders) => orders.order_no;
  final TextEditingController _date_so = TextEditingController();
  final TextEditingController _date_po = TextEditingController();
  final TextEditingController _date_do = TextEditingController();
  var _orders = [];
  @override
  Widget build(BuildContext context) {
    print('Get order wajih $_orders');
    Future<void> _fetchData() async {
      var res = await api.get_orders('', '', '', '');
      if (res['code_status'] == true) {
        setState(
          () {
            _orders = res['bookings'];
          },
        );
      }
      print('Get order wajih $_orders');
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Add New Order'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 350,
              child: Column(
                children: <Widget>[
                  Text("Total Product : ${widget.ids.length}"),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _date_so,
                    decoration: InputDecoration(
                      labelText: "Enter Date",
                      border: OutlineInputBorder(), //label text of field
                    ),
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
                        setState(() {
                          _date_so.text =
                              DateFormat('yyyy-MM-dd').format(pickeddate);
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: this._typeAheadController_werehouse,
                          decoration:
                              InputDecoration(labelText: 'Select Werehouse ')),
                      suggestionsCallback: (pattern) async {
                        return await BackendService.getSuggestions(pattern);
                      },
                      itemBuilder: (context, Map<String, String> suggestion) {
                        return ListTile(
                          title: Text(suggestion['name']!),
                        );
                      },
                      onSuggestionSelected: (Map<String, String> suggestion) {
                        this._typeAheadController_werehouse.text =
                            suggestion['name']!;
                        // customer = suggestion['id']!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Werehouse Is Required";
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Select PO Number',
                      labelText: 'Select PO Number',
                      border: OutlineInputBorder(),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _date_po,
                    decoration: InputDecoration(
                      labelText: "Enter PO DATE",
                      border: OutlineInputBorder(), //label text of field
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickeddate != null) {
                        setState(() {
                          _date_po.text =
                              DateFormat('yyyy-MM-dd').format(pickeddate);
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: this._typeAheadController,
                          decoration:
                              InputDecoration(labelText: 'Select Supplier ')),
                      suggestionsCallback: (pattern) async {
                        return await BackendService.getSuggestions(pattern);
                      },
                      itemBuilder: (context, Map<String, String> suggestion) {
                        return ListTile(
                          title: Text(suggestion['name']!),
                        );
                      },
                      onSuggestionSelected: (Map<String, String> suggestion) {
                        this._typeAheadController.text = suggestion['name']!;
                        // customer = suggestion['id']!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Supplier Is Required";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      // icon: Icon(Icons.calendar_today),
                      hintText: 'Enter Delivery Address',
                      labelText: 'Enter Delivery Address',
                      border: OutlineInputBorder(),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _date_do,
                    decoration: InputDecoration(
                      // icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Enter Date",
                      border: OutlineInputBorder(), //label text of field
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickeddate != null) {
                        setState(() {
                          _date_do.text =
                              DateFormat('yyyy-MM-dd').format(pickeddate);
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: this._typeAheadController_supp,
                          decoration:
                              InputDecoration(labelText: 'Select Supplier ')),
                      suggestionsCallback: (pattern) async {
                        return await BackendService.getWerehouse(pattern);
                      },
                      itemBuilder: (context, Map<String, String> suggestion) {
                        return ListTile(
                          title: Text(suggestion['name']!),
                        );
                      },
                      onSuggestionSelected: (Map<String, String> suggestion) {
                        this._typeAheadController_supp.text =
                            suggestion['name']!;
                        // customer = suggestion['id']!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Supplier Is Required";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Success',
                        desc: 'Complain Add Successfully',
                        // btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          Navigator.pushNamed(context, '/customer_visit');
                        },
                      )..show();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) =>
                      //           ThankYouPage(title: "Order Add Successfully"),
                      //     ));
                      // print('${widget.ids}'
                      //     '${widget.ids.length}');
                    },
                    child: Text('Take Order'),
                  )
                  // Add TextFormFields and ElevatedButton here.
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
