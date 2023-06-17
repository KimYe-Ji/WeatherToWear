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
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:alarm_example/screens/cloth_screen.dart';



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
        fontFamily: 'NanumSquareNeo',
      ),
      routes: {
        '/main':(context) => MyHomePage(),
      },
      // home: const MyHomePage(),
      home: LoadingPage(),
    );
  }
}

class LoadingPage extends StatefulWidget {
  @override
  LoadingPageState createState() => LoadingPageState();
}

void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg, 
    backgroundColor: Color.fromARGB(255, 216, 242, 255), 
    textColor: const Color.fromARGB(255, 44, 44, 44),
    toastLength: Toast.LENGTH_LONG, 
    gravity: ToastGravity.BOTTOM, 
  );
}

class LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    showToast("날씨 정보 불러오는 중 ...");

    Timer(
      Duration(seconds:13), 
      // () => Navigator.push(context, MaterialPageRoute(builder:(context)=>MyHomePage()))
      // () => Navigator.popAndPushNamed(context, "/main")
      () => Navigator.of(context).pushReplacementNamed("/main"),
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
  
  print("_getUserLocation 내: $position");
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
    sky = translator.isSunny(currentLocation.weatherNowList[3], currentLocation.weatherNowList[1]);

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
        sky = translator.isSunny(currentLocation.weatherNowList[3], currentLocation.weatherNowList[1]);

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
          Container(
            width: 20,
          ),
          Text(
            txt, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16, 
            ),
            softWrap: true,
          ),
          IconButton(onPressed:_setCurrentAddress, icon: Icon(Icons.my_location, size: 20,)), 
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
        sky = Translator(currentLocation.weatherNowList).isSunny(currentLocation.weatherNowList[3], currentLocation.weatherNowList[1]);
        print("test: " + sky);
        switch(sky) {
          case "맑음":
            // path = 'assets/image/sunny.png';
            path = 'assets/image/weather/weather_sunny.png';
            break;
          case "구름 많음":
            // path = 'assets/image/cloudy.png';
            path = 'assets/image/weather/weather_sunny_cloud.png';
            break;
          case "흐림":
            // path = 'assets/image/cloud.png';
            path = 'assets/image/weather/weather_cloudy.png';
            break;
          case "비 옴":
            // path = 'assets/image/cloud.png';
            path = 'assets/image/weather/weather_rainy.png';
          break;
        }
      } catch(exception) {
        print("error");
      }

      return Image.asset(
                      path,
                      width: 140,
                      height: 140,
      );
    
    }

    // 현재 날씨 Container
    Widget getWeatherContainer = Container(
      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getWeatherIcon(),
              Container(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    " $txt2°", 
                    style: TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.w800 
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
                ],
              ), 
            ],
          ),
          Container(height: 20),
          Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '최저 기온',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${currentLocation.tmn}°',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '최고 기온',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${currentLocation.tmx}°C',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '강수확률',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          //'강수량',
                          '${currentLocation.weatherNowList[1]}%',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '습도',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          //'습도',
                          '${currentLocation.weatherNowList[2]}%',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ), 
        ],
      ),
    );

    // // 옷 추천 Container
    // Widget getClothesContainer = Container(
    //   margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     //crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: [
    //       Text(
    //         "오늘의 추천 : ${clothes.getClothes()}", 
    //         style: TextStyle(
    //           fontSize: 13
    //         ),
    //       ),
    //       Container(
    //         height: 15,
    //       ),
    //       Image.asset(
    //         // 상대 경로로 접근 불가
    //         "${clothes.getImage()}", 
    //         //fit: BoxFit.fill,
    //         width: 500,
    //         height: 125,
    //       ),
    //     ]
    //   ),
    // );


    Widget getImageSlide() {
      String topPath = clothes.getTopImg();
      String botPath = clothes.getBottomImg();

      void changeImage() {
        setState(() {
          topPath = clothes.getTopImg();
          botPath = clothes.getBottomImg();
        });
      }

      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [
            // left button
            IconButton(onPressed: changeImage, icon: Icon(Icons.arrow_left_sharp, size: 50,)),
            // top and bottom
            Container(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(""),
                  // top
                  Image.asset(
                    "${topPath}", 
                    width: 160,
                    height: 160,
                    //fit: BoxFit.contain,
                  ), 
                  // bottom
                  Image.asset(
                    "${botPath}",
                    width: 160,
                    height: 160,
                    //fit: BoxFit.contain,
                  )
                ],
              ),
            ), 
            // right button
            IconButton(onPressed: changeImage, icon: Icon(Icons.arrow_right_sharp, size: 50,))
          ],
        ),
      );
    }


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
                //MaterialPageRoute(builder: (context) => const LocalPage()),  
                MaterialPageRoute(builder: (context) => ClothInfo()), 
              )
            }, 
            icon: Icon(Icons.checkroom), 
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


    return WillPopScope(
      onWillPop: () {
          return Future(() => false);
        },
        child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        // ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Container(height: 60 ),
            getLocationContainer, 
            // Container(
            //   height: 5,
            // ),
            // 날씨
            getWeatherContainer,
            // Container(
            //   height: 20,
            // ),
            // Container(
            //   margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
            //   width: 500,
            //   child: Divider(color: Colors.lightBlue, thickness: 2.0),
            // ),
            // Divider(
            //         height: 1,
            //         thickness: 1,
            //         color: Colors.grey[500],
            //         indent: 40,
            //         endIndent: 40,
            //       ),
            // Container(
            //   height: 40,
            // ),
            // // 옷
            // getClothesContainer,
            Container(height: 10),
            getImageSlide(), 
            Container(height: 1),
            // Container(
            //   height: 70,
            // ),

            // Container(
            //   height: 70,
            // ),
            // Divider(
            //         height: 1,
            //         thickness: 3,
            //         //color: Colors.grey[500],
            // ),  
          ],
          
        ),
        bottomNavigationBar: myNavigationbar,
      ),
    );
  }
}