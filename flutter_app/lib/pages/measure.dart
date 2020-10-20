import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:myBCAA/BackgroundCollectedPage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:myBCAA/helpers/measure_card_widget.dart';

import '../SelectBondedDevicePage.dart';
import '../BackgroundCollectingTask.dart';
import '../BackgroundCollectedPage.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:myBCAA/helpers/myProvider.dart';
import 'package:provider/provider.dart';


const SpecialColor1 = const Color(0xFF2FAFB2);
const SpecialColor2 = const Color(0xFFD1BC64);
const SpecialColor3 = const Color(0xFFCF364A);

class Measure extends StatefulWidget {
  @override
  _Measure createState() => new _Measure();
}

class _Measure extends State<Measure> {
  BackgroundCollectingTask _collectingTask;
  List datalist;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyProvider>(
      create: (context) => MyProvider(),
      child: Consumer<MyProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'My Metabolites',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              centerTitle: true,
              backgroundColor: PrimaryColor,
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    provider.addDataToList();
                  },
                )
              ],
            ),
            //backgroundColor: PrimaryColor,
            body: ListView(
              // parent ListView
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Text(
                          'H',
                          style: TextStyle(color: Colors.white),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: PrimaryColor,
                        ),
                        height: 30,
                      ),
                      Container(
                        child: Text(
                          'D',
                          style: TextStyle(color: Colors.black),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue[100],
                        ),
                        height: 30,
                      ),
                      Container(
                        child: Text(
                          'W',
                          style: TextStyle(color: Colors.white),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: PrimaryColor,
                        ),
                        height: 30,
                      ),
                      Container(
                        child: Text(
                          'M',
                          style: TextStyle(color: Colors.white),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: PrimaryColor,
                        ),
                        height: 30,
                      ),
                      Container(
                        child: Text(
                          'Y',
                          style: TextStyle(color: Colors.white),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: PrimaryColor,
                        ),
                        height: 30,
                      ),
                    ],
                  ), //HDWMY
                ), // HDW
                if (provider.timeSeries != null) // MY
                  Container(
                    height: 300,
                    padding: EdgeInsets.all(5),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child:
                                  charts.TimeSeriesChart(provider.timeSeries),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: SpecialColor1,
                              radius: 5,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Tryptophan',
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: SpecialColor2,
                              radius: 5,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Tyrosine',
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: SpecialColor3,
                              radius: 5,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'BCAAs',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ), //LEGEND
                SizedBox(
                  height: 10,
                ), //GRAPH
                Container(
                  width: double.infinity,
                  color: PrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: FlatButton(
                            color: Colors.white,
                            splashColor: Colors.blueAccent,
                            child: ((_collectingTask != null)
                                ? const Text('Device Connected')
                                : const Text('Connect to Device')),
                            onPressed: () async {
                              final BluetoothDevice selectedDevice =
                                  await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SelectBondedDevicePage(
                                        checkAvailability: false);
                                  },
                                ),
                              );

                              if (selectedDevice != null) {
                                await _startBackgroundTask(
                                    context, selectedDevice);
                                setState(() {
                                  /* Update for `_collectingTask.inProgress` */
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: FlatButton(
                            color: Colors.white,
                            textColor: Colors.black,
                            disabledColor: Colors.grey[300],
                            disabledTextColor: Colors.grey,
                            child: const Text('Add Sensor Data'),
                            onPressed: (_collectingTask != null)
                                ? () async {
                                    var result =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ScopedModel<
                                              BackgroundCollectingTask>(
                                            model: _collectingTask,
                                            child: BackgroundCollectedPage(),
                                          );
                                        },
                                      ),
                                    );
                                    //Scaffold.of(context).showSnackBar(SnackBar(content: Text("You selected $result")));
                                      provider.list.add(result);
                                      provider.notifyListeners();
                                      provider.buildGraphData();

                                    ;
                                  }
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ), //CONNECT TO DEVICE + VIEW DATA
                ), //settings
                Container(
                  width: double.infinity,
                  color: PrimaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CustomCard(
                        text1: 'Tryptophan',
                        number1: provider.list.last.value1,
                        color1: SpecialColor1,
                      ),
                      CustomCard(
                        text1: 'Typrosine',
                        number1: provider.list.last.value2,
                        color1: SpecialColor2,
                      ),
                      CustomCard(
                        text1: 'BCAAs',
                        number1: 0,
                        color1: SpecialColor3,
                      ),
                    ],
                  ),
                ), //data cards
                Container(
                  width: double.infinity,
                  color: PrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child: ListTile(
                    title: FlatButton(
                      onPressed: () {
                        provider.buildGraphData();
                      },
                      child: Text('Show Data'),
                      color: Colors.white,
                    ),
                  ),
                ),

                Container(
                  height: 200,
                  child: ListView(
                      children: provider.list
                          .map((data) => data.getView(onClick: () async {
                                DateTime dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2011),
                                    lastDate: DateTime(2021));
                                if (dateTime == null) return;
                                provider.setDateOnData(data, dateTime);
                              }))
                          .toList()),
                ), //manual inp
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _startBackgroundTask(
    BuildContext context,
    BluetoothDevice server,
  ) async {
    try {
      _collectingTask = await BackgroundCollectingTask.connect(server);
      await _collectingTask.start();
    } catch (ex) {
      if (_collectingTask != null) {
        _collectingTask.cancel();
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error occured while connecting'),
            content: Text("Try Again"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

//class Metabolites {
//  DateTime dateTime;
//  int value;
//
//  Metabolites(this.dateTime, this.value);
//}
