import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class OrderPlaceProducts extends StatefulWidget {
  var products;
  OrderPlaceProducts({Key? key, required this.products}) : super(key: key);

  @override
  _OrderPlaceProductsState createState() => _OrderPlaceProductsState();
}

class _OrderPlaceProductsState extends State<OrderPlaceProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Products'),
        ),
        body: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10),
          physics: BouncingScrollPhysics(),
          itemCount: widget.products.length,
          itemBuilder: ((context, index) {
            String productMRPString = widget.products[index]['product_mrp'];

// Parse the string into a double
            double productMRP = double.parse(productMRPString);

// Create a NumberFormat instance with compact format
            NumberFormat numberFormat = NumberFormat.compact();

// Format the product_mrp without decimal points
            String formattedMRP = numberFormat.format(productMRP);

// Use formattedMRP wherever you need in your Flutter application
            print('Formatted MRP: $formattedMRP');

            return Card(
              elevation: 3,
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                leading: Image(
                    // height: 80,
                    image: AssetImage('assets/images/no_image.png')),
                title: Text('${widget.products[index]['product_name']}'),
                subtitle:
                    Text('Quantity: ${widget.products[index]['product_qty']}'),
                trailing: Text('MRP: ${formattedMRP}'),
              ),
            );
          }),
        ));
  }
}
