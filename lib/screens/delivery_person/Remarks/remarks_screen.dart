import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:linear/helpers/api.dart';
import 'package:linear/screens/delivery_person/dp_dashboard.dart';

class RemarksScreen extends StatefulWidget {
  var sale_id;
  RemarksScreen({
    Key? key,
    required this.sale_id,
  }) : super(key: key);

  @override
  _RemarksScreenState createState() => _RemarksScreenState();
}

class _RemarksScreenState extends State<RemarksScreen> {
  final TextEditingController remarksController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  Future<void> RemarksData(
    sale_id,
    remarks,
  ) async {
    var res = await api.updateRemarks(sale_id, remarks);
    print('Update Status $res');
    if (res['code_status'] == true) {
      show_msg('success', res['message'], context);
    } else {
      show_msg('error', res['message'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remarks'),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: 'Enter Remarks'),
                controller: remarksController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Remarks cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process the form data
                    RemarksData(widget.sale_id, remarksController.text);
                    print('Remarks: ${remarksController.text}');
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
