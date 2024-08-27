// import 'dart:htm
import 'package:dio/dio.dart';
import 'package:linear/screens/login.dart';
import 'package:linear/screens/order_booker/retailer_visit.dart';
import 'package:linear/screens/orders/add_order.dart';
import 'package:linear/screens/splash_screen/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:linear/screens/order_booker/dashboard.dart';

// int randomSixDigitNumber = 0;
// String po_date = '';

class api {
  // static var order_booker_name = "";
  static int randomSixDigitNumber = 0;
  static String po_date = '';
  Dio dio = new Dio();
  static Future login(String username, String password, String group_id) async {
    // print(query);
    var secret = globals.secret_key;
    var login_api = globals.login_api;
    final response = await http.post(Uri.parse(login_api), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "username": username,
      "password": password,
      "group_id": group_id,
    });
    print('Login API');
    print('Group ID $group_id');
    print('User name $username');
    print('Password $password');
    // print(object)
    final data = json.decode(response.body);
    print("Login Data $data");

    // print(api.order_booker_name);
    return data;
  }

  static Future get_orders(
      String page, String limit, String text, String created_by) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.get_order;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "page": page,
      "limit": limit,
      "text": text,
      "created_by": created_by,
    });
    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 2), () {
      return data;
    });
  }

  static Future get_complain_details(String id) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.get_complain_details;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "id": id,
    });
    print('Get Complain Detail $id');
    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 2), () {
      return data;
    });
  }

  static Future get_customers(
      String page,
      String limit,
      String text,
      String route_id,
      String type,
      String direct_customer,
      String distributor_id) async {
    // print(query);
    // print("The Routes Id");
    // print(route_id);
    var secret = globals.secret_key;
    var api_url = globals.customer_list;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "page": page,
      "limit": limit,
      "text": text,
      "route_id": route_id,
      "type": type,
      "direct_customer": direct_customer,
      "distributor_id": distributor_id,
    });
    print('GET CUSTOMER');
    print('Page $page');
    print('Limit $limit');
    print('text $text');
    print('route_id $route_id');
    print('type $type');
    print('direct_customer $direct_customer');
    print('distributor_id $distributor_id');

    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 2), () {
      return data;
    });
  }

  static Future get_catgories(
      String page, String limit, String text, String parent_id) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.get_categories;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "page": page,
      "limit": limit,
      "text": text,
      "parent_id": parent_id,
    });
    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 2), () {
      return data;
    });
  }

  static Future get_journey(String user_id) async {
    var secret = globals.secret_key;
    var api_url = globals.get_journey;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "user_id": user_id,
    });
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future get_stock(String customer_id) async {
    var secret = globals.secret_key;
    var api_url = globals.get_stock;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer_id": customer_id,
    });
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future get_stock_list(
      String page, String limit, String user_id) async {
    var secret = globals.secret_key;
    var api_url = globals.get_stock_list;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "page": page,
      "limit": limit,
      "user_id": user_id,
    });
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future order_history(String customer_id) async {
    var secret = globals.secret_key;
    var api_url = globals.order_history;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer_id": customer_id,
    });
    print('Secret key order history $secret');
    print('Customer ID order history $customer_id');
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future get_payment_details(String id) async {
    var secret = globals.secret_key;
    var api_url = globals.payment_details;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "id": id,
    });
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future get_stock_details(String id) async {
    var secret = globals.secret_key;
    var api_url = globals.get_stock_details;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "id": id,
    });
    print("Stock Info ID $id");

    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future get_complain_list(
      String page,
      String limit,
      String text,
      String customer,
      String to,
      String from,
      String priority,
      String status,
      String user_id) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.get_complain_list;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "page": page,
      "limit": limit,
      "text": text,
      "customer": customer,
      "to": to,
      "from": from,
      "priority": priority,
      "status": status,
      "user_id": user_id,
    });
    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 2), () {
      return data;
    });
  }

  static Future create_complain(String customer, String subject, String message,
      String priority, String created_by) async {
    // print(query);
    var secret = globals.secret_key;
    var login_api = globals.create_complain;
    final response = await http.post(Uri.parse(login_api), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer": customer,
      "subject": subject,
      "message": message,
      "priority": priority,
      "created_by": created_by
    });
    final data = json.decode(response.body);
    return data;
  }

  static Future get_products(
    String page,
    String limit,
    String text,
    String category,
    String sub_category,
    String warehouse_id,
    String brand,
    String supplier_id,
  ) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.product_list;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "page": page,
      "limit": limit,
      "text": text,
      "category": category,
      "sub_category": sub_category,
      "warehouse_id": Login.warehouseid_login,
      "brand": brand,
      "supplier": supplier_id,
    });
    print('PAGE  $page');
    print('limit $limit');
    print('text $text');
    print('category $category');
    print('sub_category $sub_category');
    print('warehouse_id $warehouse_id');
    print('brand $brand');
    print('supplier $supplier_id');
    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 2), () {
      return data;
    });
  }

  static Future set_track(
      String user_id,
      String gps_latitude,
      String gps_longitude,
      String gsm_latitude,
      String gsm_longitude,
      String bettery) async {
    // print(query);
    var secret = globals.secret_key;
    var login_api = globals.tracking;
    final response = await http.post(
      Uri.parse(login_api),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: {
        "secret_key": secret,
        "user_id": user_id,
        "gps_latitude": gps_latitude,
        "gps_longitude": gps_longitude,
        "gsm_latitude": gsm_latitude,
        "gsm_longitude": gsm_longitude,
        "battery": bettery,
      },
    );

    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 10), () {
    return data;
    // });
  }

  static Future set_punched(
    String user_id,
    String gps_latitude,
    String gps_longitude,
    String gsm_latitude,
    String gsm_longitude,
    String bettery,
    String type,
    String route_id,
    String shop_id,
    String status,
  ) async {
    // print(query);
    var secret = globals.secret_key;
    var login_api = globals.punched;
    final response = await http.post(Uri.parse(login_api), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "user_id": user_id,
      "gps_latitude": gps_latitude,
      "gps_longitude": gps_longitude,
      "gsm_latitude": gsm_latitude,
      "gsm_longitude": gsm_longitude,
      "battery": bettery,
      "type": type,
      "route_id": route_id,
      "shop_id": shop_id,
      "status": status,
    });
    final data = json.decode(response.body);
    print(' wajih data  $data');
    print('wajih status code ${response.statusCode}');
    print('wajih reason ${response.reasonPhrase}');
    print("user Id $user_id");
    print('gps_latitude $gps_latitude');
    print('gps_longitude $gps_longitude');
    print('gsm_latitude $gsm_latitude');
    print('gsm_longitude $gsm_longitude');
    print('battery $bettery');
    print('Type $type');
    print('Route id $route_id');
    print('shop_id $shop_id');
    print('Status $status');

    // print('punch in data $data');
    // return Future.delayed(const Duration(seconds: 10), () {
    return data;
    // });
  }

  static Future get_routes(String page, String limit, String text) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.routes_list;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "page": page,
      "limit": limit,
      "text": text,
    });
    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 2), () {
      return data;
    });
  }

  static Future get_due_invoice(String customer_id) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.get_due_invoice;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer_id": customer_id
    });
    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 2), () {
      return data;
    });
  }

  static Future get_supplier(String page, String limit, String text) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.get_supplier_list;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "page": page,
      "limit": limit,
      "text": text,
    });
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future get_customer_by_id(String customer_id) async {
    var secret = globals.secret_key;
    var api_url = globals.get_customer_by_id;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer_id": customer_id,
    });

    print('GEt Customer by id Api');
    print('Customer ID $customer_id');
    RetailerVisit.customers_idss = customer_id;
    print('Retailer visit id ${RetailerVisit.customers_idss}');
    final data = json.decode(response.body);

    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future get_servey(String type) async {
    var secret = globals.secret_key;
    var api_url = globals.get_servey;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "type": type,
    });
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

//
  static Future get_distance(
      String page,
      String limit,
      String route_id,
      String type,
      String direct_customer,
      String distributor_id,
      String id,
      String user_latitude,
      String text) async {
    var secret = globals.secret_key;
    var api_url = globals.check_distance;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "page": page,
      "limit": limit,
      "route_id": route_id,
      "type": type,
      "distributor_id": distributor_id,
      "user_longitude": user_latitude,
      "user_latitude": user_latitude,
      "text": text
    });
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future tracking_history(
    String user_id,
  ) async {
    var secret = globals.secret_key;
    var api_url = globals.tracking_history;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "user_id": user_id,
    });
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future get_werehouses() async {
    var secret = globals.secret_key;
    var api_url = globals.get_werehouses;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
    });
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future get_targets(String user_id) async {
    var secret = globals.secret_key;
    var api_url = globals.get_target;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "user_id": user_id
    });
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future get_feedback_list(
      String text,
      String customer,
      String to,
      String from,
      String user_id,
      String status,
      String page,
      String limit) async {
    var secret = globals.secret_key;
    var api_url = globals.feedback_list;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer": customer,
      "text": text,
      "to": to,
      "from": from,
      "user_id": user_id,
      "status": status,
      "page": page,
      "limit": limit,
    });
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future get_feedback_details(String id) async {
    var secret = globals.secret_key;
    var api_url = globals.feedback_details;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "id": id,
    });
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future get_servey_list(String user_id) async {
    var secret = globals.secret_key;
    var api_url = globals.servey_list;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "user_id": user_id,
    });

    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future servey_details(
    String customer,
    String date,
  ) async {
    var secret = globals.secret_key;
    var api_url = globals.servey_details;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer": customer,
      "date": date,
    });
    print('Survey Details');
    print('Customer $customer');
    print('Date $date');
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future update_cordinates(
      String customer_id, String latitude, String longitude) async {
    var secret = globals.secret_key;
    var api_url = globals.update_cordinates;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer_id": customer_id,
      "latitude": latitude,
      "longitude": longitude,
    });
    print('Update Co ordinates');
    print('customer_id $customer_id');
    print('Latitude $latitude');
    print('Longitude $longitude');
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future add_servey(
      String customer, String user_id, String questions) async {
    var secret = globals.secret_key;
    var api_url = globals.add_servey;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer": customer,
      "user_id": user_id,
      "questions": questions,
    });
    print('Add Survery');
    print('Customer $customer');
    print('User ID $user_id');
    print("Questions $questions");
    final data = json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 2), () {
    return data;
    // });
  }

  static Future create_customer_with_nic(
    String customer_type,
    String direct_customer,
    String distributor_id,
    String name,
    String email,
    String phone,
    String cnic,
    String address,
    String city,
    String state,
    String country,
    String postal,
    String vat,
    String gst,
    String ntn,
    String route_id,
    String lati,
    String long,
    String imagePath1,
    String imagePath2,
  ) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(globals.create_customer),
    );
    print('Customer Type $customer_type');
    print('Customer Direct Customer $direct_customer');
    print('Distributer ID $distributor_id');
    print('namess $name');
    print('email $email');
    print('phone $phone');
    print('cnic $cnic');
    print('address $address');
    print('city $city');
    print('state $state');
    print('country $country');
    print('postal $postal');
    print('vat $vat');
    print('gst $gst');
    print('ntn $ntn');
    print('route_id $route_id');
    print('latitude $lati');
    print('longitude $long');
    request.fields['secret_key'] = 'jfds3=jsldf38&r923m-cjowscdlsdfi03';
    request.fields['customer_type'] = customer_type.toString();
    request.fields['direct_customer'] = direct_customer.toString();
    request.fields['distributor_id'] = distributor_id.toString();
    request.fields['name'] = name.toString();
    request.fields['email'] = email.toString();
    request.fields['phone'] = phone.toString();
    request.fields['cnic'] = cnic.toString();
    request.fields['address'] = address.toString();
    request.fields['city'] = city.toString();
    request.fields['state'] = state.toString();
    request.fields['country'] = country.toString();
    request.fields['postal'] = postal.toString();
    request.fields['vat'] = vat.toString();
    request.fields['gst'] = gst.toString();
    request.fields['ntn'] = ntn.toString();
    request.fields['route_id'] = route_id.toString();
    request.fields['latitude'] = lati.toString();
    request.fields['longitude'] = long.toString();
    if (imagePath1 != '') {
      request.files
          .add(await http.MultipartFile.fromPath('cnicfront', (imagePath1)));
    }
    if (imagePath2 != '') {
      request.files
          .add(await http.MultipartFile.fromPath('cnicback', (imagePath2)));
    }
    await request.send().then((value) async {
      var result = await value.stream.bytesToString();
      final res = json.decode(result);
      return res;
    });
  }

  static Future create_customer(
    String customer_type,
    String direct_customer,
    String distributor_id,
    String name,
    String email,
    String phone,
    String cnic,
    String address,
    String city,
    String state,
    String country,
    String postal,
    String vat,
    String gst,
    String ntn,
    String route_id,
    String lati,
    String long,
  ) async {
    // print(query);
    var secret = globals.secret_key;
    var login_api = globals.create_customer;
    final response = await http.post(Uri.parse(login_api), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer_type": customer_type,
      "direct_customer": direct_customer,
      "distributor_id": distributor_id,
      "name": name,
      "email": email,
      "phone": phone,
      "cnic": cnic,
      "address": address,
      "city": city,
      "state": state,
      "country": country,
      "postal": postal,
      "vat": vat,
      "gst": gst,
      "ntn": ntn,
      "route_id": route_id,
      "latitude": lati,
      "longitude": long,
    });

    final data = json.decode(response.body);
    print('Customer Type $customer_type');
    print('Customer Direct Customer $direct_customer');
    print('Distributer ID $distributor_id');
    print('name $name');
    print('email $email');
    print('phone $phone');
    print('cnic $cnic');
    print('address $address');
    print('city $city');
    print('state $state');
    print('country $country');
    print('postal $postal');
    print('vat $vat');
    print('gst $gst');
    print('ntn $ntn');
    print('route_id $route_id');
    print('latitude $lati');
    print('longitude $long');

    // return Future.delayed(const Duration(seconds: 10), () {
    return data;
    // });
  }

  static Future add_stock(
    String customer_id,
    String created_by,
    String items,
  ) async {
    // print(query);
    var secret = globals.secret_key;
    var login_api = globals.add_stock;
    final response = await http.post(Uri.parse(login_api), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer_id": customer_id,
      "created_by": created_by,
      "items": items,
    });
    // print(response.body);
    print('Stock Info');
    print('Customer ID $customer_id');
    print('Created By $created_by');
    print('Items $items');

    final data = await json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 3), () {
    return data;
    // print(data);
    // return Future.value(data);
    // });
  }

  static Future create_feedback(
    String customer,
    String subject,
    String message,
    String created_by,
  ) async {
    // print(query);
    var secret = globals.secret_key;
    var login_api = globals.create_feedback;
    final response = await http.post(Uri.parse(login_api), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer": customer,
      "subject": subject,
      "message": message,
      "created_by": created_by,
    });
    // print(response.body);
    print('Feedback Customer $customer');
    print('Feedback Subject $subject');
    print('Feedback Message $message');
    print('created_by $created_by');
    final data = await json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 3), () {
    return data;
    // print(data);
    // return Future.value(data);
    // });
  }

  static Future add_order(
    String warehouse_id,
    String po_number,
    po_date,
    String customer_id,
    String supplier_id,
    String user_id,
    String items,
  ) async {
    // print(query);.z
    var secret = globals.secret_key;
    var login_api = globals.create_order;
    //
    Random random = Random();
    int min = 100000; // Minimum 6-digit number
    int max = 999999; // Maximum 6-digit number
    randomSixDigitNumber = min + random.nextInt(max - min + 1);
//
    final response = await http.post(Uri.parse(login_api), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "warehouse_id": Login.warehouseid_login,
      "po_number": 'Mobileapp-${Dashboard.user_idss}${AddOrder.counterss}',
      "po_date": po_date,
      "customer_id": customer_id,
      "supplier_id": supplier_id,
      "user_id": user_id,
      "items": items,
    });
    // print("Create Order $response");
    print('Secret Key $secret');
    print('warehouse_id $warehouse_id');
    print('po_number $po_number ');
    print('po_date $po_date');
    print('customer_id $customer_id');
    print('supplier_id $supplier_id');
    print('user_id $user_id');
    print('items $items');
    final data = await json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 3), () {
    return data;
    // print(data);
    // return Future.value(data);
    // });
  }

  static Future create_payment(FormData data) async {
    return data;
    // Response response = await Dio().post(
    //     globals.create_payment,
    //     data: data,
    //   );
    // try {
    //   Response response = await Dio().post(
    //     globals.create_payment,
    //     data: data,
    //   );

    //   print(response.statusCode);
    //   // if (response.statusCode == 201) {
    //   //   return true;
    //   // }
    //   // return false;
    // } catch (e) {
    //   print(e);
    //   // return false;
    // }
  }

  // static Future create_payment_with_image(
  //   String sale_id,
  //   String customer_id,
  //   String paid_by,
  //   String cheque_no,
  //   String amount,
  //   String created_by,
  //   String note,
  //   String note,
  // ) async {
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "multipart/form-data"
  //   };

  //   var length = await attachment.length();
  //   var filename = basename(attachment.path);

  //   var stream = new http.ByteStream(attachment!.openRead());

  //   var login_api = globals.create_payment;
  //   var uri = Uri.parse(login_api);
  //   var request = new http.MultipartRequest('POST', uri);
  //   request.headers['Content-Type'] = "multipart/form-data";
  //   var secret = globals.secret_key;

  //   request.fields['secret_key'] = secret;
  //   request.fields['sale_id'] = sale_id;
  //   request.fields['customer_id'] = customer_id;
  //   request.fields['paid_by'] = paid_by;
  //   request.fields['cheque_no'] = cheque_no;
  //   request.fields['amount'] = amount;
  //   request.fields['created_by'] = created_by;
  //   request.fields['note'] = note;
  //   var multiprt =
  //       http.MultipartFile('attachment', stream, length, filename: filename);
  //   request.files.add(multiprt);

  //   var response = await request.send();
  //   print(response.statusCode);
  //   response.stream.transform(utf8.decoder).listen((value) {
  //     print(value);
  //   });
  // }

  static Future create_payment_w_o_image(
    String sale_id,
    String customer_id,
    String paid_by,
    String cheque_no,
    String amount,
    String created_by,
    // File attachment,
    String note,
  ) async {
    var secret = globals.secret_key;
    var login_api = globals.create_payment;
    final response = await http.post(Uri.parse(login_api), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "sale_id": sale_id,
      "customer_id": customer_id,
      "paid_by": paid_by,
      "cheque_no": cheque_no,
      "amount": amount,
      "created_by": created_by,
      "note": note,
    });
    print('Create Payment');
    print("Sale Id $sale_id");
    print('Customer_ID $customer_id');
    print('Paid By $paid_by');
    print('Cheague no $cheque_no');
    print("Amount $amount");
    print('Created By $created_by');
    print('Note $note');
    print('Create Payment ${response.body}');
    final data = await json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 3), () {
    return data;
  }

  static Future Order_tracking_data(
      // File attachment,

      ) async {
    var secret = globals.secret_key;
    var apiurl = globals.order_tracking;
    final response = await http.post(Uri.parse(apiurl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "order_bookerid": Dashboard.user_idss,
    });

    final data = await json.decode(response.body);
    print(data);
    // return Future.delayed(const Duration(seconds: 3), () {
    return data;
  }

  // static Future create_payment_w_o_image(
  //   String sale_id,
  //   String customer_id,
  //   String paid_by,
  //   String cheque_no,
  //   String amount,
  //   String created_by,
  //   // File attachment,
  //   String note,
  // ) async {
  //   var secret = globals.secret_key;
  //   var login_api = globals.create_payment;
  //   final response = await http.post(Uri.parse(login_api), headers: {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   }, body: {
  //     "secret_key": secret,
  //     "sale_id": sale_id,
  //     "customer_id": customer_id,
  //     "paid_by": paid_by,
  //     "cheque_no": cheque_no,
  //     "amount": amount,
  //     "created_by": created_by,
  //     "note": note,
  //   });
  //   print(response.body);
  //   final data = await json.decode(response.body);
  //   // return Future.delayed(const Duration(seconds: 3), () {
  //   return data;
  // }

  static Future confirm_location(
    String lat,
    String long,
    String customer_id,
    // File attachment,
  ) async {
    var secret = globals.secret_key;
    var login_api = globals.confirm_location;
    final response = await http.post(Uri.parse(login_api), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "customer_id": customer_id,
      "user_longitude": lat,
      "user_latitude": long,
    });
    print(response.body);
    final data = await json.decode(response.body);
    // return Future.delayed(const Duration(seconds: 3), () {
    return data;
  }

  static Future get_order_booker(String area_manager_id) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.get_order_bookers;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "area_manager": area_manager_id,
    });
    print('Area Manager ID $area_manager_id');
    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 2), () {
      return data;
    });
  }

  static Future get_payment_list(
    String page,
    String limit,
    String customer_id,
    String sale_id,
    String status,
    String user_id,
  ) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.payment_list;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "page": page,
      "limit": limit,
      "customer_id": customer_id,
      "sale_id": sale_id,
      "status": status,
      "user_id": user_id,
    });
    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 2), () {
      return data;
    });
  }

  static Future get_dm_routes(
    String user_id,
    // String date,
    // String status,
  ) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.dm_routes_list;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "user_id": user_id,
      // "date": date,
      // "status": status,
    });
    print('Route List');
    print('USER ID $user_id');
    // print('date $date');
    // print('STATUS $status');
    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 1), () {
      return data;
    });
  }

  static Future get_dm_shops(
    String user_id,
    // String date,
    // String status,
    String route,
  ) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.dm_shop_list;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "user_id": user_id,
      // "date": date,
      // "status": status,
      "route": route,
    });
    print('Shop List');
    print('USER ID $user_id');
    // print('DATE $date');
    // print('STATUS $status');
    print('ROUTE $route');
    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 1), () {
      return data;
    });
  }

  static Future get_dm_orders(
    String user_id,
    // String date,
    // String status,
    String route,
    String shop,
  ) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.dm_order_list;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "user_id": user_id,
      // "date": date,
      // "status": status,
      "route": route,
      "shop": shop,
    });
    final data = json.decode(response.body);
    print('DM Order List');
    print('User Id $user_id');
    // print('Date $date');
    // print('status $status');
    print('Route $route');
    print('Shop $shop');
    return Future.delayed(const Duration(seconds: 1), () {
      return data;
    });
  }

  static Future get_single_orders(
    String id,
  ) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.get_single_order_api;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "id": id,
    });
    print('Sales orders/orders $id');
    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 1), () {
      return data;
    });
  }

  static Future get_single_sale(
    String id,
  ) async {
    // print(query);
    var secret = globals.secret_key;
    var api_url = globals.get_single_sale_api;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "id": id,
    });
    final data = json.decode(response.body);
    return Future.delayed(const Duration(seconds: 1), () {
      return data;
    });
  }

  static Future dm_update_status(
    String user_id,
    String id,
    String status,
    // File attachment,
  ) async {
    var secret = globals.secret_key;
    var login_api = globals.dm_update_status;
    final response = await http.post(Uri.parse(login_api), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "user_id": user_id,
      "id": id,
      "status": status,
    });
    print('Update Status');
    print('User ID $user_id');
    print('ID $id');
    print('Status $status');
    final data = await json.decode(response.body);
    return data;
  }

  static Future get_dp_targets(String user_id, String date) async {
    var secret = globals.secret_key;
    var api_url = globals.dm_summery;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "user_id": user_id,
      "date": date,
    });
    print('Summery Detail');
    print('USER ID $user_id');
    print('Date $date');
    final data = json.decode(response.body);
    return data;
  }

  static Future sales_Return(
      var item_id, var qty, var reason, var sale_id) async {
    var secret = globals.secret_key;
    var api_url = globals.sales_return;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "item_ids": item_id,
      "qty": qty,
      "reason": reason,
      "sale_id": sale_id,
    });
    final data = json.decode(response.body);
    return data;
  }

  static Future updateRemarks(
    sale_id,
    remarks,
  ) async {
    var secret = globals.secret_key;
    var api_url = globals.updateRemarks;
    final response = await http.post(Uri.parse(api_url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "secret_key": secret,
      "sale_id": sale_id,
      "remarks": remarks,
    });
    final data = json.decode(response.body);
    return data;
  }

  static Future setdata(key, setValue) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, setValue);
  }
}
