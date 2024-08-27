import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Interview extends StatefulWidget {
  const Interview({Key? key}) : super(key: key);

  @override
  _InterviewState createState() => _InterviewState();
}

class _InterviewState extends State<Interview> {
  TextEditingController controller = TextEditingController();
  List<String> names = [];

  onSave() async {
    names.add(controller.text);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList("names", names);
  }

  @override
  // void initState() async {
  //   // SharedPreferences pref = await SharedPreferences.getInstance();
  //   // names = await pref.getStringList("names") ?? [];
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter your Name"),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  onSave();
                });
              },
              child: Text("Save")),
          SizedBox(
            height: 200,
            child: ListView.builder(
                itemCount: names.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Text(names[index]);
                }),
          )
        ],
      ),
    );
  }
}
