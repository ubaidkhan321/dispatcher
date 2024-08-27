import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../helpers/api.dart';
import '../helpers/location.dart';
import '../screens/order_booker/customer_visit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class WerehouseSearch extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController id;
  const WerehouseSearch({Key? key, required this.controller, required this.id})
      : super(key: key);

  @override
  _WerehouseSearchState createState() => _WerehouseSearchState();
}

class _WerehouseSearchState extends State<WerehouseSearch> {
  var _werehouses = [];
  bool _saving = false;
  TextEditingController _werehouse_controller = new TextEditingController();
  @override
  Future<void> _fetchwerehouse() async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_werehouses();
    print(res);
    if (res['code_status'] == true) {
      setState(
        () {
          setState(() {
            _saving = false;
          });
          _werehouses = res['suppliers'];
        },
      );
    }
  }

  reset() {
    setState(() {
      _werehouses = [];
    });
  }

  Widget build(BuildContext context) {
    if (_werehouses.isEmpty) {
      _fetchwerehouse();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          InkWell(
            onTap: () => {
              if (_werehouse_controller.text.isEmpty)
                {reset()}
              else
                {_fetchwerehouse()}
            },
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _werehouse_controller,
                decoration: InputDecoration(
                  labelText: "Search Here",
                  border: OutlineInputBorder(), //label text of field
                ),
                onChanged: (value) => {
                  setState(() {
                    // search = value.toString();
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
                itemCount: _werehouses.length,
                itemBuilder: (BuildContext ctx, index) {
                  return InkWell(
                    onTap: () => {
                      if (_werehouses[index]['name'] != null)
                        {
                          widget.controller.text = _werehouses[index]['name'],
                          widget.id.text = _werehouses[index]['id'].toString(),
                          Navigator.pop(context)
                        }
                    },
                    // onTap: () async {
                    //   EasyLoading.show(status: 'loading...');
                    //   if (_supplier[index]['name'] != null) {
                    //     widget.controller.text = _supplier[index]['name'];
                    //     widget.id.text = _supplier[index]['id'].toString();
                    //     Navigator.pop(context);
                    //   }
                    //   }
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.inventory_2),
                        title: Text(_werehouses[index]['name']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
