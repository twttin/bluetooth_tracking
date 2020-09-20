import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:myBCAA/main.dart';

class CustomCard extends StatelessWidget {
  final String text1;
  final int number1;
  final Color color1;

  CustomCard({this.text1, this.number1, this.color1});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Column(
        children: <Widget>[
          Text(
            text1,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                      width: 5, color: color1, style: BorderStyle.solid)),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                      "$number1",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                  Text(
                    'μm'
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}
