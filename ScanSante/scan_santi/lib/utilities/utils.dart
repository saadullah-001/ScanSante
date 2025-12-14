import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scan_santi/models/food_analysis_model.dart';

class Utils {
  static void toast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static MaterialColor color(FoodAnalysisModel model) {
    if (model.healthScore >= 70) {
      return Colors.green;
    } else if (model.healthScore >= 40 && model.healthScore < 70) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }
}
