import 'package:flutter/material.dart';
import '../../widgets/drawer_navigate.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../helpers/api.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Tracking extends StatefulWidget {
  const Tracking({Key? key}) : super(key: key);

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  bool _saving = false;
  List _tracking = [];
  Future<void> _fetchTracking() async {
    setState(() {
      _saving = true;
    });
    var res = await api.tracking_history('58');
    if (res['code_status'] == true) {
      setState(() {
        _saving = false;
      });
      setState(
        () {
          _tracking = res['tracking'];
        },
      );
    }
  }

  @override
  void initState() {
    _fetchTracking();
  }

  @override
  Widget build(BuildContext context) {
    final double nodePosition;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tracking'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 370,
            child: Column(
                children: List.generate(_tracking.length, (index) {
              // return Text('asd');
              String _punch_type = '';
              if (_tracking[index]['type'] == '1') {
                //normak
                _punch_type = 'Attadance Punch';
              } else if (_tracking[index]['type'] == '2') {
                //roytes
                _punch_type = 'Route Punch';
              } else {
                _punch_type = 'Shop Punch';
                // shio
              }
              return TimelineTile(
                isFirst: true,
                indicatorStyle: const IndicatorStyle(
                  width: 20,
                  color: Colors.blue,
                  indicatorXY: 0.2,
                ),
                endChild: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(_punch_type),
                          subtitle: Text('Date : ' +
                              _tracking[index]['created_at'].toString() +
                              ' \nTime : 5:24pm'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            })

                // TimelineTile(
                //   indicatorStyle: const IndicatorStyle(
                //     width: 20,
                //     color: Colors.blue,
                //     indicatorXY: 0.2,
                //   ),
                //   endChild: Container(
                //     padding: EdgeInsets.only(bottom: 20),
                //     child: Card(
                //       child: Column(
                //         children: [
                //           ListTile(
                //             title: Text("Shop No 1"),
                //             subtitle: Text('Date : 12-08-2022 \nTime : 5:24pm'),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // TimelineTile(
                //   indicatorStyle: const IndicatorStyle(
                //     width: 20,
                //     color: Colors.blue,
                //     indicatorXY: 0.2,
                //   ),
                //   endChild: Container(
                //     child: Card(
                //       child: Column(
                //         children: [
                //           ListTile(
                //             title: Text("Shop No 1"),
                //             subtitle: Text('Date : 12-08-2022 \nTime : 5:24pm'),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // )
                // ],
                ),
          ),
        ),
      ),
      drawer: DrawerNavigate(
        dashboardss: '/dashboard',
      ),
    );
  }
}
