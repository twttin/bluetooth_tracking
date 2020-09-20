import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:myBCAA/pages/StoredData.dart';
import 'package:myBCAA/helpers/measure_card_widget.dart';

import '../SelectBondedDevicePage.dart';
import '../BackgroundCollectingTask.dart';
import '../BackgroundCollectedPage.dart';

// import './helpers/Line_Chart.dart';

class Measure extends StatefulWidget {
  @override
  _Measure createState() => new _Measure();
}

class _Measure extends State<Measure> {
  BackgroundCollectingTask _collectingTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Metabolites',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: PrimaryColor,
      ),
      backgroundColor: PrimaryColor,
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
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
                  ),
                  LineChartSample1(),
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
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: FlatButton(
                        color: Colors.white,
                        textColor: Colors.black,
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
                        child: const Text('View Collected Data'),
                        onPressed: (_collectingTask != null)
                            ? () {
                                Navigator.of(context).push(
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
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomCard(
                    text1: 'Tryptophan',
                    number1: 31,
                    color1: SpecialColor1,
                  ),
                  CustomCard(
                    text1: 'Typrosine',
                    number1: 92,
                    color1: SpecialColor2,
                  ),
                  CustomCard(
                    text1: 'BCAAs',
                    number1: 0,
                    color1: SpecialColor3,
                  ),
                ],
              ),
            ),
          ],
        ),
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
            content: Text("${ex.toString()}"),
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
