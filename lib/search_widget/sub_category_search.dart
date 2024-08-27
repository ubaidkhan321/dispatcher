import 'package:flutter/material.dart';
import '../helpers/api.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SubCategorySearch extends StatefulWidget {
  final String category_id;
  final TextEditingController sub_category_name_controller;
  final TextEditingController sub_catgeory_id_controller;
  const SubCategorySearch({
    Key? key,
    required this.sub_category_name_controller,
    required this.sub_catgeory_id_controller,
    required this.category_id,
  }) : super(key: key);

  @override
  _SubCategorySearchState createState() => _SubCategorySearchState();
}

class _SubCategorySearchState extends State<SubCategorySearch> {
  List _categories = [];
  bool _saving = false;
  TextEditingController _search_controller = new TextEditingController();

  Future<void> _fetchsubCategory(text) async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_catgories('', '', text, widget.category_id);
    if (res['code_status'] == true) {
      setState(
        () {
          setState(() {
            _saving = false;
          });
          _categories = res['categories'];
        },
      );
    }
    print(_categories);
  }

  reset() {
    setState(() {
      _categories = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      _fetchsubCategory('');
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
                {_fetchsubCategory(_search_controller.text)}
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
                itemCount: _categories.length,
                itemBuilder: (BuildContext ctx, index) {
                  return InkWell(
                    onTap: () {
                      if (_categories[index]['name'] != null) {
                        setState(() {
                          widget.sub_category_name_controller.text =
                              _categories[index]['name'];
                          widget.sub_catgeory_id_controller.text =
                              _categories[index]['id'].toString();
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.inventory_2),
                        title: Text(_categories[index]['name']),
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
