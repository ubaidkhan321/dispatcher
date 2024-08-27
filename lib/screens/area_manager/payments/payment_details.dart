import 'package:flutter/material.dart';
import '../../../helpers/api.dart';

//
class PaymentDetails extends StatefulWidget {
  final id;
  const PaymentDetails({Key? key, required this.id}) : super(key: key);

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  Map _payment = {};
  Future<void> _fetchData() async {
    var res = await api.get_payment_details(widget.id);
    if (res['code_status'] == true) {
      setState(
        () {
          _payment = res['rows'];
          print(res);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_payment.isEmpty) {
      _fetchData();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Payment Details'),
        centerTitle: true,
      ),
      body: _payment.isEmpty
          //       "rows": {
          //     "id": "20",
          //     "sale_id": "2",
          //     "reference_no": "23000224-Short-Stock-CR",
          //     "paid_by": "cash",
          //     "cheque_no": "1213445",
          //     "amount": "1000.0000",
          //     "created_by": "Ismail Muhammad Iqbal",
          //     "attachment": "",
          //     "note": "Image Api Upload",
          //     "created_at": "2022-11-13 11:04:18",
          //     "status": "0",
          //     "customer_name": "JADE-E-SERVICES PAKISTAN (PVT) LTD (Consignment) (Daraz"
          // }
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Reference No"),
                      subtitle: Text(_payment['reference_no']),
                    ),
                  ),
                ),
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Paid By"),
                      subtitle: Text(_payment['paid_by']),
                    ),
                  ),
                ),
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Cheque No"),
                      subtitle: Text(_payment['cheque_no']),
                    ),
                  ),
                ),
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Amount"),
                      subtitle: Text(_payment['amount']),
                    ),
                  ),
                ),
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Create By"),
                      subtitle: Text(_payment['created_by']),
                    ),
                  ),
                ),
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Customer Name"),
                      subtitle: Text(_payment['customer_name']),
                    ),
                  ),
                ),
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Notes"),
                      subtitle: Text(_payment['note']),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
