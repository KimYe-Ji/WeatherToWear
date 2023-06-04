class Clothes {
  double temp = -273;
  String imgPath = "image/";

  Clothes(double t) {
    this.temp = t;
  }

  String getClothes() {
    String recommended = "";

    if(temp > 28.0) {
      recommended = "민소매, 반팔, 반바지, 원피스";
    } else if(temp <= 28.0 && temp > 23.0) {
      recommended = "반팔, 얇은 셔츠, 반바지, 면바지"; 
    } else if(temp <= 23.0 && temp > 20.0) {
      recommended = "얇은 가디건, 긴팔, 면바지, 청바지";
    } else if(temp <= 20 && temp > 17) {
      recommended = "얇은 니트, 맨투맨, 가디건, 청바지";
    } else if(temp <= 17 && temp > 12) {
      recommended = "자켓, 가디건, 야상, 스타킹, 청바지, 면바지";
    } else if(temp <= 12 && temp > 9) {
      recommended = "자켓, 트렌치코트, 야상, 니트, 청바지, 스타킹";
    } else if(temp <=9 && temp > 5) {
      recommended = "코트, 가죽자켓, 히트텍, 니트, 레깅스";
    } else {
      recommended = "패딩, 두꺼운 코트, 목도리, 기모제품";
    }
    
    return recommended;
  }

  String getImage() {
    String path = "";

    if(temp > 28.0) {
      path = "cloth_example.png";
    } else if(temp <= 28.0 && temp > 23.0) {
      path = "cloth_example.png"; 
    } else if(temp <= 23.0 && temp > 20.0) {
      path = "cloth_example.png";
    } else if(temp <= 20 && temp > 17) {
      path = "cloth_example.png";
    } else if(temp <= 17 && temp > 12) {
      path = "cloth_example.png";
    } else if(temp <= 12 && temp > 9) {
      path = "cloth_example.png";
    } else if(temp <=9 && temp > 5) {
      path = "cloth_example.png";
    } else {
      path = "cloth_example.png";
    }
    
    return imgPath+path;
  }
}