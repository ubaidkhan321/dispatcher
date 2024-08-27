import 'package:flutter/material.dart';
import 'complain_detail.dart';
import '../../helpers/globals.dart';
import '../../helpers/api.dart';
// for using HttpClient
import 'dart:convert'; // for using json.decode()
import 'package:http/http.dart' as http;

class ComplainList extends StatefulWidget {
  const ComplainList({Key? key}) : super(key: key);

  @override
  _ComplainListState createState() => _ComplainListState();
}

class _ComplainListState extends State<ComplainList> {
  List _complains = [];
  Future<void> _fetchData() async {
    var res = await api.get_complain_list('', '', '', '', '', '', '', '', '');
    if (res['code_status'] == true) {
      setState(
        () {
          _complains = res['complains'];
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
        title: Text('Complains'),
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
                                ComplainDetail(id: _complains[index]['id']),
                          ));
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.inventory_2),
                        title: Text(_complains[index]['subject']),
                        subtitle: Text(_complains[index]["status"]),
                      ),
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/complain/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
