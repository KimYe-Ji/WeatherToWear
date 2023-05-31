import 'package:flutter/material.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'package:alarm_example/local/locallocation.dart';
//import 'package:localweather/local/localPage.dart';

class localWeatherPage extends StatelessWidget {
  final localLocation location;

  localWeatherPage({required this.location});

  @override
  Widget build(BuildContext context) {
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