class Translator {
  List<String> weatherInfo = new List.empty(growable: true); 
  // List<String> translated = new List.empty(growable: true);

  Translator(List<String> weatherInfo) {
    this.weatherInfo = weatherInfo;
  }

  // 강수 확률 수치 -> "~%로 비가 올 예정"
  // String rainPercent(String pop) {
  //   return "$pop%";
  // }

  // 습도 30% 미만 or 70% 이상: bad
  // 30 ~ 60% 적당
  String getHumid(String reh) {
    double humid = double.parse(reh);

    if(humid < 30.0) {
      return "건조";
    } else if (humid > 70.0) {
      return "습함";
    } else {
      return "쾌적";
    }
  }

  // 하늘 상태 -> 기상청 docs 참고
  /*
   * 맑음: 0 ~ 5
   * 구름 많음: 6 ~ 8
   * 흐림: 9 ~ 10
  */
  String isSunny(String sky) {
    late String status;
    switch(sky) {
      case "0":
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
        status = "맑음";
        break;
      case "6":
      case "7":
      case "8":
        status = "구름 많음";
        break;
      case "9":
      case "10":
        status = "흐림";
        break;
    }
    return status;
  }
}