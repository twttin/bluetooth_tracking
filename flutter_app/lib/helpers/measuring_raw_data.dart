import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:myBCAA/main.dart';

class RawData extends StatelessWidget {
  final String text1;
  final double number1;
  final Color color1;
  final String unit;

  RawData({this.text1, this.number1, this.color1, this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        children: <Widget>[
          Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                      width: 5, color: color1, style: BorderStyle.solid)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    text1,
                  ),
                  Text(
                    "$number1",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    '$unit',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
