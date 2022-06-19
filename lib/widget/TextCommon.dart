import 'package:flutter/material.dart';


class TextCommon extends StatelessWidget {
  var title;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;

   TextCommon({required this.title, this.color,this.fontSize,this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      this.title,style: TextStyle(
        color: color?? Colors.black,
         fontSize: fontSize ?? 15,
          fontWeight: fontWeight ?? FontWeight.normal),
    );
  }
}
