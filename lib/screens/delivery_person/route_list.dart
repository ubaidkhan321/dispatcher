import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/api.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'reatiler_visit.dart';

class RouteList extends StatefulWidget {
  const RouteList({Key? key}) : super(key: key);

  @override
  _RouteListState createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  bool isLoading = false;
  @override
  String? user_id = '';
  List _routes = [];
  Future<void> _fetchRoutes(
    String user_id,
  ) async {
    print('The User Id Is Here');
    setState(() {
      isLoading = true;
    });

    var res = await api.get_dm_routes(
      user_id,
    );
    print(res);
    if (res['code_status'] == true) {
      setState(
        () {
          _routes = res['rows'];
        },
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  static _read(thekey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = thekey.toString();
    final value = prefs.getString(key);
    print('saved tester $value');
    String usu = (value != null ? value : '');
    return usu;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String my_user = await _read('user_id');
      var now = new DateTime.now();
      var inputFormat = DateFormat('yyyy-MM-dd');
      String formattedDate = inputFormat.format(now);
      // print(formattedDate);
      await _fetchRoutes(
        my_user,
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Routes List'),
          centerTitle: true,
        ),
        body: isLoading == true
            ? Center(child: CircularProgressIndicator())
            : _routes.isEmpty
                ? Center(
                    child: Container(
                        child: Text(
                      'No routes assign for delivery',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _routes.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReatilerVisit(
                                  route_id: _routes[index]['route_id'],
                                  route_name:
                                      _routes[index]['route_name'].toString(),
                                ),
                              ));
                        },
                        child: Card(
                          child: ListTile(
                            leading: Icon(Icons.inventory_2),
                            title:
                                Text(_routes[index]['route_name'].toString()),
                            subtitle: Text(
                                _routes[index]["route_address"].toString()),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                        ),
                      );
                    },
                  ));
  }

  void getdata() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');

    // user_name = prefs.getString('user_name');
    // retailer_visit_puched = prefs.getBool('retailer_visit_punch');
    // retailer_visit_id = prefs.getString('retailer_visit_id');
    // retailer_visit_name = prefs.getString('retailer_visit_name');
    setState(() {});
  }
}
