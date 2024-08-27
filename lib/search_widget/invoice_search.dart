import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../helpers/api.dart';
import '../helpers/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class InvoiceSearch extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController id;
  const InvoiceSearch({Key? key, required this.controller, required this.id})
      : super(key: key);

  @override
  _InvoiceSearchState createState() => _InvoiceSearchState();
}

class _InvoiceSearchState extends State<InvoiceSearch> {
  @override
  List _invoice = [];
  bool _saving = false;
  TextEditingController _search_controller = new TextEditingController();

  Future<void> _fetchCustomer(Text) async {
    EasyLoading.show(status: 'loading...');
    var res = await api.get_due_invoice('418');
    if (res['code_status'] == true) {
      EasyLoading.dismiss();
      setState(
        () {
          _invoice = res['invoices'];
        },
      );
    }
    // print(res);
  }

  Widget build(BuildContext context) {
    return Container();
  }
}
