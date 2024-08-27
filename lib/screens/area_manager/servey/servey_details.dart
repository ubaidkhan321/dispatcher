import 'package:flutter/material.dart';
import '../../../helpers/api.dart';

class ServeyDetails extends StatefulWidget {
  final date;
  final customer_id;
  const ServeyDetails({Key? key, required this.date, required this.customer_id})
      : super(key: key);

  @override
  _ServeyDetailsState createState() => _ServeyDetailsState();
}

class _ServeyDetailsState extends State<ServeyDetails> {
  var _servey = [];
  Future<void> _fetchData() async {
    var res = await api.servey_details(widget.customer_id, widget.date);
    if (res['code_status'] == true) {
      setState(
        () {
          _servey = res['atempts'];
          print(res);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_servey.isEmpty) {
      _fetchData();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Servey Details'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _servey.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _servey.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.inventory_2),
                      title: Text(_servey[index]['question'].toString()),
                      subtitle: Text(_servey[index]["answer"].toString()),
                    ),
                  );
                }),
      ),
    );
  }
}
