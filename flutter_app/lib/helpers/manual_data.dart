import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myBCAA/helpers/myProvider.dart';

class manual_data extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyProvider>(
      create: (context) => MyProvider(),
      child: Consumer<MyProvider>(
        builder: (context,provider,child){
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Flutter charts demo'),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    provider.addDataToList();
                  },
                )
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: provider.list.map((data) =>
                        data.getView(
                            onClick: () async{
                              DateTime dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2011),
                                  lastDate: DateTime(2021)
                              );
                              if(dateTime==null)
                                return;
                              provider.setDateOnData(data,dateTime);
                            }
                        )
                    ).toList(),
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    provider.buildGraphData();
                  },
                  child: Text('Show Data'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}