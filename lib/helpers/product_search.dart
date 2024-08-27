import 'package:flutter/material.dart';

class ProductSearch extends SearchDelegate {
  final List arr;
  final TextEditingController controller;

  var product_id = '';
  var product_name = '';
  var product_barcode = '';
  var product_quantity = '';
  Map pr_de = {
    "product_id": '',
    "product_name": '',
    "product_barcode": '',
    "product_quantity": '',
  };
  ProductSearch(
      {required this.arr, required this.controller, required this.pr_de});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          print(arr);
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List matchQuery = [];
    for (var fruit in arr) {
      print(fruit['name']);
      if (fruit['name']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase())) {
        // print(fruit['name']);
        matchQuery.add(fruit['product_name']);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () => {
            print('Tapped')
            // category_controller.text = 'asdas';
            // _category_controller.text = _arr[index]['name'].toString();
            // _fetchsubCategory(_arr[index]['id']);
          },
          child: ListTile(
            title: Text(result),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List matchQuery = [];
    for (var fruit in arr) {
      if (fruit['product_name']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase())) {
        // print(fruit['name']);
        matchQuery.add(fruit);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        // print(result);
        return InkWell(
          onTap: () => {
            print('Tapped'),
            controller.text = result['product_name'],
            // setState(() {
            pr_de['product_id'] = result['product_id'],
            pr_de['product_name'] = result['product_name'],
            pr_de['product_barcode'] = result['product_barcode'],
            pr_de['product_quantity'] = '0',
            // });
            Navigator.pop(context), Navigator.pop(context),
            // _category_controller.text = _arr[index]['name'].toString();
            // callback(result['id'])
          },
          child: ListTile(
            leading: Icon(Icons.inventory_2),
            title: Text(result['product_name']),
          ),
        );
      },
    );
  }
  // first overwrite to
}
