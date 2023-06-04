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

Future<void> _getmodelLocation(Location modellocation, localLocation location) async{
  
  modellocation.setPosition2(location.latitude, location.longitude);
  modellocation.getLocationAddr2();

  // call weatherAPI
  weatherAPI localwapi = weatherAPI.weatherAPI2(today, location.longitude, location.latitude);
  localwapi.init(modellocation);
}
  
Future<void> _setmodelAddress(Location modellocation, localLocation location) async {
  void printAddress() {

      modellocation.getTempList();
      modellocation.getPopList();
      modellocation.getRehList();
      modellocation.getSkyList();
      modellocation.getTmn();
      modellocation.getTmx(); 

      print(modellocation.address);
      print(modellocation.weatherNowList[0]);
    };
  

    _getmodelLocation(modellocation, location);

    // 현재: 10초 delay로 강제 해결
    Future.delayed(Duration(seconds: 13), printAddress);
}


class localWeatherPage extends StatelessWidget {
  final localLocation location;

  localWeatherPage({required this.location}); // 매개변수가 꼭 전달되어야 함

  String icon = 'assets/image/sunny.png'; // 아이콘 이미지 경로

  @override
  Widget build(BuildContext context) {

    //Location 객체 생성
    Location modellocation = new Location("${location.city} ${location.district}");
    print("Location 객체 생성 ${modellocation.address}");

    _setmodelAddress(modellocation, location);

    print('setmodel 이후, translator 전');
    
    Translator sky = new Translator(modellocation.weatherNowList);
      switch(sky.isSunny(modellocation.weatherNowList[3])) {
        case "맑음":
          icon = 'assets/image/sunny.png';
          print('icon: ${icon}');
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
                          //'23도',
                          style: TextStyle(fontSize: 48),
                        ),
                        Text(
                          //'맑음',
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
                          //'강수량',
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
                          //'습도',
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
                      'assets/image/cloth_example.png',
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
                      'assets/image/chart.png',
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