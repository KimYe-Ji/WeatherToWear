import 'package:flutter/material.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'package:alarm_example/local/locationclass.dart';
//import 'package:localweather/local/localPage.dart';
import 'package:alarm_example/models/location.dart';
import 'package:alarm_example/models/weatherAPI.dart';
import 'package:alarm_example/main.dart';
import 'package:alarm_example/models/translator.dart';
//import 'package:geolocator/geolocator.dart';

class localWeatherPage extends StatelessWidget {
  final localLocation location;

  localWeatherPage({required this.location}); // 매개변수가 꼭 전달되어야 함


  //final String locationn = 'Seoul';
  //final String summary = '맑음';
  String icon = 'assets/sunny_icon.png'; // 아이콘 이미지 경로
  /*
  final double currentTemperature = 25.0;
  final double minTemperature = 18.0;
  final double maxTemperature = 28.0;
  final int humidity = 70;
  final double precipitation = 0.3;
  */


  @override
  Widget build(BuildContext context) {

    //Location 객체 생성
    Location modellocation = new Location("${location.city} ${location.district}");
    print("${modellocation.address}");

    // weatherAPI 객체 생성 및 초기화
    weatherAPI localwapi = weatherAPI.weatherAPI2(today, location.longitude, location.latitude);
    localwapi.init(modellocation);

    //Position position = Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    //modellocation.setPosition(position);
    modellocation.setPosition2(location.latitude, location.longitude);
    modellocation.getLocationAddr2();
    modellocation.getTempList();
    modellocation.getPopList();
    modellocation.getRehList();
    modellocation.getSkyList();
    modellocation.getTmn();
    modellocation.getTmx();

    Translator sky = new Translator(modellocation.weatherNowList);
      switch(sky.isSunny(modellocation.weatherNowList[3])) {
        case "맑음":
          icon = 'assets/image/sunny.png';
          break;
        case "구름 많음":
          icon = 'assets/image/cloudy.png';
          break;
        case "흐림":
          icon = 'assets/image/cloud.png';
          break;
      }


    return Scaffold(
      appBar: AppBar(
        title: Text('Local Weather'),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                // 위치
                Text(
                  modellocation.address,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                
                // 날씨 요약과 아이콘
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*
                    Icon(
                      Icons.wb_sunny,
                      size: 100,  
                    ),*/
                    Image.asset(
                      icon,
                      width: 90,
                      height: 90,
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          '${modellocation.weatherNowList[0]}°C',
                          style: TextStyle(fontSize: 48),
                        ),
                        Text(
                          modellocation.weatherNowList[3],
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
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          '${modellocation.tmn}°C',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '최고 기온',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          '${modellocation.tmx}°C',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '강수량',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          '${modellocation.weatherNowList[1]}mm',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '습도',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          '${modellocation.weatherNowList[2]}%',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                
                // 구분선
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[300],
                  indent: 40,
                  endIndent: 40,
                ),
                SizedBox(height: 30),
                
                // 옷사진
                Image.asset(
                      'assets/images/clothes.jpg',
                      width: 400,
                      height: 150,
                ),
                /*
                Icon(
                  Icons.shopping_bag,
                  size: 50,
                ),*/
                SizedBox(height: 30),
                
                // 구분선
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[300],
                  indent: 40,
                  endIndent: 40,
                ),
                SizedBox(height: 30),

                // 시간별 기온 그래프
                Image.asset(
                      'assets/images/chart.png',
                      width: 400,
                      height: 100,
                ),
              ],
            ),
          ),
        ],
      ),  
    );
  }
}