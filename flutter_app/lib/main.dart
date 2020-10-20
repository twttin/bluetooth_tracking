import 'package:flutter/material.dart';

import 'pages/MainPage.dart';
import 'package:myBCAA/pages/Loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myBCAA/pages/StoredData.dart';

const PrimaryColor = const Color(0xFF288EC7);

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => MainPage(),
      },
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
