import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:windspeedlogger/lineGraphs.dart';

import 'package:windspeedlogger/loggerData.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wind Speed Logger',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: 'Current Wind Speed'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<List<LoggerData>> fetchData() async {
  List<LoggerData> loggerData = [];
  var response = await http
      .get(Uri.parse('https://script.google.com/macros/s/AKfycbzC6CMtWP3T36gajLhTdOuEiFjJ5Q3SfVF_v1p7Py7FZMttpYGsQp7RExCZbQ9ULu-_7Q/exec'));
  print(response.statusCode);
  var jsonFeedback = convert.jsonDecode(response.body) as List;
  // jsonFeedback.forEach((data) => loggerData.add(LoggerData.fromSheets(data)));
  for (var i = 0; i < jsonFeedback.length - 1; i++) {
    loggerData.add(LoggerData.fromSheets(jsonFeedback[i]));
  }
  return loggerData;
}

final format = DateFormat('M/d/y HH:mm a');

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Wind Speed Logger Stats',
              style: Theme.of(context).textTheme.headline4,
            ),
            FutureBuilder<List<LoggerData>>(
              future: fetchData(), // async work
              builder: (BuildContext context, AsyncSnapshot<List<LoggerData>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading....');
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else {
                      List<FlSpot> speedData = [];
                      List<FlSpot> batteryData = [];
                      for (var i = 0; i < snapshot.data.length; i++) {
                        if (snapshot.data[i].timestamp != null) {
                          speedData.add(FlSpot(snapshot.data[i].timestamp as double, snapshot.data[i].windSpeed));
                          batteryData.add(FlSpot(snapshot.data[i].timestamp as double, snapshot.data[i].batteryVoltage));
                        }
                      }
                      return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Container(
                          height: 200,
                          width: 1600,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                            color: Color(0xff232d37),
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Column(children: [
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child:
                                          Text("Current Wind Speed", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                  CircularPercentIndicator(
                                    radius: 150.0,
                                    lineWidth: 25.0,
                                    percent: snapshot.data.first.windSpeed / 45,
                                    center: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("${snapshot.data.first.windSpeed} m/s",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: Colors.grey,
                                    maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                                    linearGradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0xff23b6e6), Color(0xff02d39a)],
                                    ),
                                  )
                                ])),
                            Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Column(children: [
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text("Current Battery Voltage",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                  CircularPercentIndicator(
                                    radius: 150.0,
                                    lineWidth: 25.0,
                                    percent: ((snapshot.data.first.batteryVoltage - 2.7) / (3.9 - 2.7) * 1),
                                    center: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("${snapshot.data.first.batteryVoltage}V",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        Text(
                                            "${double.parse((((snapshot.data.first.batteryVoltage - 2.7) / (3.9 - 2.7) * 100)).toStringAsFixed(2))}%",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: Colors.grey,
                                    maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                                    linearGradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0xff23b6e6), Color(0xff02d39a)],
                                    ),
                                  )
                                ])),
                          ]),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 480,
                                width: 800,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                                  color: Color(0xff232d37),
                                ),
                                child: LineChartGraph(
                                  spots: batteryData,
                                  metric: 'BATTERY VOLTAGE',
                                )),
                            Container(
                                height: 480,
                                width: 800,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                                  color: Color(0xff232d37),
                                ),
                                child: LineChartGraph(
                                  spots: speedData,
                                  metric: 'WIND SPEED',
                                )),
                          ],
                        )
                      ]);
                    }
                }
              },
            )
          ],
        ),
      ]),
    );
  }
}
