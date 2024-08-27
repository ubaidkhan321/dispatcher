import 'package:flutter/material.dart';
// for using HttpClient
import 'dart:convert'; // for using json.decode()
import 'package:http/http.dart' as http;
import '../../helpers/globals.dart';

class RoutesList extends StatefulWidget {
  const RoutesList({Key? key}) : super(key: key);

  @override
  State<RoutesList> createState() => _RoutesListState();
}

class _RoutesListState extends State<RoutesList> {
  final List _res = [];
  List products = [];
  List _orders = [];
  var secret = globals.secret_key;
  bool _isLoading = false;

  Future<void> _fetchData() async {
    // const apiUrl =
    //     'https://demo-rhotrack.rholabproducts.com/api/mobileapp/products/lists';

    const apiUrl =
        'https://rholabproducts.com/api/mobileapp/products/listsrholab';

    // const apiUrl =
    // 'https://rhotrack.rholabproducts.com/api/mobileapp/products/lists';
    final response = await http.post(Uri.parse(apiUrl),
        encoding: Encoding.getByName('utf8'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          "secret_key": secret
        });

    final data = json.decode(response.body);

    if (data['code_status'] == true) {
      setState(() {
        products = data['products'];
        var finalOrder = [];
        List<dynamic> jsonData;
        for (var order in products) {
          // order.add('selected', '1');
          order['isSelected'] = false;
          finalOrder.add(order);
          // print(order['product_id']);
          // final_order.add(order);
          // print(final_order);
        }
        _orders = finalOrder;
      });
    }
  }

  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    _fetchData();
    setState(() {
      _isLoading = false;
    });
    return SingleChildScrollView(
      child: SafeArea(
        child: _orders.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _controller,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _orders.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Shop No 01'),
                      leading: Icon(Icons.location_city),
                      trailing: Text(
                        "Pending",
                        style: TextStyle(
                            color: Color.fromARGB(255, 243, 183, 62),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
