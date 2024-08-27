import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:linear/helpers/api.dart';
import 'package:linear/order_place_products.dart';

class OrderPlacedWajih extends StatefulWidget {
  final String user_id;
  const OrderPlacedWajih({Key? key, required this.user_id}) : super(key: key);

  @override
  _OrderPlacedWajihState createState() => _OrderPlacedWajihState();
}

class _OrderPlacedWajihState extends State<OrderPlacedWajih> {
  List Stock = [];
  Future fetchtraking() async {
    setState(() {});
    var res = await api.Order_tracking_data();

    if (res['code_status'] == true) {
      // print('Stock Data $res');
      // res['stocks'] = Stock;
      Stock = res['nested_json'];
      print(Stock[0]['reference_no']);
      setState(() {});
    } else {
      print('asdsadasdas');
      print('Error Data $res');
      setState(() {});
    }
    // print(res);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchtraking();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Order Placed'),
      ),
      body: Stock.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              itemCount: Stock.length,
              itemBuilder: ((context, index) {
                var dateTimeString = Stock[index]['created_at'];
                DateTime dateTime = DateTime.parse(dateTimeString);
                // Format the date
                String formattedDate = DateFormat.yMd()
                    .format(dateTime); // Change the format as needed

                // Format the time with AM/PM
                String formattedTime =
                    DateFormat.jm().format(dateTime); // AM/PM format

                return Center(
                  child: InkWell(
                    onTap: () {
                      //
                      var productss = Stock[index]['products'];
                      print(productss.length);
                      print('Products $productss');
                      //

                      // // //
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => OrderPlaceProducts(
                                    products: productss,
                                  ))));
                      // // //
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            // color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: C,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Reference Number: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Date: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Time: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${Stock[index]['reference_no']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '$formattedDate',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '$formattedTime',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: 20,
              ),
            ),
    );
  }
}
