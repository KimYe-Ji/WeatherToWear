// main.dart
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
import 'package:alarm_example/local/localPage.dart';


// global variables
Location currentLocation = new Location("default");

String today = DateFormat("yyyyMMdd").format(DateTime.now());
String start = DateFormat("HHmm").format(DateTime.now());
Clothes clothes = new Clothes(-273);

 Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Alarm.init(showDebugLogs: true);
  
  await _getUserLocation();

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: const MyHomePage(),
      home: LoadingPage(),
    );
  }
}

class LoadingPage extends StatefulWidget {
  @override
  LoadingPageState createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    
    

    Timer(
      Duration(seconds:13), 
      () => Navigator.push(context, MaterialPageRoute(builder:(context)=>MyHomePage()))
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/image/loading.png"), fit: BoxFit.fill), 
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              width: width,
              height: height,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(),
                ),
              ),
            ),
          ),
        ],
      ),
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
  String sky = "";
  Translator translator = Translator(currentLocation.weatherNowList);

  Duration time = Duration(seconds: 13);
  
  Clothes clothes = Clothes(double.parse(currentLocation.weatherNowList[0]));

  @override
  void initState() {
    // TODO: implement initState
    txt = currentLocation.address;
    txt2 = currentLocation.weatherNowList[0];
    sky = translator.isSunny(currentLocation.weatherNowList[3]);

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
        sky = translator.isSunny(currentLocation.weatherNowList[3]);

        print(txt);
        print(txt2);
        print(sky);
      });
    }

    _getUserLocation();

    // 현재: 10초 delay로 강제 해결
    Future.delayed(time, printAddress);
  }

  @override
  Widget build(BuildContext context) {

    String path = 'assets/image/loading2.png';

    // 현위치 Container
    Widget getLocationContainer = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //IconButton(onPressed:_setCurrentAddress, icon: Icon(Icons.my_location)), 
          Text(
            txt, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 20, 
            ),
            softWrap: true,
          ),
          IconButton(onPressed:_setCurrentAddress, icon: Icon(Icons.my_location)), 
        ]
      ),
    ); 

    // widget - 날씨 아이콘
    Widget getWeatherIcon() {
      // Icon icon = new Icon(
      //   Icons.error, 
      //   size: 100,
      //   );
      

      Future.delayed(Duration(seconds: 3));

      try {
        sky = Translator(currentLocation.weatherNowList).isSunny(currentLocation.weatherNowList[3]);
        print("test: " + sky);
        switch(sky) {
          case "맑음":
            // icon = new Icon(
            //   Icons.sunny, 
            //   color: Colors.red,
            //   size: 170,
            //   );
            path = 'assets/image/sunny.png';
            break;
          case "구름 많음":
            path = 'assets/image/cloudy.png';
            break;
          case "흐림":
            path = 'assets/image/cloud.png';
            break;
        }
      } catch(exception) {
        print("error");
      }

      return Image.asset(
                      path,
                      width: 120,
                      height: 120,
      );
    
    }

    // 현재 날씨 Container
    Widget getWeatherContainer = Container(
      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getWeatherIcon(),
              Column(
                children: [
                  Text(
                    "$txt2°C", 
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold 
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "$sky", 
                    style: TextStyle(
                      fontSize: 30, 
                    ),
                    textAlign: TextAlign.center,
                  ),  
                  // Text(
                  //   "최고 기온: ${currentLocation.tmx}", 
                  //   style: TextStyle(
                  //     //color: Colors.red,
                  //     fontSize: 20
                  //   ),
                  // ),
                  // Text(
                  //   "최저 기온: ${currentLocation.tmn}",
                  //   style: TextStyle(
                  //     //color: Colors.lightBlueAccent,
                  //     fontSize: 20
                  //   ),
                  //   textAlign: TextAlign.right,
                  // ),  
                ],
              ), 
            ],
          ),
          Container(height: 40),
          Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '최저 기온',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${currentLocation.tmn}°C',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '최고 기온',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${currentLocation.tmx}°C',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '강수확률',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          //'강수량',
                          '${currentLocation.weatherNowList[1]}%',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '습도',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          //'습도',
                          '${currentLocation.weatherNowList[2]}%',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ), 
          // Row(
          //   //crossAxisAlignment: CrossAxisAlignment.stretch,
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Text(
          //           "최고 기온", 
          //           style: TextStyle(
          //             //color: Colors.red,
          //             fontSize: 20
          //           ),
          //         ),
          //         Text(
          //           "최저 기온",
          //           style: TextStyle(
          //             //color: Colors.lightBlueAccent,
          //             fontSize: 20
          //           ),
          //           textAlign: TextAlign.right,
          //         ), 
          //     Text(
          //       "비 올 확률%"
          //     ),
          //     Text(
          //       "현재 습도 상태"
          //     ) 
          //   ],
          // ),
          // Row(
          //   //crossAxisAlignment: CrossAxisAlignment.stretch,
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Text(
          //           "${currentLocation.tmx}", 
          //           style: TextStyle(
          //             //color: Colors.red,
          //             fontSize: 20
          //           ),
          //         ),
          //         Text(
          //           "${currentLocation.tmn}",
          //           style: TextStyle(
          //             //color: Colors.lightBlueAccent,
          //             fontSize: 20
          //           ),
          //           textAlign: TextAlign.right,
          //         ), 
          //     Text(
          //       "${currentLocation.weatherNowList[1]}%"
          //     ),
          //     Text(
          //       "${Translator(currentLocation.weatherNowList).getHumid(currentLocation.weatherNowList[2])}"
          //     ) 
          //   ],
          // ),
        ],
      ),
    );

    // 옷 추천 Container
    Widget getClothesContainer = Container(
      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "오늘의 추천 : ${clothes.getClothes()}", 
            style: TextStyle(
              fontSize: 13
            ),
          ),
          Container(
            height: 15,
          ),
          Image.asset(
            // 상대 경로로 접근 불가
            "${clothes.getImage()}", 
            //fit: BoxFit.fill,
            width: 500,
            height: 125,
          ),
        ]
      ),
    );

    // 자체 navigation bar
    Widget myNavigationbar = Container(
      //color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [ 
          IconButton(
            onPressed: () => {
              // to main page
              
            }, 
            icon: Icon(Icons.home, ), 
            iconSize: 35,
          ),
          IconButton(
            onPressed: () => {
              // to timeline page
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const LocalPage()),  
              )
            }, 
            icon: Icon(Icons.timeline,), 
            iconSize: 35,
          ), 
          IconButton(
            onPressed: () => {
              // to location page
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => localPage()),  
              )
            }, 
            icon: Icon(Icons.map,), 
            iconSize: 35,
          ), 
          IconButton(
            onPressed: () => {
              // to alarm page
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => ExampleAlarmHomeScreen()),
                //MaterialPageRoute(builder: (context) => AlarmInfo()),    
              )
            }, 
            icon: Icon(Icons.alarm, ), 
            iconSize: 35,
          ),
          
        ],
      ),
    );


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          getLocationContainer, 
          Container(
            height: 20,
          ),
          // 날씨
          getWeatherContainer,
          Container(
            height: 40,
          ),
          // Container(
          //   margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
          //   width: 500,
          //   child: Divider(color: Colors.lightBlue, thickness: 2.0),
          // ),
          Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[500],
                  indent: 40,
                  endIndent: 40,
                ),
          Container(
            height: 40,
          ),
          // 옷
          getClothesContainer,
          Container(
            height: 70,
          ),
          Divider(
                  height: 1,
                  thickness: 3,
                  //color: Colors.grey[500],
          ),  
        ],
        
      ),
      bottomNavigationBar: myNavigationbar,
    );
  }
}