// import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

class UpdateQtyModal extends StatefulWidget {
  final TextEditingController controller;
  final single_product;
  const UpdateQtyModal(
      {Key? key, required this.single_product, required this.controller})
      : super(key: key);

  @override
  _UpdateQtyModalState createState() => _UpdateQtyModalState();
}

class _UpdateQtyModalState extends State<UpdateQtyModal> {
  TextEditingController qty_controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text('Update Quanttity'),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: qty_controller,
              decoration: InputDecoration(
                labelText: "Update Quantity",
                border: OutlineInputBorder(), //label text of field
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  print(widget.single_product);
                  widget.single_product['qty'] = qty_controller.text;
                });
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
