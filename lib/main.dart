// troubleshooting: 안쓰는거 import 시 에러 발생
// import 'dart:convert';
// import 'dart:io';
// import 'dart:html';
// import 'package:flutter_application_1/models/convertion.dart';
import 'dart:io';

import 'package:alarm_example/models/clothes.dart';
import 'package:alarm_example/models/location.dart';
import 'package:alarm_example/models/translator.dart';
// import 'package:flutter_application_1/models/weather.dart';
import 'package:alarm_example/models/weatherAPI.dart';
import 'package:geolocator/geolocator.dart';
// // import 'package:http/http.dart';
// import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:alarm_example/screens/home.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/services.dart';
import 'package:alarm_example/screens/localpage.dart';
import 'package:alarm_example/screens/home.dart';
import 'package:alarm_example/screens/info_alarm.dart';


// global variables
Location currentLocation = new Location("default");

String today = DateFormat("yyyyMMdd").format(DateTime.now());
String start = DateFormat("HHmm").format(DateTime.now());
Clothes clothes = new Clothes(-273);

 Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Alarm.init(showDebugLogs: true);
  
  print("app startd: $today at $start");

  // _getUserLocation();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather2Wear - main',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyLocationState();
}

Future<void> _getUserLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();

  permission = await Geolocator.requestPermission();
  
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  // print(position);
  
  // print(position);
  currentLocation.setPosition(position);
  currentLocation.getLocationAddr();

  // call weatherAPI
  weatherAPI wapi = weatherAPI(today, position);
  wapi.init(currentLocation);


}

class _MyLocationState extends State<MyHomePage> {
  String txt = "";
  String txt2 = "";

  Duration time = Duration(seconds: 13);
  
  Clothes clothes = new Clothes(-273);

  @override
  void initState() {
    // TODO: implement initState
    txt = "현 위치";
    txt2 = "모름";

    super.initState();

  }

  Future<void> _setCurrentAddress() async {
    void printAddress() {
      setState(() {

        currentLocation.getTempList();
        currentLocation.getPopList();
        currentLocation.getRehList();
        currentLocation.getSkyList();
        currentLocation.getTmn();
        currentLocation.getTmx(); 

        txt = currentLocation.address;
        txt2 = currentLocation.weatherNowList[0];

        print(txt);
        print(txt2);
      });
    }

    _getUserLocation();

    // 현재: 10초 delay로 강제 해결
    Future.delayed(time, printAddress);
  }

  @override
  Widget build(BuildContext context) {
    // 현위치 Container
    Widget getLocationContainer = Container(
      child: Row(
        children: <Widget>[
          IconButton(onPressed:_setCurrentAddress, icon: Icon(Icons.my_location)), 
          Text(txt)
        ]
      ),
    ); 

    // widget - 날씨 아이콘
    Widget getWeatherIcon() {
      Icon icon = new Icon(
        Icons.error, 
        size: 100,
        );

      try {
        String sky =Translator(currentLocation.weatherNowList).isSunny(currentLocation.weatherNowList[3]);
        print(sky);
        switch(sky) {
          case "맑음":
            icon = new Icon(
              Icons.wb_sunny_outlined, 
              color: Colors.red,
              size: 100,
              );
            break;
          case "구름 많음":
            icon = new Icon(
              Icons.wb_cloudy_outlined, 
              color: Colors.grey[400],
              size: 100,
              );
            break;
          case "흐림":
            icon = new Icon(
              Icons.wb_cloudy_rounded, 
              color: Colors.grey[700],
              size: 100,
              );
            break;
        }
      } catch(exception) {
        print("error");
      }

      return icon;
    }

    // 현재 날씨 Container
    Widget getWeatherContainer = Container(
      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getWeatherIcon(),
              Column(
                children: [
                  Text(
            "현재 온도: $txt2"
          ), 
          Text(
            "최고 기온: ${currentLocation.tmx}", 
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          Text(
            "최저 기온: ${currentLocation.tmn}",
            style: TextStyle(
              color: Colors.lightBlueAccent,))  
                ],
              )
            ],
          ), 
          Text(
            "현재 온도: $txt2"
          ), 
          Text(
            "최고 기온: ${currentLocation.tmx}", 
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          Text(
            "최저 기온: ${currentLocation.tmn}",
            style: TextStyle(
              color: Colors.lightBlueAccent,
            ),
          ),
        ],
      ),
    );

    // 옷 추천 Container
    Widget getClothesContainer = Container(
      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("오늘의 추천: ${clothes.getClothes()}"),
          Image.asset(
            // 상대 경로로 접근 불가
            "assets/image/cloth_example.png", 
            fit: BoxFit.fill,
          ),
        ]
      ),
    );

    // 자체 navigation bar
    Widget myNavigationbar = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [ 
          IconButton(
            onPressed: () => {
              // to main page
              
            }, 
            icon: Icon(Icons.home), 
          ),
          IconButton(
            onPressed: () => {
              // to timeline page
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const LocalPage()),  
              )
            }, 
            icon: Icon(Icons.timeline), 
          ), 
          IconButton(
            onPressed: () => {
              // to location page

            }, 
            icon: Icon(Icons.location_city), 
          ), 
          IconButton(
            onPressed: () => {
              // to alarm page

            }, 
            icon: Icon(Icons.alarm), 
          )
        ],
      ),
    );


    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          getLocationContainer, 
          // 날씨
          getWeatherContainer,
          // 옷
          getClothesContainer  
        ]
      ),
      bottomNavigationBar: myNavigationbar,
    );
  }
}