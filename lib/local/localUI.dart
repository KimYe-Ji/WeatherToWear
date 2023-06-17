import 'package:flutter/material.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'package:alarm_example/local/locationclass.dart';
//import 'package:localweather/local/localPage.dart';
import 'package:alarm_example/models/location.dart';
import 'package:alarm_example/models/weatherAPI.dart';
import 'package:alarm_example/main.dart';
import 'package:alarm_example/models/translator.dart';
import 'package:alarm_example/models/clothes.dart';
//import 'package:geolocator/geolocator.dart';


class localWeatherPage extends StatefulWidget {
  final localLocation location;

  localWeatherPage({required this.location}); // 매개변수가 꼭 전달되어야 함

  @override
  _LocalWeatherPageState createState() => _LocalWeatherPageState();
}

class _LocalWeatherPageState extends State<localWeatherPage> {
  String sumaicon = 'assets/image/loading_blue.gif'; // 아이콘 이미지 경로
  //String clothicon = 'assets/image/loading_blue.gif';
  String timeicon = 'assets/image/loading_blue.gif';
  String topimage = 'assets/image/loading_blue.gif';
  String botimage = 'assets/image/loading_blue.gif';
  String ctmp = ''; // 현재 기온
  String suma = ''; // 날씨 요약
  String humidity = '0'; // 습도
  String kangsu = '0'; // 강수량
  String addr = '';
  String cody = '추천 코디 : ';

  Location modellocation = new Location('address');

  @override
  void initState() {
    super.initState();
    _setmodelAddress(modellocation, widget.location);
  }

  Future<void> _getmodelLocation(Location modellocation, localLocation location) async{
  
    modellocation.setPosition2(location.latitude, location.longitude);
    modellocation.getLocationAddr2();

    // call weatherAPI
    weatherAPI localwapi = weatherAPI.weatherAPI2(today, location.longitude, location.latitude);
    localwapi.init(modellocation);
  }
    
  Future<void> _setmodelAddress(Location modellocation, localLocation location) async {
    void printAddress() {
      setState(() {

        modellocation.getTempList();
        modellocation.getPopList();
        modellocation.getRehList();
        modellocation.getSkyList();
        modellocation.getTmn();
        modellocation.getTmx(); 

      });
    }
    

    _getmodelLocation(modellocation, location);

    // 현재: 10초 delay로 강제 해결
    Future.delayed(Duration(seconds: 10), printAddress);
  }

  @override
  Widget build(BuildContext context) {

    print('Location 객체 생성');
    //Location modellocation = new Location("${widget.location.city} ${widget.location.district}");
    //print("Location 객체 생성 ${modellocation.address}");

    //_setmodelAddress(modellocation, widget.location);

    //print('setmodel 이후, translator 전');
    
  
    try{
    Translator sky = new Translator(modellocation.weatherNowList);
      switch(sky.isSunny(modellocation.weatherNowList[3], modellocation.weatherNowList[1])) {
        case "맑음":
          sumaicon = 'assets/image/weather/weather_sunny.png';
          break;
        case "구름 많음":
          sumaicon = 'assets/image/weather/weather_sunny_cloud.png';
          break;
        case "흐림":
          sumaicon = 'assets/image/weather/weather_cloudy.png';
          break;
        case "비 옴":
          sumaicon = 'assets/image/weather/weather_rainy.png';
          break;
      }
    addr = modellocation.address;
    ctmp = modellocation.weatherNowList[0]; // 현재 기온
    suma = Translator(modellocation.weatherNowList).isSunny(currentLocation.weatherNowList[3], currentLocation.weatherNowList[1]); // 요약
    humidity = modellocation.weatherNowList[2]; // 습도
    kangsu = modellocation.weatherNowList[1]; // 강수량
    
    } catch(exception) {
    print('에러 났자나... 접근 안되자나....');
    }

    Widget getlocalImageSlide() {
      try{
        topimage = Clothes(double.parse(modellocation.weatherNowList[0])).getTopImg();
        botimage = Clothes(double.parse(modellocation.weatherNowList[0])).getBottomImg();
      } catch(exception) { print('cloth image loading'); }

      void changelocalImage() {
        setState(() {
          topimage = Clothes(double.parse(modellocation.weatherNowList[0])).getTopImg();
          botimage = Clothes(double.parse(modellocation.weatherNowList[0])).getBottomImg();
        });
      }
      

      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [
            // left button
            IconButton(onPressed: changelocalImage, icon: Icon(Icons.arrow_left_sharp, size: 50,)),
            // top and bottom
            Container(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(""),
                  // top
                  Image.asset(
                    "${topimage}", 
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                  ), 
                  // bottom
                  Image.asset(
                    "${botimage}",
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                  )
                ],
              ),
            ), 
            // right button
            IconButton(onPressed: changelocalImage, icon: Icon(Icons.arrow_right_sharp, size: 50,))
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 1),
                // 위치
                Text(
                  addr,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3),
                
                // 날씨 요약과 아이콘
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      sumaicon,
                      width: 140,
                      height: 140,
                    ),
                    //SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          ' ${ctmp}°',
                          //'23도',
                          style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.w800 
                        ),
                        ),
                        Text(
                          //'맑음',
                          suma,
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                
                // 최저기온과 강수량, 최고기온과 습도
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '최저 기온',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${modellocation.tmn}°',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '최고 기온',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          // '${modellocation.tmx}°C',
                          '${modellocation.tmx}°',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '강수확률',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          //'강수량',
                          '${kangsu}%',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '습도',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          //'습도',
                          '${humidity}%',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),//container
                SizedBox(height: 30),

                // 추천 코디
                getlocalImageSlide(),
                
              ],
            ),
          ),
        ],
      ),  
    );
  }
}