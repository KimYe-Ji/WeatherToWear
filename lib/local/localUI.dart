import 'package:flutter/material.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'package:alarm_example/local/locationclass.dart';
//import 'package:localweather/local/localPage.dart';
import 'package:alarm_example/models/location.dart';
import 'package:alarm_example/models/weatherAPI.dart';
import 'package:alarm_example/main.dart';
//import 'package:geolocator/geolocator.dart';


class localWeatherPage extends StatelessWidget {
  final localLocation location;

  localWeatherPage({required this.location}); // 매개변수가 꼭 전달되어야 함

  @override
  Widget build(BuildContext context) {

    //Location 객체 생성
    Location modellocation = new Location("${location.city} ${location.district}");
    print("${modellocation.address}");

    // weatherAPI 객체 생성 및 초기화
    weatherAPI localwapi = weatherAPI.weatherAPI2(today, location.longitude, location.latitude);
    localwapi.init(modellocation);

    return Scaffold(
      appBar: AppBar(
        title: Text('Location Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('City: ${location.city}'),
            Text('District: ${location.district}'),
          ],
        ),
      ),
    );
  }
}