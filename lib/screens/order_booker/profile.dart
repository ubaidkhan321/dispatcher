import 'package:flutter/material.dart';

import '../../widgets/drawer_navigate.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              color: Color(0xffA30444),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: Container(
                        child: Center(
                          child: Text(
                            'Salman Zain \nsalmanzain786@outlook.com',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 150,
                      child: Image.asset(
                        "images/profile.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text("First Name"),
                  subtitle: Text('Salman'),
                ),
              ),
            ),
            Container(
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text("Last Name"),
                  subtitle: Text('Zain'),
                ),
              ),
            ),
            Container(
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text("Company"),
                  subtitle: Text('Rholab'),
                ),
              ),
            ),
            Container(
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text("Phone"),
                  subtitle: Text('03423544669'),
                ),
              ),
            ),
            Container(
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text("Email"),
                  subtitle: Text('salmanzain786@outlook.com'),
                ),
              ),
            ),
            Container(
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text("Address"),
                  subtitle: Text('Karachi Pakistan'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
