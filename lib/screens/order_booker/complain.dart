import 'package:flutter/material.dart';
import 'customer_visit.dart';
import 'photo_preview.dart';
import 'retailer_visit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/globals.dart';
import '../../helpers/api.dart';
// for using HttpClient
import 'dart:convert'; // for using json.decode()
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../search_widget/product_search.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Complain extends StatefulWidget {
  final customer;
  final type;
  const Complain({Key? key, this.customer, this.type}) : super(key: key);

  @override
  _ComplainState createState() => _ComplainState();
}

class _ComplainState extends State<Complain> {
  bool _saving = false;
  String base_url = 'https://demo-rhotrack.rholabproducts.com/';
  // String base_url = 'https://rhotrack.rholabproducts.com/';
  File? image;
  final _picker = ImagePicker();
  var secret = globals.secret_key;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _typeAheadController = TextEditingController();
  TextEditingController _typeAheadController_pro = TextEditingController();
  final TextEditingController _customer_controller = TextEditingController();

  final TextEditingController _product_controller = TextEditingController();
  TextEditingController _product_id_controller = TextEditingController();
  TextEditingController _product_barcode_controller = TextEditingController();

  TextEditingController _search_controller = new TextEditingController();
  String search = '';
  static String _displayStringForOption(orders) => orders.order_no;
  List<String> periorty = ['High', 'Medium', 'Low']; // Option 2
  var _selectedperirort; // Option 2
  String customer = '';
  String selected_product = '';
  String subject = '';
  String message = '';
  String perority = '';
  String Initial_value = '';
  List _complains = [];
  List _products = [];
  List _bulk_complain = [];
  int complain_inc = 0;

  String? customer_id = '';
  String? retailer_id = '';
  String? created_by = '';

  Future<void> _fetchCustomer() async {
    var res = await api.get_customers('', '', '', '', '', '', '');
    if (res['code_status'] == true) {
      setState(
        () {
          _complains = res['customers'];
        },
      );
    }
    print(res);
  }

  Future<void> _fetchProducts(text) async {
    var res =
        await api.get_products('', '', text.toString(), '', '', '', '', '');
    if (res['code_status'] == true) {
      setState(
        () {
          _products = res['products'];
        },
      );
    }
    print(res);
  }

  Future getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    } else {
      print('no image selected');
    }
  }

  @override
  void initState() {
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    // if (_complains.isEmpty) {
    //   _fetchCustomer();
    // }
    // if (_products.isEmpty) {
    //   _fetchProducts('');
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
                  width: MediaQuery.of(context).size.width - 50,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: SizedBox(
                          width: double.infinity,
                          height: 80,
                          child: TextFormField(
                            controller: _product_controller,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Product",
                              border:
                                  OutlineInputBorder(), //label text of field
                            ),
                            readOnly: true,
                            onChanged: (value) {
                              subject = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Product Is Required";
                              }
                              return null;
                            },
                            onTap: () => {
                              showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ProductSearch(
                                      product_controller: _product_controller,
                                      product_id_controller:
                                          _product_id_controller,
                                      product_barcode_controller:
                                          _product_barcode_controller,
                                      category_id: '',
                                      sub_category_id: '',
                                      product_rate_controller:
                                          new TextEditingController(),
                                      supplier_id_controller:
                                          new TextEditingController(),
                                      selling_price_controller:
                                          new TextEditingController(),
                                    );
                                  })
                              // show_modal(context, _products)
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: SizedBox(
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
                              subject = value;
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
                        child: SizedBox(
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
                              message = value;
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
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          // // width: MediaQuery.of(context).size.width - 40,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(width: 0.5), //label text of field
                          ),
                          // decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(10)),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            hint: Text('Please choose Priority'),
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // SizedBox(
                      //   width: 350,
                      //   child: ElevatedButton(
                      //     onPressed: () => {getImage()},
                      //     child: Text('uplaod Image'),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      ElevatedButton(
                        onPressed: () async {
                          if (this._formKey.currentState!.validate()) {
                            this._formKey.currentState!.save();
                            setState(() {
                              complain_inc++;
                              Map _data_2 = {
                                "id": complain_inc,
                                "customer": (widget.type == 'customer')
                                    ? customer_id.toString()
                                    : retailer_id.toString(),
                                "subject": subject.toString(),
                                "message": message.toString(),
                                "periority": _selectedperirort,
                                "product_name": _product_controller.text,
                                "product_id": _product_id_controller.text,
                                // "product_id": selected_product,
                                "image": image,
                                "created_by": created_by.toString(),
                              };
                              _bulk_complain.add(_data_2);
                              image = null;
                              print(_bulk_complain);
                            });

                            // var res = await api.create_complain(
                            //     customer,
                            //     subject,
                            //     subject,
                            //     message,
                            //     _selectedperirort);
                            // var _route = ModalRoute.of(context)
                            //     ?.settings
                            //     .name
                            //     .toString();
                            // var splitted = _route?.split('/');
                            // print(splitted![3]);
                            // if (res['code_status'] == true) {
                            //   AwesomeDialog(
                            //     context: context,
                            //     dialogType: DialogType.success,
                            //     animType: AnimType.rightSlide,
                            //     title: 'Success',
                            //     desc: 'Complain Add Successfully',
                            //     // btnCancelOnPress: () {},
                            //     btnOkOnPress: () {
                            //       if (splitted[3] == 'retailer') {
                            //         Navigator.pushNamed(
                            //             context, '/reatiler_visit');
                            //       } else {
                            //         Navigator.pushNamed(
                            //             context, '/customer_visit');
                            //       }
                            //     },
                            //   )..show();
                            // } else {
                            //   AwesomeDialog(
                            //     context: context,
                            //     dialogType: DialogType.error,
                            //     animType: AnimType.rightSlide,
                            //     title: 'Error',
                            //     desc: 'Something Went Wrong',
                            //     // btnCancelOnPress: () {},
                            //     btnOkOnPress: () {},
                            //   )..show();
                            // }
                            // _fetchData();
                          }
                        },
                        child: Text('Add Complain'),
                      ),
                      Expanded(
                        child: _bulk_complain.isEmpty
                            ? Center(
                                child: Text(
                                  'No Data',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )
                            : ListView.builder(
                                itemCount: _bulk_complain.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return InkWell(
                                    child: Card(
                                      child: ListTile(
                                        leading: Icon(Icons.inventory_2),
                                        title: Text(
                                            _bulk_complain[index]['subject']),
                                        subtitle: Text(_bulk_complain[index]
                                            ['product_name']),
                                        trailing: PopupMenuButton(
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                value: 'delete',
                                                child: Text('Delete'),
                                              )
                                            ];
                                          },
                                          onSelected: (String value) {
                                            if (value == 'delete') {
                                              setState(() {
                                                _bulk_complain.removeWhere(
                                                    (element) =>
                                                        element['id'] ==
                                                        _bulk_complain[index]
                                                            ['id']);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_bulk_complain.isEmpty) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              title: 'Error',
              desc: 'Invalid Data',
              // btnCancelOnPress: () {},
              btnOkOnPress: () {},
            )..show();
          } else {
            setState(() {
              _saving = true;
            });
            for (var item in _bulk_complain) {
              print(item);
              var res = await api.create_complain(
                  item['customer'],
                  item['subject'],
                  item['message'],
                  item['periority'],
                  item['created_by']);
            }
            setState(() {
              _saving = false;
            });
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.rightSlide,
              title: 'success',
              desc: 'All Complain insert Successfully',
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
          }
          // Add your onPressed code here!
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  show_modal(context, _arr) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text('Product'),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _search_controller,
                      decoration: InputDecoration(
                        labelText: "Search Here",
                        border: OutlineInputBorder(), //label text of field
                      ),
                      onChanged: (value) => {
                        setState(() {
                          search = value.toString();
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
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _arr.length,
                      itemBuilder: (BuildContext ctx, index) {
                        if (_search_controller.text.isEmpty ||
                            _arr[index]['product_name']
                                .toString()
                                .toLowerCase()
                                .contains(_search_controller.text)) {
                          return InkWell(
                            onTap: () {
                              if (_arr[index]['product_name'] != null) {
                                setState(() {
                                  _product_controller.text = _products[index]
                                          ['product_name']
                                      .toString();
                                  selected_product =
                                      _products[index]['product_id']!;
                                });
                              }
                              Navigator.pop(context);
                            },
                            child: Card(
                              child: ListTile(
                                leading: InkWell(
                                  child: Image.network(base_url +
                                      'assets/images' +
                                      _products[index]['product_image']
                                          .toString()),
                                  onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PhotoPreview(
                                            url: base_url +
                                                'assets/images' +
                                                _products[index]
                                                        ['product_image']
                                                    .toString()),
                                      ),
                                    )
                                  },
                                ),
                                title: Text(_arr[index]['product_name']),
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
