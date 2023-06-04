// localpage.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:alarm_example/main.dart';
import 'package:alarm_example/models/weather.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:alarm_example/screens/home.dart';
import 'package:alarm_example/models/translator.dart';

class LocalPage extends StatefulWidget {
  const LocalPage({super.key});

  @override
  _localPageState createState() => _localPageState();
}

List<double> StrtoDouble(List<Weather> list) {
  List<double> temp = new List.empty(growable: true);

  for (int i = 0; i < list.length; i++)
    temp.add(double.parse(currentLocation.tempList[i].fcstValue));

  return temp;
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}

List<ChartData> getChartData(List<Weather> list) {
  List<ChartData> temp = new List.empty(growable: true);

  for (int i = 0; i < list.length; i++) {
    ChartData data = new ChartData(
        int.parse(list[i].fcsttime), double.parse(list[i].fcstValue));
    temp.add(data);
  }

  return temp;
}

class _localPageState extends State<LocalPage> {
  List<ChartData> temp = getChartData(currentLocation.tempList);
  List<ChartData> pop = getChartData(currentLocation.popList);
  List<ChartData> reh = getChartData(currentLocation.rehList);

  // draw a graph
  Widget drawGraph(String title, List<ChartData> dataList) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Text(title),
            Container(
              child: SfCartesianChart(
                primaryYAxis: NumericAxis(
                  isVisible: false
                ),
                series: <ChartSeries>[
                  LineSeries<ChartData, int>(
                      dataSource: dataList,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y, 
                      markerSettings: MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle 
                      ), 
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true, 
                        labelPosition: ChartDataLabelPosition.inside, 
                      )
                    )
                ],
              ),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    String path = 'assets/image/loading2.png';

    // Widget myNavigationbar = Container(
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: [
    //       IconButton(
    //         onPressed: () => {
    //           // to main page
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(builder: (context) => const MyHomePage()),
    //           )
    //         },
    //         icon: Icon(Icons.home),
    //         iconSize: 30,
    //       ),
    //       IconButton(
    //         onPressed: () => {
    //           // to timeline page
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(builder: (context) => const LocalPage()),
    //           )
    //         },
    //         icon: Icon(Icons.timeline),
    //         iconSize: 30,
    //       ),
    //       IconButton(
    //         onPressed: () => {
    //           // to location page
    //         },
    //         icon: Icon(Icons.location_city),
    //         iconSize: 30,
    //       ),
    //       IconButton(
    //         onPressed: () => {
    //           // to alarm page
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => ExampleAlarmHomeScreen()),
    //             //MaterialPageRoute(builder: (context) => AlarmInfo()),
    //           )
    //         },
    //         icon: Icon(Icons.alarm),
    //         iconSize: 30,
    //       )
    //     ],
    //   ),
    // );

    

    return Scaffold(
      appBar: AppBar(
        // 뒤로가기 지우기
        // automaticallyImplyLeading: false,
        // backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${currentLocation.address}",style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold 
                    ),),
            //Container(height: 20,),
            drawGraph("온도", temp),
            // drawGraph("비 올 확률", pop),
            // drawGraph("습도", reh)
          ],
        ),
      ),
      //bottomNavigationBar: myNavigationbar,
    );
  }
}