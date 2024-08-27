import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../helpers/api.dart';
import '../helpers/location.dart';
import '../screens/order_booker/customer_visit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SupplierSearch extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController id;
  const SupplierSearch({Key? key, required this.controller, required this.id})
      : super(key: key);

  @override
  _SupplierSearchState createState() => _SupplierSearchState();
}

class _SupplierSearchState extends State<SupplierSearch> {
  List _supplier = [];
  bool _saving = false;
  TextEditingController _search_controller = new TextEditingController();
  Future<void> _fetchSupplier(text) async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_supplier('', '', text);
    if (res['code_status'] == true) {
      setState(() {
        _saving = false;
      });
      setState(
        () {
          _supplier = res['suppliers'];
        },
      );
    }
  }

  reset() {
    setState(() {
      _supplier = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_supplier.isEmpty) {
      _fetchSupplier('');
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
              if (_search_controller.text.isEmpty)
                {reset()}
              else
                {_fetchSupplier(_search_controller.text)}
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.search),
            ),
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
                controller: _search_controller,
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
                itemCount: _supplier.length,
                itemBuilder: (BuildContext ctx, index) {
                  return InkWell(
                    onTap: () => {
                      if (_supplier[index]['name'] != null)
                        {
                          widget.controller.text = _supplier[index]['name'],
                          widget.id.text = _supplier[index]['id'].toString(),
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
                        title: Text(_supplier[index]['name']),
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
