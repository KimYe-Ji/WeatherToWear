// import 'package:flutter/foundation.dart';

class Weather {
  // basetime 지난 후 refresh
  // basetime: 0200 / 0500/ 0800 / 1100 / 1400 / 1700 / 2000 / 2300
  // fcst: 예보 시간
  late String fcstdate;
  late String fcsttime;
  /*
  * POP: 강수 확률
  * REH: 습도
  * TMP: 1시간 기온
  * TMN: 일 최저 기온
  * TMX: 일 최고 기온
  */
  // 예보 지점 x, y 좌표
  late String nx;
  late String ny;

  // category
  late String category;
  late String fcstValue;

  Weather(String fcstdate, String fcsttime) {
    this.fcstdate = fcstdate;
    this.fcsttime = fcsttime;
  }

  void getWeather() {
    print("today - $fcstdate / time - $fcsttime / category - $category / fcstValue - $fcstValue");
  }
}