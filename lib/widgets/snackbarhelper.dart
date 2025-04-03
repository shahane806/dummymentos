import 'package:flutter/material.dart';

class Snackbarhelper {
  static void showsnackbar(
      BuildContext context, String content, Color color, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        content,
        style: TextStyle(fontSize: 15),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: duration),
    ));
  }
}