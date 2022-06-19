
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CustomeToast{
 static void showToast(String value){
    Fluttertoast.showToast(
        msg: value.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }
}

