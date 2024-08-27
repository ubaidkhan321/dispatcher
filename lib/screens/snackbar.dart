import 'package:flutter/material.dart';

GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
double? totalheight;

void showInSnackBar(String value, {Color? color, VoidCallback? ontap}) {
  final SnackBar snackBar = SnackBar(
    content: Text(
      value,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    backgroundColor: color ?? Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    action: SnackBarAction(
      label: 'Ok',
      onPressed: ontap ?? () {},
    ),
    // margin: EdgeInsets.only(bottom: totalheight! - 85, right: 20, left: 20),
  );

  snackbarKey.currentState?.showSnackBar(snackBar);
}
