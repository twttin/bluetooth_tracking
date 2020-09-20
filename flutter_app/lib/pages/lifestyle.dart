import 'package:flutter/material.dart';

const PrimaryColor = const Color(0xFF288EC7);

class LifeStyle extends StatefulWidget {
  @override
  _LifeStyleState createState() => _LifeStyleState();
}

class _LifeStyleState extends State<LifeStyle> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text(
          'My LifeStyle',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: PrimaryColor,
      ),
    );
  }
}
