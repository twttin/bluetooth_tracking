import 'package:flutter/material.dart';

const PrimaryColor = const Color(0xFF288EC7);
const SpecialColor1 = const Color(0xFF2FAFB2);
const SpecialColor2 = const Color(0xFFD1BC64);
const SpecialColor3 = const Color(0xFFCF364A);

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Metabolites'),
        centerTitle: true,
        backgroundColor: PrimaryColor,
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: SpecialColor1,
              padding: EdgeInsets.all(30.0),
              child: Text('Tryptophan'),
            ),
          ),
          Expanded(
            child: Container(
              color: SpecialColor2,
              padding: EdgeInsets.all(30.0),
              child: Text('Tyrosine'),
            ),
          ),
          Expanded(
            child : Container(
              color: SpecialColor3,
              padding: EdgeInsets.all(30.0),
              child: Text('BCAAs'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            title: Text('Measure'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            title: Text('Insight'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            title: Text('Lifestyle'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text('Profile'),
          ),
        ],
        selectedItemColor: PrimaryColor,
        type: BottomNavigationBarType.fixed,

      ),
    );
  }
}
