import 'package:flutter/material.dart';
import '../../../helpers/api.dart';

class StockDetails extends StatefulWidget {
  final id;
  const StockDetails({Key? key, required this.id}) : super(key: key);

  @override
  _StockDetailsState createState() => _StockDetailsState();
}

class _StockDetailsState extends State<StockDetails> {
  Map stock = {};
  List _items = [];
  Future<void> _fetchData() async {
    var res = await api.get_stock_details(widget.id);
    if (res['code_status'] == true) {
      setState(
        () {
          stock = res['stock_info'];
          _items = res['items'];
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Stock Info $stock');
    if (stock.isEmpty) {
      _fetchData();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Stock Details'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
              // onSelected: handleClick,
              itemBuilder: (BuildContext context) {
            return {'Add New Order', 'Edit Order'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          }, onSelected: (String value) {
            if (value == 'Add New Order') {
              Navigator.pushNamed(context, '/select_order_product');
            }
          }),
        ],
      ),
      body: stock.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Customer Info"),
                      subtitle: Text('Name : ' + stock['customer']),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return InkWell(
                          onTap: () {},
                          child: Card(
                            child: ListTile(
                              leading: Icon(Icons.inventory_2),
                              title: Text(_items[index]['product_name']),
                              subtitle: Text(_items[index]["mrp"]),
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Total"),
                      subtitle:
                          Text('Total Items : ' + _items.length.toString()),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
