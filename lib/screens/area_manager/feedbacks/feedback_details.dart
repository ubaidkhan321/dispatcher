import 'package:flutter/material.dart';
import '../../../helpers/api.dart';

class FeedbackDetails extends StatefulWidget {
  final id;
  const FeedbackDetails({Key? key, required this.id}) : super(key: key);

  @override
  _FeedbackDetailsState createState() => _FeedbackDetailsState();
}

class _FeedbackDetailsState extends State<FeedbackDetails> {
  Map _feedback = {};
  Future<void> _fetchData() async {
    var res = await api.get_feedback_details(widget.id);
    if (res['code_status'] == true) {
      setState(
        () {
          _feedback = res['feedback'];
          print(res);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_feedback.isEmpty) {
      _fetchData();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Feedback Details'),
        centerTitle: true,
      ),
      body: _feedback.isEmpty
          //       "feedback": {
          //     "id": "2",
          //     "subject": "bJs",
          //     "customer_id": "3",
          //     "message": "nzns",
          //     "created_at": "2022-12-30 05:10:08",
          //     "created_by": "58",
          //     "status": "0",
          //     "customer": "Customer 1",
          //     "created_user": "Ismail Muhammad Iqbal"
          // }
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("subject No"),
                      subtitle: Text(_feedback['subject']),
                    ),
                  ),
                ),
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Customer"),
                      subtitle: Text(_feedback['customer']),
                    ),
                  ),
                ),
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Created By"),
                      subtitle: Text(_feedback['created_user']),
                    ),
                  ),
                ),
                Container(
                  child: Card(
                    child: ListTile(
                      title: Text("Message"),
                      subtitle: Text(_feedback['message']),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
