import 'package:flutter/material.dart';

class MyData{
  DateTime dateTime;
  double value1;
  double value2;
  MyData({this.dateTime, this.value1, this.value2});

  TextEditingController controller1 = TextEditingController(text: 'stored data');
  TextEditingController controller2 = TextEditingController(text: 'stored data');

  Widget getView({VoidCallback onClick}) {
    return Card(
      margin: EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: FlatButton(
              onPressed: (){
                onClick();
              },
              child: Text(
                  '${dateTime.day}/${dateTime.month}/${dateTime.year}'
              ),
            ),
          ),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: controller1,
              onChanged: (value1){
                this.value1 = double.parse(value1);
              },
              decoration: InputDecoration(
                  labelText: 'Tryptophan'
              ),
            ),
          ),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: controller2,
              onChanged: (value2) {
                this.value2 = double.parse(value2);
              },
              decoration: InputDecoration(
                labelText: 'Tyrosine'
              ),
            ),
          )
        ],
      ),
    );
  }
}