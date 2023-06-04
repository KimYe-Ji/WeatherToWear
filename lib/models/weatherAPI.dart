// 기상청 API 호출

import 'package:alarm_example/models/location.dart';
import 'package:alarm_example/models/weather.dart';
import 'package:alarm_example/main.dart';
import 'package:alarm_example/models/convertion.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

// get - Today's forecast
  List<Weather> getTodayWeather(dynamic data) {
  //print("Today's date: ");
  List <Weather> weatherToday = new List.empty(growable: true);
  for(int i = 0; i < data.length; i++) {
    if(data[i]["fcstDate"] == today) {
      String date = data[i]["fcstDate"];
      String time = data[i]["fcstTime"];
      String category = data[i]["category"];
      String val = data[i]["fcstValue"];
      Weather w = Weather(date, time);
      w.nx = data[i]["nx"].toString();
      w.ny = data[i]["ny"].toString();
      w.category = category;
      w.fcstValue = val;
      weatherToday.add(w);
    }
  }

  // 시간별 추가 작업 필요
  //(필요; tmp(기온) pop(강수 확률) reh (습도) tmn (최저 기온) tmx (최고 기온)*/
  return weatherToday;
}

// get - Today's temperature
List<Weather> getTodayTmp(List<dynamic> weatherList) {
  List <Weather> tempList = new List.empty(growable: true);

  for(int i = 0; i < weatherList.length; i++) {
    if(weatherList[i].category == "TMP") {
      tempList.add(weatherList[i]);
    }
  }

  return tempList;
}

// get - Today's precipitation %
List<Weather> getTodayPop(List<dynamic> weatherList) {
  List <Weather> popList = new List.empty(growable: true);

  for(int i = 0; i < weatherList.length; i++) {
    if(weatherList[i].category == "POP") {
      popList.add(weatherList[i]);
    }
  }

  return popList;
}

// get - Today's humidity
List<Weather> getTodayReh(List<dynamic> weatherList) {
  List <Weather> rehList = new List.empty(growable: true);

  for(int i = 0; i < weatherList.length; i++) {
    if(weatherList[i].category == "REH") {
      rehList.add(weatherList[i]);
    }
  }

  return rehList;
}

// get - Today's lowest temperature
double getTodayTmn(List<dynamic> weatherList) {
  late double tmn;

  for(int i = 0; i < weatherList.length; i++) {
    if(weatherList[i].category == "TMN") {
      tmn = double.parse(weatherList[i].fcstValue);
    }
  }

  return tmn;
}

// get - Today's highest temperature
double getTodayTmx(List<dynamic> weatherList) {
  late double tmx;

  for(int i = 0; i < weatherList.length; i++) {
    if(weatherList[i].category == "TMX") {
      tmx = double.parse(weatherList[i].fcstValue);
    }
  }

  return tmx;
}

void sortCategory(Location location, List<dynamic> weatherList) {
  location.tempList.clear();
  location.rehList.clear();
  location.skyList.clear();
  location.popList.clear();
  
  for(int i = 0; i < weatherList.length; i++) {
    switch(weatherList[i].category) {
      case "TMP":
        location.tempList.add(weatherList[i]);
        break;
      case "POP":
        location.popList.add(weatherList[i]);
        break;
      case "REH":
        location.rehList.add(weatherList[i]);
        break;
      case "SKY":
        location.skyList.add(weatherList[i]);
        break;
      case "TMN":
        location.tmn = double.parse(weatherList[i].fcstValue);
        break;
      case "TMX":
        location.tmx = double.parse(weatherList[i].fcstValue);
        break;
    }
  }
}



class weatherAPI {
  String url = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?";
  
  final String api_key = "l9zlIj46%2BTFni8gKz5A9ro4PqwgKO37ZzU77UsII7N%2BiVxnfc2rcC1Qqb0%2BsQ0DbUT3SX1W3rG5Qy92dpwU%2FhQ%3D%3D";
  final String pageNo = "1";
  final String numOfRows = "1000";
  final String dataType = "JSON";

  late String base_date;
  late String nx;
  late String ny;

  // default
  String base_time = "0200";

  // constructor - 예지 참고 
  weatherAPI(String today, Position position) {
    this.base_date = today;
    int now = DateTime.now().hour;
    
    // set - nx & ny
    gridXY point = convertLongLat(position.longitude, position.latitude);
    this.nx = point.x.toString();
    this.ny = point.y.toString();

    if(now >= 0 && now <= 2) {
      base_date = DateFormat("yyyyMMdd").format(DateTime.now().subtract(Duration(days: 1)));
      print("어제: $base_date");
      base_time = "2300";
      this.url = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=$api_key&pageNo=$pageNo&numOfRows=$numOfRows&dataType=$dataType&base_date=$base_date&base_time=$base_time&nx=$nx&ny=$ny";
    } else {
      this.url = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=$api_key&pageNo=$pageNo&numOfRows=$numOfRows&dataType=$dataType&base_date=$base_date&base_time=$base_time&nx=$nx&ny=$ny";
    }
  }

  weatherAPI.weatherAPI2(String today, double long, double lat) {
      this.base_date = today;
      int now = DateTime.now().hour;
    
    // set - nx & ny
    gridXY point = convertLongLat(long, lat);
    this.nx = point.x.toString();
    this.ny = point.y.toString();

    if(now >= 0 && now <= 2) {
      base_date = DateFormat("yyyyMMdd").format(DateTime.now().subtract(Duration(days: 1)));
      print("어제: $base_date");
      base_time = "2300";
      this.url = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=$api_key&pageNo=$pageNo&numOfRows=$numOfRows&dataType=$dataType&base_date=$base_date&base_time=$base_time&nx=$nx&ny=$ny";
    } else {
      this.url = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=$api_key&pageNo=$pageNo&numOfRows=$numOfRows&dataType=$dataType&base_date=$base_date&base_time=$base_time&nx=$nx&ny=$ny";
    }
  }

  void init(Location location) async {
    currentLocation.weatherNowList.clear();
    location.weatherNowList.clear();
    
    print("TEST: ${currentLocation.weatherNowList}");
    print(url);
    // call API
    http.Response uriResponse = await http.get(Uri.parse(url));

    // print(uriResponse.body);

    // get JSON data
    var json = jsonDecode(uriResponse.body);
    var weatherJson = json["response"]["body"]["items"]["item"];

    // print(weatherJson);

    // parse today's weather
    List<dynamic> weatherToday = getTodayWeather(weatherJson);

    // weatherToday[0].getWeather();
    // currentLocation.tempList = getTodayTmp(weatherToday);
    // currentLocation.popList = getTodayPop(weatherToday);
    // currentLocation.rehList = getTodayReh(weatherToday);
    // currentLocation.tmn = getTodayTmn(weatherToday);
    // currentLocation.tmx = getTodayTmx(weatherToday);
    sortCategory(location, weatherToday);

    // 현재 시간 날씨 배열에 값 저장 - String
    String time = DateTime.now().hour.toString();
    if(time.length == 1) {
      time = "0${time}00";
    } else {
      time = "${time}00";
    }
    print('time ${time}');
    
    currentLocation.weatherNow(time);
    location.weatherNow(time);

  }
}