import 'package:flutter/material.dart';
import '../helpers/api.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RoutesSearch extends StatefulWidget {
  final TextEditingController routes_name_controller;
  final TextEditingController routes_id_controller;
  const RoutesSearch({
    Key? key,
    required this.routes_name_controller,
    required this.routes_id_controller,
  }) : super(key: key);

  @override
  _RoutesSearchState createState() => _RoutesSearchState();
}

class _RoutesSearchState extends State<RoutesSearch> {
  bool _saving = false;
  List _routes = [];
  List _routesCopy = [];

  TextEditingController _search_controller = new TextEditingController();
  Future<void> _fetchRoutes(String page, String limit, String text) async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_routes(page, limit, text);
    if (res['code_status'] == true) {
      setState(() {
        _saving = false;
      });
      setState(
        () {
          _routes = res['routes'];
          _routesCopy = res['routes'];
        },
      );
    }
  }

  reset() {
    setState(() {
      _routes = [];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchRoutes('1', '100', '');
  }

  @override
  Widget build(BuildContext context) {
    // if (_routes.isEmpty) {
    //   _fetchRoutes('1', '100', '');
    // }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // actions: [
        //   InkWell(
        //     onTap: () => {
        //       if (_search_controller.text.isEmpty)
        //         {reset()}
        //       else
        //         {_fetchRoutes('1', '100', _search_controller.text)}
        //     },
        //     child: Icon(Icons.search),
        //   ),
        // ],
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
                    if (_search_controller.text.isNotEmpty) {
                      List tempSearch = _routesCopy
                          .where((element) => element['name']
                              .toLowerCase()
                              .contains(_search_controller.text.toLowerCase()))
                          .toList();

                      _routes = tempSearch;
                    }
                    // else {
                    //   _routes = _routesCopy;
                    // }
                  })
                  // setModalState(() {
                  //     search = value
                  // });
                },
              ),
            ),
            _routes.length == 0
                ? Center(
                    child: Text(
                      'No Route Found',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _routes.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return InkWell(
                          onTap: () {
                            if (_routes[index]['name'] != null) {
                              setState(() {
                                widget.routes_name_controller.text =
                                    _routes[index]['name'];
                                widget.routes_id_controller.text =
                                    _routes[index]['id'].toString();
                              });
                            }
                            Navigator.pop(context);
                          },
                          child: Card(
                            child: ListTile(
                              leading: Icon(Icons.inventory_2),
                              title: Text(_routes[index]['name']),
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
