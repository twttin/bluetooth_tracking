import 'myData.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MyProvider extends ChangeNotifier{
  List<MyData> list = [
    new MyData(dateTime: DateTime(2020, 9, 6, ), value1: 1.2, value2: 2.4),
    new MyData(dateTime: DateTime(2020, 9, 17), value1: 1.4, value2: 2.5)
  ];
  var timeSeries;

  Future addDataToList()async{
    this.list.add(
        MyData(
            dateTime: DateTime.now(),
            value1: 0.0,
            value2: 0.0,
        )
    );
    this.notifyListeners();
  }

  Future setDateOnData(MyData data, DateTime dateTime) async{
    int index = this.list.indexOf(data);
    this.list[index].dateTime = dateTime;
    this.notifyListeners();
  }

  Future buildGraphData()async {
   // if(this.list.isEmpty)
     // return;
    this.timeSeries = [
      charts.Series<MyData,DateTime>(
          id: 'timeSeriesChart',
          colorFn: (_, __) => charts.Color.fromHex(code: '#D1BC64'),
          domainFn: (MyData data, _) => data.dateTime,
          measureFn: (MyData data, _) => data.value2,
          data: list,
      ) ,
      charts.Series<MyData,DateTime>(
        id: 'timeSeriesChart',
        colorFn: (_, __) => charts.Color.fromHex(code: '#2FAFB2'),
        domainFn: (MyData data, _) => data.dateTime,
        measureFn: (MyData data, _) => data.value1,
        data: list,
      )
    ];
    this.notifyListeners();
  }

}
