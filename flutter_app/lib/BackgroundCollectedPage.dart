import 'package:flutter/material.dart';
import 'package:myBCAA/helpers/MeasurementsChart.dart';
import 'package:fl_chart/fl_chart.dart';

import './BackgroundCollectingTask.dart';
import './helpers/Line_Chart.dart';
import './helpers/PaintStyle.dart';

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
          title: Text('Collected data'),
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
            Divider(),
            ListTile(
              title: Center(child: const Text('Amino Acid Measurements')),
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
                ],
              ),
            ),
            (task.measurementComplete
                ? Line_Chart(
                    constraints: const BoxConstraints.expand(height: 200),
                    arguments: argument1,
                    argumentsLabels: argumentsLabels,
                    values: [
                      lastSamples.map((sample) => sample.dpv1),
                      lastSamples.map((sample) => sample.dpv2),
                      lastSamples.map((sample) => sample.dpvbase1),
                      lastSamples.map((sample) => sample.dpvbase2),
                    ],
                    verticalLinesStyle: const PaintStyle(color: Colors.grey),
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
                  )
                : Line_Chart(
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
                    verticalLinesStyle: const PaintStyle(color: Colors.grey),
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
                  )),
            Divider(),
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
//            Divider(),
            (task.measurementComplete
                ? Line_Chart(
                    constraints: const BoxConstraints.expand(height: 200),
                    arguments: argument1,
                    argumentsLabels: argumentsLabels,
                    values: [
                      lastSamples.map((sample) => sample.sub1),
                      lastSamples.map((sample) => sample.sub2),
                    ],
                    verticalLinesStyle: const PaintStyle(color: Colors.grey),
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
                  )
                : Container(/* Dummy */)),
            Divider(),
            (task.measurementComplete
                ? Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          //  vertical: 10.0,
                          //  horizontal: 5,
                          ),
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                      child: Text(
                        'Tryptophan: \n Ep: ${task.dpv1Ep.toStringAsFixed(3)} V \n Ip: ${task.dpv1Ip.toStringAsFixed(3)} uA  \n Tyrosine: \n Ep: ${task.dpv2Ep.toStringAsFixed(3)} V \n Ip: ${task.dpv2Ip.toStringAsFixed(3)} uA',
                        style: Theme.of(context).textTheme.body2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(/* Dummy */)),

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
