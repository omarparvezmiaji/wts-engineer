import 'package:flutter/material.dart';

typedef CallBack();

class TextButtonCommon extends StatelessWidget {
  String text;
  Color? backgroundColor, textColor;
  double? fontSize;
  FontWeight? fontWeight;
  CallBack callBack;

  TextButtonCommon(
      {required this.text,
      required this.callBack,
      this.backgroundColor,
      this.textColor,
      this.fontWeight,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 3),
          child: Text(
            this.text,
            style: TextStyle(
                fontSize: this.fontSize ?? 20,
                color: this.textColor ?? Colors.white,
                fontWeight: this.fontWeight ?? FontWeight.normal),
          ),
        ),
        style: ButtonStyle(

            backgroundColor:
                MaterialStateProperty.all(backgroundColor ?? Colors.green[600]),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.white)))),
        onPressed: callBack,
      ),
    );
  }
}
