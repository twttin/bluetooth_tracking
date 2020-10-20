import 'package:flutter/material.dart';
import 'package:myBCAA/pages/measure.dart';
import 'package:myBCAA/pages/settings.dart';
import 'package:myBCAA/pages/lifestyle.dart';
import 'package:myBCAA/pages/profile.dart';
import 'package:charts_flutter/flutter.dart';



//const PrimaryColor = const Color(0xFF288EC7);
//const SpecialColor1 = const Color(0xFF2FAFB2);
//const SpecialColor2 = const Color(0xFFD1BC64);
//const SpecialColor3 = const Color(0xFFCF364A);

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _currentIndex = 0;

  final List<Widget> _children = [
    Measure(),
    SettingPage(),
    LifeStyle(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: <Widget>[
          Measure(),
          SettingPage(),
          LifeStyle(),
          Profile(),
        ],
        index: _currentIndex,
      ),
      //body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
//        selectedItemColor: Color.white,
        type: BottomNavigationBarType.fixed,
        onTap: onTappedBar,
      ),
    );
  }

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }



}
