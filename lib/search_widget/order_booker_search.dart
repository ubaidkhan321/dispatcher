import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../helpers/api.dart';

class OrderBookerSearch extends StatefulWidget {
  final String am_id;
  final TextEditingController name_controller;
  final TextEditingController id_controller;

  const OrderBookerSearch(
      {Key? key,
      required this.am_id,
      required this.name_controller,
      required this.id_controller})
      : super(key: key);

  @override
  _OrderBookerSearchState createState() => _OrderBookerSearchState();
}

class _OrderBookerSearchState extends State<OrderBookerSearch> {
  bool _saving = false;
  List _order_booker = [];
  Map _targets = {};
  TextEditingController _search_controller = new TextEditingController();
  Future<void> _fetchproduct(text) async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_order_booker(widget.am_id);
    if (res['code_status'] == true) {
      setState(
        () {
          setState(() {
            _saving = false;
          });
          _order_booker = res['order_bookers'];
        },
      );
    }
  }

  reset() {
    setState(() {
      _order_booker = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_order_booker.isEmpty) {
      _fetchproduct('');
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
                {_fetchproduct(_search_controller.text)}
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
                itemCount: _order_booker.length,
                itemBuilder: (BuildContext ctx, index) {
                  return InkWell(
                    onTap: () async {
                      if (_order_booker[index]['first_name'] != null) {
                        if (mounted) {
                          setState(() {
                            widget.name_controller.text =
                                _order_booker[index]['first_name'].toString();
                            widget.id_controller.text =
                                _order_booker[index]['id'].toString();
                          });
                        }
                      }
                      Navigator.pop(context);
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(_order_booker[index]['first_name']),
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
