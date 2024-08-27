import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linear/helpers/globals.dart';
import 'package:linear/screens/order_booker/retailer_lst_ord_his.dart';
import '../../search_widget/routes_search.dart';
import 'customer_visit.dart';
import 'retailer_visit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../helpers/api.dart';
import '../../helpers/location.dart';
import '../../search_widget/distributor_search.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditCustomer extends StatefulWidget {
  final customer;
  final type;
  final TextEditingController retailer_name_controller;
  final TextEditingController retailer_phone_controller;
  final TextEditingController retailer_email_controller;
  final TextEditingController retailer_cnic_controller;
  final TextEditingController retailer_address_controller;
  final TextEditingController retailer_city_controller;
  final TextEditingController retailer_state_controller;
  final TextEditingController retailer_country_controller;
  final TextEditingController retailer_postalcode_controller;
  final TextEditingController retailer_gst_controller;
  final TextEditingController retailer_ntn_controller;
  final TextEditingController retailer_id_controller;
  final TextEditingController retailer_route_id_controller;
  EditCustomer(
      {Key? key,
      this.customer,
      this.type,
      required this.retailer_name_controller,
      required this.retailer_phone_controller,
      required this.retailer_cnic_controller,
      required this.retailer_email_controller,
      required this.retailer_address_controller,
      required this.retailer_city_controller,
      required this.retailer_state_controller,
      required this.retailer_country_controller,
      required this.retailer_postalcode_controller,
      required this.retailer_gst_controller,
      required this.retailer_ntn_controller,
      required this.retailer_id_controller,
      required this.retailer_route_id_controller})
      : super(key: key);

  @override
  _EditCustomerState createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  //Updated Customer
  Future<void> editCustomer() async {
    final url =
        'https://rholabproducts.com/api/mobileapp/customers/edit/${widget.retailer_id_controller.text}';

    print(
        'Customer id in future function ${widget.retailer_id_controller.text}');
    // Replace with the URL of the second API.
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: ({
        "secret_key": 'jfds3=jsldf38&r923m-cjowscdlsdfi03',
        "name": widget.retailer_name_controller.text, // Required
        "email": widget.retailer_email_controller.text,
        "phone": widget.retailer_phone_controller.text, // Required
        "cnic": widget.retailer_cnic_controller.text,
        "address": widget.retailer_address_controller.text,
        "city": widget.retailer_city_controller.text, // Required
        "state": widget.retailer_state_controller.text,
        "country": widget.retailer_country_controller.text,
        "postal": widget.retailer_postalcode_controller.text,
        "gst": widget.retailer_gst_controller.text,
        "ntn": widget.retailer_ntn_controller.text,
        "direct_customer": '1', // Required
        "route_id": widget.retailer_route_id_controller.text, // Required
        'customer_type': '2', // Required
      }),
    );

    if (response.statusCode == 200) {
      // Data successfully posted to the second API.
      final body = json.decode(response.body);
      print('DATA Successfullt');
      print(response.body);
      print(response.statusCode);
      print(response.reasonPhrase);
      show_msg_('Success', 'Customer updated successfully!', context);
    } else {
      print(response.statusCode);
      show_msg_('error', 'Access Denied!', context);
    }
  }
  // late CameraController _controller;
  // late Future<void> _initializeControllerFuture;

  //Gallery Wajih
  // final ImagePicker imagepicker = ImagePicker();
  // List<XFile> imageFileList = [];

  // List<XFile> selectedImages = [];

  // String selectedImagess = '';

  // void selectimage() async {
  //   selectedImages = await imagepicker.pickMultiImage();
  //   if (selectedImages.isNotEmpty) {
  //     imageFileList.addAll(selectedImages);
  //   }
  //   setState(() {
  //     selectedImagess = selectedImages.toString();
  //   });
  // }

//Gallery Wajih

//Camera Wajih
  Future<void> selectCameraImage() async {
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
  }

  bool _saving = false;
  // File? image_1;
  String localpath_1 = '';
  final _picker_1 = ImagePicker();
  bool load_1 = false;

  // File? image_2;
  String localpath_2 = '';
  final _picker_2 = ImagePicker();
  bool load_2 = false;

  // Future getImage_1(String text) async {
  //   final pickedFile = await _picker_1.pickImage(
  //       source: text == 'camera' ? ImageSource.camera : ImageSource.gallery,
  //       imageQuality: 80);

  //   if (pickedFile != null) {
  //     setState(() {
  //       localpath_1 = pickedFile.path;
  //       load_1 = true;
  //     });
  //   } else {
  //     setState(() {
  //       load_1 = false;
  //       localpath_1 = "";
  //     });
  //     print('no image selected');
  //   }
  // }

  // Future getImage_2() async {
  //   final pickedFile = await _picker_2.pickImage(
  //       source: ImageSource.gallery, imageQuality: 80);

  //   if (pickedFile != null) {
  //     setState(() {
  //       localpath_2 = pickedFile.path;
  //       load_2 = true;
  //     });
  //   } else {
  //     setState(() {
  //       localpath_2 = "";
  //     });
  //     print('no image selected');
  //   }
  // }

  // Future addCustomer(
  //   // String multiimages,
  //   String apiUrl,
  //   String imagePath1,
  //   String imagePath2,
  //   String customer_type,
  //   String direct_customer,
  //   String distributor_id,
  //   String name,
  //   String email,
  //   String phone,
  //   String cnic,
  //   String address,
  //   String city,
  //   String state,
  //   String country,
  //   String postal,
  //   String vat,
  //   String gst,
  //   String ntn,
  //   String route_id,
  //   String lati,
  //   String long,
  // ) async {
  //   try {
  //     setState(() {
  //       _saving = true;
  //     });
  //     var request = http.MultipartRequest(
  //       "POST",
  //       Uri.parse(apiUrl),
  //     );

  //     request.fields['secret_key'] = 'jfds3=jsldf38&r923m-cjowscdlsdfi03';
  //     request.fields['customer_type'] = customer_type.toString();
  //     request.fields['direct_customer'] = direct_customer.toString();
  //     request.fields['distributor_id'] = distributor_id.toString();
  //     request.fields['name'] = name.toString();
  //     request.fields['email'] = email.toString();
  //     request.fields['phone'] = phone.toString();
  //     request.fields['cnic'] = cnic.toString();
  //     request.fields['address'] = address.toString();
  //     request.fields['city'] = city.toString();
  //     request.fields['state'] = state.toString();
  //     request.fields['country'] = country.toString();
  //     request.fields['postal'] = postal.toString();
  //     request.fields['vat'] = vat.toString();
  //     request.fields['gst'] = gst.toString();
  //     request.fields['ntn'] = ntn.toString();
  //     request.fields['route_id'] = route_id.toString();
  //     request.fields['lati'] = lati.toString();
  //     request.fields['long'] = long.toString();
  //     if (imagePath1 != '') {
  //       request.files
  //           .add(await http.MultipartFile.fromPath('cnicfront', (imagePath1)));
  //     }
  //     if (imagePath2 != '') {
  //       request.files
  //           .add(await http.MultipartFile.fromPath('cnicback', (imagePath2)));
  //     }
  //     await request.send().then((value) async {
  //       var result = await value.stream.bytesToString();
  //       var res = jsonDecode(result);
  //       setState(() {
  //         _saving = false;
  //       });
  //       // print(res);
  //       if (res['code_status']) {
  //         // print('succeesss');
  //         show_msg_('success', 'Customer Create Successfully', context);
  //       } else {
  //         // print('error');
  //         show_msg_('error', res['message'], context);
  //       }
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  String customer_type =
      '2'; // 1=> Distrubutor, 2=> Retailer, 3 => End Consumer
  String direct_customer = '1';
  String distributor_id = '';
  String name = '';
  String email = '';
  String phone = '';
  String cnic = '';
  String address = '';
  String city = '';
  String state = '';
  String country = '';
  String postal = '';
  String vat = '';
  String gst = '';
  String ntn = '';
  String route_id = '';
  String latitude = '';
  String longitude = '';
  List<String> periorty = ['Direct', 'InDirect'];
  TextEditingController _customer_controller = new TextEditingController();
  TextEditingController _customer_id_controller = new TextEditingController();
  TextEditingController _routes_controller = new TextEditingController();
  // TextEditingController _routes_id_controller = new TextEditingController();
  TextEditingController _search_controller = new TextEditingController();
  TextEditingController _routes_search_controller = new TextEditingController();
  String search = '';
  String route_search = '';
  List _customer = [];
  List _routes = [];

  // Future<void> _fetchCustomer() async {
  //   setState(() {
  //     _saving = true;
  //   });
  //   var res = await api.get_customers('', '', '', '', '', '', '');

  //   if (res['code_status'] == true) {
  //     setState(() {
  //       _saving = false;
  //     });
  //     setState(
  //       () {
  //         _customer = res['customers'];
  //       },
  //     );
  //   }
  //   print(res);
  // }

  // Future<void> _fetchRoutes(String page, String limit, String text) async {
  //   setState(() {
  //     _saving = true;
  //   });
  //   var res = await api.get_routes(page, limit, text);
  //   if (res['code_status'] == true) {
  //     setState(() {
  //       _saving = false;
  //     });
  //     setState(
  //       () {
  //         _routes = res['routes'];
  //       },
  //     );
  //   }
  // }

  // show_location_mesag() async {
  //   await AwesomeDialog(
  //     context: context,
  //     dialogType: DialogType.info,
  //     animType: AnimType.rightSlide,
  //     dismissOnTouchOutside: false,
  //     title: 'Info',
  //     // desc: 'Please Pin Your Loaction for this Shop',
  //     desc: 'Location is Pinned',
  //     // btnCancelOnPress: () {},
  //     btnOkOnPress: () async {
  //       var location = await get_location();
  //       if (location != false) {
  //         latitude = location['lat'].toString();
  //         longitude = location['long'].toString();
  //       }
  //     },
  //   )
  //     ..show();
  // }

  // @override
  // void initState() {
  //   // To display the current output from the Camera,
  //   // create a CameraController.
  //   _controller = CameraController(
  //       // Get a specific camera from the list of available cameras.
  //       widget.camera,
  //       // Define the resolution to use.
  //       ResolutionPreset.medium);
  // }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    // _controller.dispose();
    super.dispose();
  }

  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    print('customer ID ${widget.retailer_id_controller.text}');
    print('Route id ${widget.retailer_route_id_controller.text}');
    // if (_routes.isEmpty) {
    //   _fetchRoutes('1', '100', '');
    // }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Edit Customer'),
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
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: SizedBox(
                          child: TextFormField(
                            controller: widget.retailer_name_controller,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Customer Name",
                              border:
                                  OutlineInputBorder(), //label text of field
                            ),
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Customer Name";
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
                        child: TextFormField(
                          controller: widget.retailer_email_controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Customer Email",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            email = value;
                          },
                          // validator: (String? value) {
                          //   // reg expression for email validation
                          //   if (!RegExp(
                          //           "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          //       .hasMatch(value!)) {
                          //     return ("Please Enter a valid email");
                          //   }
                          //   return null;
                          // },
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Email Is Required";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextFormField(
                          controller: widget.retailer_phone_controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Customer Phone",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            phone = value;
                          },
                          validator: (String? value) {
                            String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                            RegExp regExp = RegExp(pattern);
                            if (value?.length == 0) {
                              return 'Please Enter Your mobile number';
                            } else if (!regExp.hasMatch(value!)) {
                              return 'Please enter valid mobile number';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextFormField(
                          controller: widget.retailer_cnic_controller,
                          keyboardType: TextInputType.number,
                          maxLength: 13,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Customer CNIC",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            cnic = value;
                          },
                          // validator: (value) {
                          //   if (value!.isNotEmpty) {
                          //     return "CNIC Is Required";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextFormField(
                          controller: widget.retailer_city_controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Customer City",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            city = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "City Is Required";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextFormField(
                          controller: widget.retailer_state_controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Customer State",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            state = value;
                          },
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "State Is Required";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextFormField(
                          controller: widget.retailer_country_controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Customer Country",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            country = value;
                          },
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Country Is Required Or Invalid Country Name";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextFormField(
                          controller: widget.retailer_address_controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Customer Address",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            address = value;
                          },
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Address Is Required";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextFormField(
                          controller: _routes_controller,
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Customer Routes",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {},
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Routes Is Required";
                          //   }
                          //   return null;
                          // },
                          onTap: () => {
                            showMaterialModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return RoutesSearch(
                                      routes_name_controller:
                                          _routes_controller,
                                      routes_id_controller:
                                          widget.retailer_route_id_controller);
                                })
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextFormField(
                          controller: widget.retailer_postalcode_controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Customer Postal Code",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            postal = value;
                          },
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Postal Code Is Required";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 18),
                      //   child: TextFormField(
                      //     decoration: InputDecoration(
                      //       filled: true,
                      //       fillColor: Colors.white,
                      //       labelText: "VAT",
                      //       border: OutlineInputBorder(), //label text of field
                      //     ),
                      //     onChanged: (value) {
                      //       vat = value;
                      //     },
                      //     // validator: (value) {
                      //     //   if (value!.isEmpty) {
                      //     //     return "Vat Is Required";
                      //     //   }
                      //     //   return null;
                      //     // },
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextFormField(
                          controller: widget.retailer_gst_controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "GST",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            gst = value;
                          },
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "GST Is Required";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextFormField(
                          controller: widget.retailer_ntn_controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "NTN",
                            border: OutlineInputBorder(), //label text of field
                          ),
                          onChanged: (value) {
                            ntn = value;
                          },
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "NTN Is Required";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width * 0.9,
                      //   margin: EdgeInsets.symmetric(vertical: 10),
                      //   padding: EdgeInsets.symmetric(vertical: 10),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(10),
                      //     color: Theme.of(context).primaryColor,
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         'Upload shop image from gallery or Camera',
                      //         style: TextStyle(fontSize: 17),
                      //       ),
                      //       SizedBox(height: 10),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //         children: [
                      //           Container(
                      //             padding: EdgeInsets.all(8),
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(10),
                      //               color: Colors.white,
                      //             ),
                      //             child: GestureDetector(
                      //               onTap: () => getImage_1('camera'),
                      //               child: Icon(
                      //                 Icons.camera_alt,
                      //                 size: 35,
                      //               ),
                      //             ),
                      //           ),
                      //           Container(
                      //             padding: EdgeInsets.all(8),
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(10),
                      //               color: Colors.white,
                      //             ),
                      //             child: GestureDetector(
                      //               onTap: () => getImage_1('gallery'),
                      //               child: Icon(
                      //                 Icons.photo,
                      //                 size: 35,
                      //               ),
                      //             ),
                      //           ),
                      //           // Container(
                      //           //   padding: EdgeInsets.all(8),
                      //           //   decoration: BoxDecoration(
                      //           //     borderRadius: BorderRadius.circular(10),
                      //           //     color: Colors.white,
                      //           //   ),
                      //           //   child: GestureDetector(
                      //           //     onTap: () {
                      //           //       selectimage();
                      //           //     },
                      //           //     child: Icon(
                      //           //       Icons.photo,
                      //           //       size: 35,
                      //           //       color: Colors.black,
                      //           //     ),
                      //           //   ),
                      //           // )

                      //           // Expanded(
                      //           //   child: ElevatedButton.icon(
                      //           //     onPressed: () => {getImage_1()},
                      //           //     label: Text(''),
                      //           //     icon: Icon(Icons.camera_alt),
                      //           //   ),
                      //           // ),
                      //           // Expanded(
                      //           //   child: ElevatedButton.icon(
                      //           //     onPressed: () => {getImage_1()},
                      //           //     label: Text(''),
                      //           //     icon: Icon(Icons.photo),
                      //           //   ),
                      //           // ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      //Waqas
                      // Container(
                      //   child: (load_1 == false)
                      //       ? SizedBox()
                      //       : Image.file(
                      //           File(localpath_1).absolute,
                      //           height: 100,
                      //           width: 100,
                      //           fit: BoxFit.cover,
                      //         ),
                      // ),
                      // Waqas

                      // GridView.builder(
                      //   physics: NeverScrollableScrollPhysics(),
                      //   scrollDirection: Axis.vertical,
                      //   shrinkWrap: true,
                      //   itemCount: imageFileList.length,
                      //   itemBuilder: (BuildContext context, index) {
                      //     return Image.file(
                      //       File(imageFileList[index].path),
                      //       fit: BoxFit.cover,
                      //     );
                      //   },
                      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 5,
                      //   ),
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width * 0.9,
                      //   child: SizedBox(
                      //     width: 350,
                      //     child: ElevatedButton(
                      //       onPressed: () => {getImage_2()},
                      //       child: Text('Uplaod NIC Image'),
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   child: (load_2 == false)
                      //       ? SizedBox()
                      //       : Image.file(
                      //           File(localpath_2).absolute,
                      //           height: 100,
                      //           width: 100,
                      //           fit: BoxFit.cover,
                      //         ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      // ElevatedButton(
                      //   onPressed: () => {show_location_mesag()},
                      //   child: (latitude == null)
                      //       ? Text('Pin Shop Location')
                      //       : Text('Location Pinned'),
                      // ),
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50)),
                          onPressed: () async {
                            if (this._formKey.currentState!.validate()) {
                              this._formKey.currentState!.save();
                              // Updated Function
                              editCustomer();
                              //
                              // addCustomer(
                              //   // globals.create_customer,
                              //   'https://rholabproducts.com/rhocom_suppliers/api/mobileapp/customers/create',
                              //   // 'https://demo-rhotrack.rholabproducts.com/api/mobileapp/customers/create',
                              //   localpath_1,
                              //   localpath_2,
                              //   // imageFileList.toString(),
                              //   // selectedImagess,
                              //   customer_type,
                              //   direct_customer,
                              //   _customer_id_controller.text,
                              //   name,
                              //   email,
                              //   phone,
                              //   cnic,
                              //   address,
                              //   city,
                              //   state,
                              //   country,
                              //   postal,
                              //   vat,
                              //   gst,
                              //   ntn,
                              //   _routes_id_controller.text,
                              //   latitude,
                              //   longitude,
                              // );
                              // if (latitude == '') {
                              //   show_msg_(
                              //       'error', 'Please Pin Location', context);
                              // } else {
                              //   setState(() {
                              //     _saving = true;
                              //   });
                              //   print('Add Customer Dart File');
                              //   print('Customer Type $customer_type');
                              //   print(
                              //       'Customer Direct Customer $direct_customer');
                              //   print('Distributer ID $distributor_id');
                              //   print('namess $name');
                              //   print('email $email');
                              //   print('phone $phone');
                              //   print('cnic $cnic');
                              //   print('address $address');
                              //   print('city $city');
                              //   print('state $state');
                              //   print('country $country');
                              //   print('postal $postal');
                              //   print('vat $vat');
                              //   print('gst $gst');
                              //   print('ntn $ntn');
                              //   print('route_id $route_id');
                              //   print('latitude $latitude');
                              //   print('longitude $longitude');

                              //   addCustomer(
                              //     // globals.create_customer,
                              //     'https://rholabproducts.com/rhocom_suppliers/api/mobileapp/customers/create',
                              //     // 'https://demo-rhotrack.rholabproducts.com/api/mobileapp/customers/create',
                              //     localpath_1,
                              //     localpath_2,
                              //     // imageFileList.toString(),
                              //     // selectedImagess,
                              //     customer_type,
                              //     direct_customer,
                              //     _customer_id_controller.text,
                              //     name,
                              //     email,
                              //     phone,
                              //     cnic,
                              //     address,
                              //     city,
                              //     state,
                              //     country,
                              //     postal,
                              //     vat,
                              //     gst,
                              //     ntn,
                              //     _routes_id_controller.text,
                              //     latitude,
                              //     longitude,
                              //   );
                              //   // var res = await api.create_customer_with_nic(
                              //   //   customer_type,
                              //   //   direct_customer,
                              //   //   _customer_id_controller.text,
                              //   //   name,
                              //   //   email,
                              //   //   phone,
                              //   //   cnic,
                              //   //   address,
                              //   //   city,
                              //   //   state,
                              //   //   country,
                              //   //   postal,
                              //   //   vat,
                              //   //   gst,
                              //   //   ntn,
                              //   //   route_id,
                              //   //   latitude,
                              //   //   longitude,
                              //   //   localpath_1,
                              //   //   localpath_2,
                              //   // );
                              //   // var _route = ModalRoute.of(context)
                              //   //     ?.settings
                              //   //     .name
                              //   //     .toString();
                              //   // var splitted = _route?.split('/');
                              //   // print(res);
                              //   // if (res['code_status'] == true) {
                              //   //   setState(() {
                              //   //     _saving = false;
                              //   //   });
                              //   //   AwesomeDialog(
                              //   //     context: context,
                              //   //     dialogType: DialogType.success,
                              //   //     animType: AnimType.rightSlide,
                              //   //     title: 'Success',
                              //   //     desc: 'Customer Add Successfully',
                              //   //     // btnCancelOnPress: () {},
                              //   //     btnOkOnPress: () {
                              //   //       if (widget.type == 'customer') {
                              //   //         Navigator.pushReplacement(
                              //   //           context,
                              //   //           MaterialPageRoute(
                              //   //             builder: (context) => CustomerVisit(),
                              //   //           ),
                              //   //         );
                              //   //         // Navigator.pushNamed(context, '/reatiler_visit');
                              //   //       } else {
                              //   //         Navigator.pushReplacement(
                              //   //           context,
                              //   //           MaterialPageRoute(
                              //   //             builder: (context) => RetailerVisit(),
                              //   //           ),
                              //   //         );

                              //   //         // Navigator.pushNamed(context, '/customer_visit');
                              //   //       }
                              //   //     },
                              //   //   )..show();
                              //   // } else {
                              //   //   setState(() {
                              //   //     _saving = false;
                              //   //   });
                              //   //   show_msg_('error', res['message'], context);
                              //   // }
                              // }
                            }
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validEnglish(String value) {
    RegExp regex = RegExp(r'/^[A-Za-z0-9]*$');
    return (!regex.hasMatch(value)) ? false : true;
  }
}

show_msg_(status, message, context) {
  return AwesomeDialog(
    context: context,
    dialogType: (status == 'error') ? DialogType.error : DialogType.success,
    animType: AnimType.rightSlide,
    title: (status == 'error') ? 'Error' : 'Success',
    desc: message,
    // btnCancelOnPress: () {},
    btnOkOnPress: () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => RetailerVisit())));
    },
  )..show();
}
