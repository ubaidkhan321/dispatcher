import 'package:flutter/material.dart';
import 'complain_detail.dart';
import 'shops_locations.dart';
import '../../helpers/globals.dart';
import '../../helpers/api.dart';
// for using HttpClient
import 'dart:convert'; // for using json.decode()
import 'package:http/http.dart' as http;

class RoutesPlan extends StatefulWidget {
  const RoutesPlan({Key? key}) : super(key: key);

  @override
  _RoutesPlanState createState() => _RoutesPlanState();
}

class _RoutesPlanState extends State<RoutesPlan> {
  List _complains = [];
  Future<void> _fetchData() async {
    var res = await api.get_routes('', '', '');
    if (res['code_status'] == true) {
      setState(
        () {
          _complains = res['routes'];
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_complains.isEmpty) {
      _fetchData();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Today Plan'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _complains.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _complains.length,
                itemBuilder: (BuildContext ctx, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ShopsLocations(id: _complains[index]['id']),
                          ));
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.inventory_2),
                        title: Text(_complains[index]['name']),
                        subtitle: Text(_complains[index]["address"]),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
