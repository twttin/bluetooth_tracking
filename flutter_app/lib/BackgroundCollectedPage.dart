import 'package:flutter/material.dart';
import 'package:myBCAA/helpers/measuring_raw_data.dart';
import 'package:myBCAA/helpers/myData.dart';

import './BackgroundCollectingTask.dart';
import './helpers/Line_Chart.dart';
import './helpers/PaintStyle.dart';

const PrimaryColor = const Color(0xFF288EC7);
const SpecialColor1 = const Color(0xFF2FAFB2);
const SpecialColor2 = const Color(0xFFD1BC64);
const SpecialColor3 = const Color(0xFFCF364A);

class BackgroundCollectedPage extends StatelessWidget {
  bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    final BackgroundCollectingTask task =
        BackgroundCollectingTask.of(context, rebuildOnChange: true);

    // Arguments shift is needed for timestamps as miliseconds in double could loose precision.
    final int argumentsShift =
        task.samples.first.timestamp.millisecondsSinceEpoch;

    final Duration showDuration =
        Duration(hours: 2); // @TODO . show duration should be configurable
    final Iterable<DataSample> lastSamples = task.getLastOf(showDuration);

    final Iterable<double> arguments = lastSamples.map((sample) {
      return (sample.timestamp.millisecondsSinceEpoch - argumentsShift)
          .toDouble();
    });

    final Iterable<double> argument1 = lastSamples.map((sample) {
      return (sample.voltage).toDouble();
    });

    // Step for argument labels
    final Duration argumentsStep =
        Duration(minutes: 15); // @TODO . step duration should be configurable

    // Find first timestamp floored to step before
    final DateTime beginningArguments = lastSamples.first.timestamp;
    DateTime beginningArgumentsStep = DateTime(beginningArguments.year,
        beginningArguments.month, beginningArguments.day);
    while (beginningArgumentsStep.isBefore(beginningArguments)) {
      beginningArgumentsStep = beginningArgumentsStep.add(argumentsStep);
    }
    beginningArgumentsStep = beginningArgumentsStep.subtract(argumentsStep);
    final DateTime endingArguments = lastSamples.last.timestamp;

    // Generate list of timestamps of labels
    final Iterable<DateTime> argumentsLabelsTimestamps = () sync* {
      DateTime timestamp = beginningArgumentsStep;
      yield timestamp;
      while (timestamp.isBefore(endingArguments)) {
        timestamp = timestamp.add(argumentsStep);
        yield timestamp;
      }
    }();

    // Map strings for labels
    final Iterable<LabelEntry> argumentsLabels =
        argumentsLabelsTimestamps.map((timestamp) {
      return LabelEntry(
          (timestamp.millisecondsSinceEpoch - argumentsShift).toDouble(),
          ((timestamp.hour <= 9 ? '0' : '') +
              timestamp.hour.toString() +
              ':' +
              (timestamp.minute <= 9 ? '0' : '') +
              timestamp.minute.toString()));
    });


    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Collected data',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          backgroundColor: PrimaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: <Widget>[
            // Progress circle
            (task.inProgress
                ? FittedBox(
                    child: Container(
                        margin: new EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white))))
                : Container(/* Dummy */)),
            // Start/stop buttons
            (task.inProgress
                ? IconButton(icon: Icon(Icons.pause), onPressed: task.pause)
                : IconButton(
                    icon: Icon(Icons.play_arrow), onPressed: task.reasume)),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(5,5,5,0),
              child: Card(
                child: (task.measurementComplete
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Center(
                              child: const Text(
                                'Raw Voltammogram',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: Text("Current (µA)", textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 10
                                  ))),
                          Line_Chart(
                            constraints: const BoxConstraints.expand(height: 200),
                            arguments: argument1,
                            argumentsLabels: argumentsLabels,
                            values: [
                              lastSamples.map((sample) => sample.dpv1),
                              lastSamples.map((sample) => sample.dpv2),
                              lastSamples.map((sample) => sample.dpvbase1),
                              lastSamples.map((sample) => sample.dpvbase2),
                            ],
                            verticalLinesStyle:
                                const PaintStyle(color: Colors.grey),
                            additionalMinimalHorizontalLabelsInterval: 0,
                            additionalMinimalVerticalLablesInterval: 0,
                            seriesPointsStyles: [
                              null,
                              null,
                              //const PaintStyle(style: PaintingStyle.stroke, strokeWidth: 1.7*3, color: Colors.indigo, strokeCap: StrokeCap.round),
                            ],
                            seriesLinesStyles: [
                              const PaintStyle(
                                  style: PaintingStyle.stroke,
                                  strokeWidth: 1.5,
                                  color: SpecialColor1),
                              const PaintStyle(
                                  style: PaintingStyle.stroke,
                                  strokeWidth: 1.5,
                                  color: SpecialColor2),
                              const PaintStyle(
                                  style: PaintingStyle.stroke,
                                  strokeWidth: 0.5,
                                  color: SpecialColor1),
                              const PaintStyle(
                                  style: PaintingStyle.stroke,
                                  strokeWidth: 0.5,
                                  color: SpecialColor2),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Center(
                              child: const Text(
                                'Raw Voltammogram',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: Text("Current (µA)", textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 10
                                  ))),
                          Line_Chart(
                            constraints: const BoxConstraints.expand(height: 200),
                            arguments: arguments,
                            argumentsLabels: argumentsLabels,
                            values: [
                              lastSamples.map((sample) => sample.dpv1),
                              lastSamples.map((sample) => sample.dpv2),
                              lastSamples.map((sample) => sample.dpvbase1),
                              lastSamples.map((sample) => sample.dpvbase2),
                              lastSamples.map((sample) => sample.sub1),
                              lastSamples.map((sample) => sample.sub2),
                            ],
                            verticalLinesStyle:
                                const PaintStyle(color: Colors.grey),
                            additionalMinimalHorizontalLabelsInterval: 0,
                            additionalMinimalVerticalLablesInterval: 0,
                            seriesPointsStyles: [
                              null,
                              null,
                              //const PaintStyle(style: PaintingStyle.stroke, strokeWidth: 1.7*3, color: Colors.indigo, strokeCap: StrokeCap.round),
                            ],
                            seriesLinesStyles: [
                              const PaintStyle(
                                  style: PaintingStyle.stroke,
                                  strokeWidth: 1.2,
                                  color: SpecialColor1),
                              const PaintStyle(
                                  style: PaintingStyle.stroke,
                                  strokeWidth: 1.2,
                                  color: SpecialColor2),
                              const PaintStyle(
                                  style: PaintingStyle.stroke,
                                  strokeWidth: 0.3,
                                  color: SpecialColor1),
                              const PaintStyle(
                                  style: PaintingStyle.stroke,
                                  strokeWidth: 0.3,
                                  color: SpecialColor2),
                              const PaintStyle(
                                  style: PaintingStyle.stroke,
                                  strokeWidth: 0.3,
                                  color: SpecialColor1),
                              const PaintStyle(
                                  style: PaintingStyle.stroke,
                                  strokeWidth: 0.3,
                                  color: SpecialColor2),
                            ],
                          ),
                        ],
                      )),
              ),
            ),
//            AspectRatio(
//              aspectRatio: 1.23,
//              child: Container(
//                decoration: BoxDecoration(
//                  borderRadius: const BorderRadius.all(Radius.circular(18)),
//                ),
//                child: Stack(
//                  children: <Widget>[
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: <Widget>[
//                        const SizedBox(
//                          height: 10,
//                        ),
//                        const SizedBox(
//                          height: 4,
//                        ),
//                        const Text(
//                          'Amino Acid Measurements',
//                          style: TextStyle(
//                              color: Colors.black,
//                              fontSize: 14,
//                              fontWeight: FontWeight.w500,
//                              letterSpacing: 1),
//                          textAlign: TextAlign.center,
//                        ),
//                        const SizedBox(
//                          height: 20,
//                        ),
//                        Expanded(
//                          child: Padding(
//                            padding:
//                                const EdgeInsets.only(right: 16.0, left: 6.0),
////                            child: LineChart(sampleData1()),
//                          ),
//                        ),
//                        const SizedBox(
//                          height: 10,
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//            ),
            Container(
              padding: EdgeInsets.fromLTRB(5,0,5,0),
              child: Card(
                child: (task.measurementComplete
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Center(
                              child: const Text(
                                'Corrected Voltammogram',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: Text("Current (µA)", textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 10
                                  ))),
                          Line_Chart(
                            constraints: const BoxConstraints.expand(height: 200),
                            arguments: argument1,
                            argumentsLabels: argumentsLabels,
                            values: [
                              lastSamples.map((sample) => sample.sub1),
                              lastSamples.map((sample) => sample.sub2),
                            ],
                            verticalLinesStyle:
                                const PaintStyle(color: Colors.grey),
                            additionalMinimalHorizontalLabelsInterval: 0,
                            additionalMinimalVerticalLablesInterval: 0,
                            seriesPointsStyles: [
                              null,
                              null,
                              //const PaintStyle(style: PaintingStyle.stroke, strokeWidth: 1.7*3, color: Colors.indigo, strokeCap: StrokeCap.round),
                            ],
                            seriesLinesStyles: [
                              const PaintStyle(
                                  style: PaintingStyle.stroke,
                                  strokeWidth: 1.2,
                                  color: SpecialColor1),
                              const PaintStyle(
                                  style: PaintingStyle.stroke,
                                  strokeWidth: 1.2,
                                  color: SpecialColor2),
                            ],
                          ),
                        ],
                      )
                    : Container()),
              ),
            ),
//            (task.measurementComplete
//                ? Container(
//                    height: 300,
//                    padding: EdgeInsets.all(5),
//                    child: Card(
//                      child: Padding(
//                        padding: const EdgeInsets.all(1.0),
//                        child: Column(
//                          children: <Widget>[
//                            Expanded(
//                              child: charts.Series(
//                                id: 'tbd',
//                                colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//                                domainFn: lastSamples.map((sample) => sample.timestamp),
//                                measureFn: lastSamples.map((sample) => sample.sub1),
//                                data: lastSamples,
//                              ),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  )
//                : Container()),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
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
                  Row(
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
                  )
                ],
              ),
            ), //Legend
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: PrimaryColor),
              child: (task.measurementComplete
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RawData(
                                text1: "Ep",
                                number1: double.parse(
                                    task.dpv1Ep.toStringAsFixed(3)),
                                color1: SpecialColor1,
                                unit: "V",
                              ),
                              RawData(
                                text1: "Ip",
                                number1: double.parse(
                                    task.dpv1Ip.toStringAsFixed(3)),
                                color1: SpecialColor1,
                                unit: "uA",
                              ),
                              RawData(
                                text1: "Ep",
                                number1: double.parse(
                                    task.dpv2Ep.toStringAsFixed(3)),
                                color1: SpecialColor2,
                                unit: "V",
                              ),
                              RawData(
                                text1: "Ip",
                                number1: double.parse(
                                    task.dpv2Ip.toStringAsFixed(3)),
                                color1: SpecialColor2,
                                unit: "uA",
                              )
//                      Container(
//                        decoration: BoxDecoration(
//                            borderRadius: BorderRadius.all(Radius.circular(5)),
//                            border: Border.all(
//                                width: 2,
//                                color: SpecialColor2,
//                                style: BorderStyle.solid)),
//                        child: Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Column(
//                            children: <Widget>[
//                              Row(
//                                children: <Widget>[
//                                  SizedBox(width: 5),
//                                  Text(
//                                    'Tyrosine',
//                                  ),
//                                ],
//                              ),
//                              SizedBox(height: 10),
//                              Text(
//                                'Ip: ${task.dpv1Ip.toStringAsFixed(3)} uA',
//                                style: TextStyle(fontWeight: FontWeight.w900),
//                              ),
//                              Text(
//                                'Ip: ${task.dpv2Ip.toStringAsFixed(3)} uA',
//                                style: TextStyle(fontWeight: FontWeight.w900),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: PrimaryColor),
                          child: ListTile(
                            title: FlatButton(
                              color: Colors.white,
                              child: Text("Add Data"),
                              onPressed: () {
                                Navigator.of(context).pop(MyData(
                                    dateTime: DateTime.now(),
                                    value1: double.parse(
                                        task.dpv1Ip.toStringAsFixed(3)),
                                    value2: double.parse(
                                        task.dpv2Ip.toStringAsFixed(3))));
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(/*dummy*/)),
            ),

            /*  ListTile(
              leading: const Icon(Icons.filter_vintage),
              title: const Text('Water pH level'),
            ),
            Line_Chart(
              constraints: const BoxConstraints.expand(height: 200),
              arguments: arguments,
              argumentsLabels: argumentsLabels,
              values: [
                lastSamples.map((sample) => sample.pot1),
              ],
              verticalLinesStyle: const PaintStyle(color: Colors.grey),
              additionalMinimalHorizontalLabelsInterval: 0,
              additionalMinimalVerticalLablesInterval: 0,
              seriesPointsStyles: [
                null,
              ],
              seriesLinesStyles: [
                const PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 1.2,
                    color: Colors.redAccent),
              ],
            ),*/
          ],
        ));
  }
}
