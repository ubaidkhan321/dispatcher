import 'package:flutter/material.dart';
import '../../../helpers/api.dart';
import 'servey_details.dart';

class ServeyList extends StatefulWidget {
  const ServeyList({Key? key}) : super(key: key);

  @override
  _ServeyListState createState() => _ServeyListState();
}

// get_servey_list
class _ServeyListState extends State<ServeyList> {
  List _servey = [];
  Future<void> _fetchData() async {
    var res = await api.get_servey_list('96');
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
        title: Text('Servey'),
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
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServeyDetails(
                                date: _servey[index]['date'].toString(),
                                customer_id:
                                    _servey[index]['customer_id'].toString()),
                          ));
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.inventory_2),
                        title: Text(_servey[index]['date'].toString()),
                        subtitle:
                            Text(_servey[index]["customer_name"].toString()),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
