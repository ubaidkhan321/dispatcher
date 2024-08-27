import 'package:flutter/material.dart';
import 'route_map.dart';
import 'routes_list.dart';

import '../../widgets/drawer_navigate.dart';

class Routes extends StatefulWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  int _selectedIndex = 0;
  int _locationStatus = 1;
  final List _widgetOptions = [
    RouteMap(),
    RoutesList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      print(_widgetOptions[0]);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      appBar: AppBar(
        title: Text('Routes'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  style: style,
                  onPressed: () {
                    setState(() {
                      if (_locationStatus == 1) {
                        _locationStatus = 0;
                      } else {
                        _locationStatus = 1;
                      }
                    });
                  },
                  child: _locationStatus == 1
                      ? Text('Start Location')
                      : Text('Stop Location'),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              _widgetOptions.elementAt(_selectedIndex)
            ],
          ),
          // child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      drawer: DrawerNavigate(
        dashboardss: './dashboard',
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Map View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'List',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
