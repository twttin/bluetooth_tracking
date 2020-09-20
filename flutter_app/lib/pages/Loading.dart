import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myBCAA/pages/MainPage.dart';

const PrimaryColor = const Color(0xFF288EC7);

const spinkit = SpinKitCircle(
  color: Colors.white,
  size: 50.0,
);

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.pushReplacementNamed( context, "/home"
        ));
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: PrimaryColor,
        body: Center(
          child: spinkit,
        ),
      ),
    );
  }
}
