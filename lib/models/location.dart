import 'package:alarm_example/models/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Location {
  // late: 값의 초기화를 뒤로 미룸 + null 사용 방지
  late Position position;
  late String address;
  late List<Weather> tempList;
  late List<Weather> popList;
  late List<Weather> rehList;
  late List<Weather> skyList;
  late List<String> weatherNowList;
  late double tmn = -273.15;
  late double tmx = 1200;

  // constructor
  Location(String address) {
    this.address = address;
    tempList = new List.empty(growable: true);
    popList = new List.empty(growable: true);
    rehList = new List.empty(growable: true);
    skyList = new List.empty(growable: true);
    weatherNowList = new List.empty(growable: true);
  }

  // set location's long, lat
  void setPosition(Position position) {
    this.position = position;

    print(position);
  }

  // get address
  void getLocationAddr() async {
    // 위도, 경도
    var lat = this.position.latitude;
    var lon = this.position.longitude;

    // kakao api: REST
    Uri kakaoUri = Uri.parse(
        "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$lon&y=$lat&input_coord=WGS84");
    final String kakao_api = "48e1b9a10f747c23afbb5cbfd6de457c";

    var kakaoAddr = await http
        .get(kakaoUri, headers: {"Authorization": "KakaoAK $kakao_api"});
    
    // convert to json
    var toJson = jsonDecode(kakaoAddr.body);

    // parse json -> address
    String addr = toJson["documents"][0]["address"]["region_1depth_name"] +
        " " +
        toJson["documents"][0]["address"]["region_2depth_name"] +
        " " +
        toJson["documents"][0]["address"]["region_3depth_name"];

    // print(addr);
    this.address = addr;

    print("주소 변환: $address");
  }

  // getters
  void getTempList() {
    for(Weather w in tempList) {
      w.getWeather();
    }
  }

  void getPopList() {
    for(Weather w in popList) {
      w.getWeather();
    }
  }

  void getRehList() {
    for(Weather w in rehList) {
      w.getWeather();
    }
  }

  void getSkyList() {
    for(Weather w in skyList) {
      w.getWeather();
    }
  }
  void getTmn() {
    print("최저 기온: $tmn");
  }

  void getTmx() {
    print("최고 기온: $tmx");
  }

  void weatherNow(var time) {
    // List<String> weatherNow = new List.empty(growable: true);

    for(Weather w in tempList) {
      if(w.fcsttime == time) {
        weatherNowList.add(w.fcstValue);
        // print("1");
      }
    }

    for(Weather w in popList) {
      if(w.fcsttime == time) {
        weatherNowList.add(w.fcstValue);
        // print("2");
      }
    }

    for(Weather w in rehList) {
      if(w.fcsttime == time) {
        weatherNowList.add(w.fcstValue);
        // print("3");
      }
    }

    for(Weather w in skyList) {
      if(w.fcsttime == time) {
        weatherNowList.add(w.fcstValue);
        // print("4");
      }
    }
  }
}
