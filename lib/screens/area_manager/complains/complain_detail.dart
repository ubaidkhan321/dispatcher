import 'package:flutter/material.dart';
import '../../../helpers/globals.dart';
import '../../../helpers/api.dart';
import 'dart:convert'; // for using json.decode()
import 'package:http/http.dart' as http;

class ComplainDetail extends StatefulWidget {
  final String id;
  const ComplainDetail({Key? key, required this.id}) : super(key: key);

  @override
  _ComplainDetailState createState() => _ComplainDetailState();
}

class _ComplainDetailState extends State<ComplainDetail> {
  Map _complains = {};

  Future<void> _fetchData() async {
    var res = await api.get_complain_details(widget.id);
    if (res['code_status'] == true) {
      setState(
        () {
          _complains['data'] = res['complain'];
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
        title: Text('Complain Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: _complains.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    child: Card(
                      child: ListTile(
                        title: Text("Customer Info"),
                        subtitle: Text('Name : ' +
                            _complains['data']['customer'] +
                            ' \nEmail : salmanzain7786@outlook.com \nPhone : 03222728142'),
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      child: ListTile(
                        title: Text("Subject"),
                        subtitle:
                            Text(_complains['data']['subject'].toString()),
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      child: ListTile(
                        title: Text("Message"),
                        subtitle:
                            Text(_complains['data']['message'].toString()),
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      child: ListTile(
                        title: Text("Periority"),
                        subtitle:
                            Text(_complains['data']['priority'].toString()),
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      child: ListTile(
                        title: Text("Status"),
                        subtitle: Text((_complains['data']['status'] == '0')
                            ? "Pending"
                            : "Resolved"),
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      child: ListTile(
                        title: Text("Remarks"),
                        subtitle: Text((_complains['data']['remarks'] != null)
                            ? _complains['data']['remarks'].toString()
                            : ""),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
