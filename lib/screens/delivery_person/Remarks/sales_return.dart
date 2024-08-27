import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:linear/helpers/api.dart';
import 'package:linear/screens/delivery_person/dp_dashboard.dart';

class SalesReturn extends StatefulWidget {
  var sale_id;
  var orders;
  SalesReturn({
    Key? key,
    required this.orders,
    required this.sale_id,
  }) : super(key: key);

  @override
  _SalesReturnState createState() => _SalesReturnState();
}

class _SalesReturnState extends State<SalesReturn> {
  late List<TextEditingController> _quantityControllers;
  late List<TextEditingController> _reasonControllers;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _quantityControllers = List.generate(
        widget.orders['items'].length, (index) => TextEditingController());
    _reasonControllers = List.generate(
        widget.orders['items'].length, (index) => TextEditingController());
  }

  Future<void> _salesReturn(item_id, qty, reason, sale_id) async {
    var res = await api.sales_Return(item_id, qty, reason, sale_id);
    print('Update Status $res');
    if (res['code_status'] == true) {
      show_msg('success', res['message'], context);
    } else {
      show_msg('error', res['message'], context);
    }
  }

  @override
  void dispose() {
    for (var controller in _quantityControllers) {
      controller.dispose();
    }
    for (var controller in _reasonControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<DataRow> _createRows(List<dynamic> items) {
    return List<DataRow>.generate(
      items.length,
      (index) {
        var item = items[index];
        return DataRow(
          onSelectChanged: (value) {
            print('Id ${item['id']}');
          },
          cells: [
            DataCell(Text(item['product_name'].toString())),
            DataCell(Text(item['mrp'].toString())),
            DataCell(Text(item['product_barcode'].toString())),
            DataCell(Text(item['quantity'].toString())),
            DataCell(
              FormField(
                builder: (field) {
                  return TextField(
                    controller: _quantityControllers[index],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Qty',
                      errorText: field.errorText,
                    ),
                    onChanged: (value) {
                      field.didChange(value);
                    },
                  );
                },
                validator: (value) {
                  if (_quantityControllers[index].text.isEmpty) {
                    return 'Quantity is required';
                  }
                  if (int.tryParse(_quantityControllers[index].text) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
            ),
            DataCell(
              FormField(
                builder: (field) {
                  return TextField(
                    controller: _reasonControllers[index],
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Reason',
                      errorText: field.errorText,
                    ),
                    onChanged: (value) {
                      field.didChange(value);
                    },
                  );
                },
                validator: (value) {
                  if (_reasonControllers[index].text.isEmpty) {
                    return 'Reason is required';
                  }
                  return null;
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Sale ID ${widget.sale_id}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Return'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Sales Return',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => Colors.green),
                  showCheckboxColumn: false,
                  headingTextStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                  border: TableBorder(
                      bottom: BorderSide(width: 2),
                      horizontalInside: BorderSide()),
                  columns: const [
                    DataColumn(
                      label: Center(
                          child: Text(
                        'Product Name',
                        textAlign: TextAlign.center,
                      )),
                    ),
                    DataColumn(
                      label: Center(
                          child: Text(
                        'MRP',
                        textAlign: TextAlign.center,
                      )),
                    ),
                    DataColumn(
                      label: Center(
                          child: Text(
                        'Product Barcode',
                        textAlign: TextAlign.center,
                      )),
                    ),
                    DataColumn(
                      label: Center(
                          child: Text(
                        'Quantity',
                        textAlign: TextAlign.center,
                      )),
                    ),
                    DataColumn(
                      label: Center(
                          child: Text(
                        'Return Qty',
                        textAlign: TextAlign.center,
                      )),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Reason',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  rows: _createRows(widget.orders['items']),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var quantities = _quantityControllers
                        .map((controller) => controller.text)
                        .toList();
                    var reasons = _reasonControllers
                        .map((controller) => controller.text)
                        .toList();
                    var itemIds = widget.orders['items']
                        .map<String>((item) => item['item_id'].toString())
                        .toList();
                    //
                    print('Sale ID ${widget.sale_id}');
                    _salesReturn(itemIds, quantities, reasons, widget.sale_id);
                    //
                    print('Quantities: $quantities');
                    print('Reasons: $reasons');
                    print('Item IDs: $itemIds');
                  }
                },
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
