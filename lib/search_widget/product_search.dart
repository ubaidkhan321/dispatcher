import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:linear/PdfData/utils/flush.dart';
import '../helpers/api.dart';
import '../screens/order_booker/photo_preview.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductSearch extends StatefulWidget {
  final String category_id;
  final String sub_category_id;
  final TextEditingController product_controller;
  final TextEditingController product_id_controller;
  final TextEditingController product_barcode_controller;
  final TextEditingController product_rate_controller; //Mrp
  final TextEditingController supplier_id_controller;
  final TextEditingController selling_price_controller;

  const ProductSearch({
    Key? key,
    required this.selling_price_controller,
    required this.product_controller,
    required this.product_id_controller,
    required this.product_barcode_controller,
    required this.category_id,
    required this.sub_category_id,
    required this.product_rate_controller,
    required this.supplier_id_controller,
  }) : super(key: key);

  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  List _products = [];
  List<dynamic> _foundUsers = [];
  @override
  initState() {
    // at the beginning, all users are shown
    _foundUsers = _products;
    super.initState();
    setState(() {});
  }

  // void _runfiler(String enteredkeyboard) {
  //   List<dynamic> results = [];

  //   if (enteredkeyboard.isEmpty) {
  //     // if the search field is empty or only contains white-space, we'll display all users
  //     results = _products;
  //   } else {
  //     results = _products
  //         .where((user) => user["product_name"]
  //             .toLowerCase()
  //             .contains(enteredkeyboard.toLowerCase()))
  //         .toList();
  //   }
  //   //Refresh the UI
  //   setState(() {
  //     _foundUsers = results;
  //     print('Data $results');
  //   });
  // }

  bool _saving = false;
  String base_url = 'https://rhotrack.rholabproducts.com/';
  String? stockquantity;
  String? price_items;
  String? mrpss;

  TextEditingController _search_controller = new TextEditingController();
  Future<void> _fetchproduct(text) async {
    setState(() {
      _saving = true;
    });
    var res = await api.get_products('', '100', text, widget.category_id,
        widget.sub_category_id, '', '', widget.supplier_id_controller.text);
    if (res['code_status'] == true) {
      setState(
        () {
          setState(() {
            _saving = false;
          });
          _products = res['products'];
          print('PRODUCT DATA $_products');
        },
      );
    }
  }

  reset() {
    setState(() {
      _products = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_products.isEmpty) {
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
                    // _runfiler(value);
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
                itemCount: _products.length,
                itemBuilder: (BuildContext ctx, index) {
                  stockquantity = _products[index]['quantity'];
                  // price_items = _products[index]['selling_price'];
                  price_items = _products[index]['product_mrp'];
                  String sellingPriceString = _products[index]['selling_price'];
                  double sellingPrice = double.parse(sellingPriceString);

// Round off the double value to the nearest integer
                  int roundedSellingPrice = sellingPrice.round();
                  // Convert double to integer to remove decimal points
                  int sellingPriceWithoutDecimal = sellingPrice.toInt();
                  mrpss = _products[index]['product_mrp'].toString();
                  // Remove decimal in mrp
                  // double convert_double_mrpss = double.parse(mrpss!);
                  // NumberFormat formatter_price_mrpss =
                  //     NumberFormat.decimalPattern();
                  // String formatted_price_mrpss =
                  //     formatter_price_mrpss.format(convert_double_mrpss);
                  //
                  // print('MRP Price without Decimal $formatted_price_mrpss');
                  // //
                  // print('Prce Quantity bro $price_items');
                  // Remove decimal in selling price
                  double convert_double_stock = double.parse(stockquantity!);
                  NumberFormat formatter_stock = NumberFormat.decimalPattern();
                  String formatted_stock_data =
                      formatter_stock.format(convert_double_stock);
                  // print('Stock without decimal $formatted_stock_data');
                  // print('Stock Data with decimal $stockquantity');
                  //
                  double convert_double_price = double.parse(price_items!);
                  NumberFormat formatter_price = NumberFormat.decimalPattern();
                  String formatted_price_data =
                      formatter_price.format(convert_double_price);

                  // Selling Price

                  // print('Price without decimal $formatted_price_data');
                  // print('Price Data with decimal $price_items');
                  //
                  return InkWell(
                    onTap: () {
                      if (_products[index]['product_name'] != null) {
                        setState(() {
                          if (_products[index]['quantity'] == "0.0000") {
                            // print(
                            //     'stock quantity ${_products[index]['quantity']}');
                            // print(_products[index]['quantity']);
                            // print(_products[index]['product_name']);
                            // print('Price ${_products[index]['selling_price']}');
                            // print('stock quantity is zero not added');
                            //
                            flushs.flushbarmessagered(
                                'Product Out of Stock', context);
                            //
                          } else {
                            print(_products[index]['product_name']);
                            print('stock quantity $stockquantity');
                            // print('Price ${_products[index]['selling_price']}');
                            print('Price ${_products[index]['product_mrp']}');

                            widget.product_controller.text =
                                _products[index]['product_name'];
                            widget.product_id_controller.text =
                                _products[index]['product_id'].toString();
                            widget.product_barcode_controller.text =
                                _products[index]['product_barcode'].toString();
                            widget.product_rate_controller.text = mrpss!;
                            // widget.selling_price_controller.text =
                            //     _products[index]['selling_price'].toString();
                            widget.selling_price_controller.text =
                                _products[index]['product_mrp'].toString();
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                    child: Card(
                      child: ListTile(
                        // leading: InkWell(
                        //   child: Image.network(base_url +
                        //       'assets/images/' +
                        //       _products[index]['product_image'].toString()),
                        //   onTap: () => {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => PhotoPreview(
                        //             url: base_url +
                        //                 'assets/images/' +
                        //                 _products[index]['product_image']
                        //                     .toString()),
                        //       ),
                        //     )
                        //   },
                        // ),
                        leading: InkWell(
                          child: Image(
                              image: AssetImage('assets/images/no_image.png')),
                          // onTap: () {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => PhotoPreview(
                          //               url: AssetImage(
                          //                   'assets/images/no_image.png'))));
                          // },
                        ),
                        title: Text(_products[index]['product_name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Stock Quantity: ${formatted_stock_data}'),
                            Text('MRP: ${formatted_price_data.toString()}'),
                            Text(
                                'Selling Price: ${roundedSellingPrice.toString()}'),
                          ],
                        ),
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
