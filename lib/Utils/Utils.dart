import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  toastMessage(String message, Color color, Color textColor) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: color,
        toastLength: Toast.LENGTH_LONG,
        textColor: textColor,
        gravity: ToastGravity.BOTTOM);
  }
}