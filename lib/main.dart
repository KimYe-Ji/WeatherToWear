// troubleshooting: 안쓰는거 import 시 에러 발생
// import 'dart:convert';
// import 'dart:io';
// import 'dart:html';
// import 'package:flutter_application_1/models/convertion.dart';
import 'package:alarm_example/models/location.dart';
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

// global variables
Location currentLocation = new Location("default");
String today = DateFormat("yyyyMMdd").format(DateTime.now());
String start = DateFormat("HHmm").format(DateTime.now());

 Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Alarm.init(showDebugLogs: true);
  
  print("app startd: $today at $start");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

void _getUserLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();

  permission = await Geolocator.requestPermission();
  
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  
  // print(position);
  currentLocation.setPosition(position);
  currentLocation.getLocationAddr();

  // call weatherAPI
  weatherAPI wapi = weatherAPI(today, position);
  wapi.init(currentLocation);

  // test 
  // sleep(const Duration(seconds:5));
}

class _MyLocationState extends State<MyHomePage> {
  String txt = "";
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    txt = "현 위치";
    super.initState();
  }

  Future<void> _setCurrentAddress() async {
    Duration time = Duration(seconds: 10);

    void printAddress() {
      setState(() {
        txt = currentLocation.address;
        print(txt);

        currentLocation.getTempList();
        currentLocation.getPopList();
        currentLocation.getRehList();
        currentLocation.getTmn();
        currentLocation.getTmx();
    });
    }

    _getUserLocation();

    // 현재: 10초 delay로 강제 해결
    Future.delayed(time, printAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget> [
          Row(
            children: <Widget>[
              IconButton(onPressed:_setCurrentAddress, icon: Icon(Icons.my_location)), 
              Text(txt)
            ],
          ), 
          // 날씨 / 옷
          ElevatedButton(onPressed:() {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const LocalPage()),  
            );
          }, 
          child: Text("LocalPage"),
          ),
        ]
      ),
    );
  }
}