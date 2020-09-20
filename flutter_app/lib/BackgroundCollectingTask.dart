import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';
import './PeakDetection.dart';

class DataSample {
  double dpv1;
  double dpv2;
  double sub1;
  double sub2;
  double pot1;
  DateTime timestamp;
  double dpvbase1;
  double dpvbase2;
  double voltage;

  DataSample({
    this.dpv1,
    this.dpv2,
    this.sub1,
    this.sub2,
    this.dpvbase1,
    this.dpvbase2,
    this.pot1,
    this.timestamp,
    this.voltage,
  });
}

class BackgroundCollectingTask extends Model {
  static BackgroundCollectingTask of(
    BuildContext context, {
    bool rebuildOnChange = false,
  }) =>
      ScopedModel.of<BackgroundCollectingTask>(
        context,
        rebuildOnChange: rebuildOnChange,
      );

  final BluetoothConnection _connection;
  List<int> _buffer = List<int>();

  // @TODO , Such sample collection in real code should be delegated
  // (via `Stream<DataSample>` preferably) and then saved for later
  // displaying on chart (or even stright prepare for displaying).
  // @TODO ? should be shrinked at some point, endless colleting data would cause memory shortage.
  List<DataSample> samples = List<DataSample>();

  bool inProgress;
  bool measurementComplete;
  bool firstPoint;
  double dpv1Ep;
  double dpv1Ip;
  double dpv2Ep;
  double dpv2Ip;
  double vstart = 0.4;
  double vend = 1.0;

  BackgroundCollectingTask._fromConnection(this._connection) {
    _connection.input.listen((data) {
      _buffer += data;
      int done = data.indexOf(0XFF);

      if (firstPoint) {
        samples.clear();
        firstPoint = false;
      }
      while (inProgress) {
        // If there is a sample, and it is full sent
        int index = _buffer.indexOf('t'.codeUnitAt(0));

        if (index >= 0 && _buffer.length - index >= 7) {
          final DataSample sample = DataSample(
              dpv1: (_buffer[index + 1] + _buffer[index + 2] / 100),
              dpv2: (_buffer[index + 3] + _buffer[index + 4] / 100),
              pot1: (_buffer[index + 5] + _buffer[index + 6] / 100),

              dpvbase1: (_buffer[index + 1] + _buffer[index + 2] / 100),
              dpvbase2: (_buffer[index + 3] + _buffer[index + 4] / 100),
              sub1: (_buffer[index + 1] + _buffer[index + 2] / 100),
              sub2: (_buffer[index + 3] + _buffer[index + 4] / 100),              
              voltage: 0,
              timestamp: DateTime.now());          

          _buffer.removeRange(0, index + 7);

          samples.add(sample);
          notifyListeners(); // Note: It shouldn't be invoked very often - in this example data comes at every second, but if there would be more data, it should update (including repaint of graphs) in some fixed interval instead of after every sample.
          //print("${sample.timestamp.toString()} -> ${sample.dpv1} / ${sample.dpv2}");          
        } else if (done > 0) {
          analyze();
          measurementComplete = true;
          inProgress = false;
          print("measurement completed");
          done = -1;
          notifyListeners();
          updateWatch();
        }
        // Otherwise break
        else {
          break;
        }
      }
    }).onDone(() {
      inProgress = false;
      notifyListeners();
    });
  }

  static Future<BackgroundCollectingTask> connect(
      BluetoothDevice server) async {
    final BluetoothConnection connection =
        await BluetoothConnection.toAddress(server.address);
    return BackgroundCollectingTask._fromConnection(connection);
  }

  void dispose() {
    _connection.dispose();
  }

  Future<void> start() async {
    inProgress = true;
    firstPoint = true;
    measurementComplete = false;

    _buffer.clear();
    samples.clear();
    final DataSample samp = DataSample(
      dpv1: (0),
      dpv2: (0),
      sub1: (0),
      sub2: (0),
      dpvbase1: (0),
      dpvbase2: (0),
      pot1: (0),
      timestamp: DateTime.now(),
    );
    samples.add(samp);
    notifyListeners();


    _connection.output.add(ascii.encode('s'));
    await _connection.output.allSent;
    _connection.output.add(ascii.encode('t'));
    await _connection.output.allSent;
    _connection.output.add(ascii.encode('a'));
    await _connection.output.allSent;
    _connection.output.add(ascii.encode('r'));
    await _connection.output.allSent;
    _connection.output.add(ascii.encode('t'));
    await _connection.output.allSent;                


    _connection.output.add(ascii.encode('!'));
    await _connection.output.allSent;
 
    _connection.output.add(ascii.encode('8'));
    await _connection.output.allSent;
  }

  Future<void> cancel() async {
    inProgress = false;
    notifyListeners();
   // _connection.output.add(ascii.encode('stop'));
   // await _connection.finish();
  }

  Future<void> pause() async {
    inProgress = false;
    notifyListeners();
    //_connection.output.add(ascii.encode('stop'));
    //await _connection.output.allSent;
  }

  Future<void> reasume() async {
    measurementComplete = false;
    firstPoint = true;
    inProgress = true;
    _buffer.clear();
    samples.clear();
    final DataSample samp = DataSample(
      dpv1: (0),
      dpv2: (0),
      sub1: (0),
      sub2: (0),
      dpvbase1: (0),
      dpvbase2: (0),      
      pot1: (0),
      timestamp: DateTime.now(),
    );

    samples.add(samp);

    notifyListeners();


  //  _connection.output.add(ascii.encode('!'));
  //  await _connection.output.allSent;    
    _connection.output.add(ascii.encode('8'));
    await _connection.output.allSent;
  }

Future<void> updateWatch() async {


    _connection.output.add(ascii.encode('9'));
    await _connection.output.allSent;
    _connection.output.add(ascii.encode('2'));
    await _connection.output.allSent;
    _connection.output.add(ascii.encode('1'));
    await _connection.output.allSent;
    _connection.output.add(ascii.encode('\r'));
    await _connection.output.allSent;
    _connection.output.add(ascii.encode('2'));
    await _connection.output.allSent;
    _connection.output.add(ascii.encode('7'));
    await _connection.output.allSent;     
    _connection.output.add(ascii.encode('\r'));
    await _connection.output.allSent;      
    _connection.output.add(ascii.encode('0'));
    await _connection.output.allSent;     
    _connection.output.add(ascii.encode('0'));
    await _connection.output.allSent;      
    _connection.output.add(ascii.encode('\r'));
    await _connection.output.allSent;      
    _connection.output.add(ascii.encode('2'));
    await _connection.output.allSent;     
    _connection.output.add(ascii.encode('9'));
    await _connection.output.allSent;      
    _connection.output.add(ascii.encode('\r'));
    await _connection.output.allSent;                            
  }


  Future<void> analyze() async {
    var dpv1data = new List<double>();
    var dpv2data = new List<double>();
    for (int j = 0; j < samples.length; j++) {
      dpv1data.add(samples[j].dpv1);
      dpv2data.add(samples[j].dpv2);
    }

    List<double> peak1;
    List<double> peak2;
    List<double> baseline1;
    List<double> baseline2;
    List<double> sub1;
    List<double> sub2; 
    List<double> smooth1;
    List<double> smooth2;       
    peak1 = voltammogrampeaks(dpv1data, 0);
    peak2 = voltammogrampeaks(dpv2data, 0);

    baseline1 = voltammogrampeaks(dpv1data, 1);
    baseline2 = voltammogrampeaks(dpv2data, 1);

    sub1 = voltammogrampeaks(dpv1data, 2);
    sub2 = voltammogrampeaks(dpv2data, 2);
    
    smooth1 = voltammogrampeaks(dpv1data, 3);
    smooth2 = voltammogrampeaks(dpv2data, 3);

    dpv1Ep = peak1[0];
    dpv1Ip = peak1[1];
    dpv2Ep = peak2[0];
    dpv2Ip = peak2[1];

    print(peak1);
    print(peak2);
    
    
    //add baseline current
    _buffer.clear();
    samples.clear();

    for (int i = 0; i < dpv1data.length; i++) {
      final DataSample samp = DataSample(
        dpv1: (smooth1[i]),
        dpv2: (smooth2[i]),
        sub1: (sub1[i]),
        sub2: (sub2[i]),
        pot1: (0),
        dpvbase1: (baseline1[i]),
        dpvbase2: (baseline2[i]),
        timestamp: DateTime.now(),
        voltage: vstart + i * (vend-vstart)/dpv1data.length,
      );

      samples.add(samp);
    }

    //send data to smartwatch
    /*  _connection.output.add(ascii.encode('!'));
    await _connection.output.allSent;
    _connection.output.add(ascii.encode('8'));
    await _connection.output.allSent;*/
  }

  Iterable<DataSample> getLastOf(Duration duration) {
    DateTime startingTime = DateTime.now().subtract(duration);
    int i = samples.length;
    do {
      i -= 1;
      if (i <= 0) {
        break;
      }
    } while (samples[i].timestamp.isAfter(startingTime));
    return samples.getRange(i, samples.length);
  }
}
