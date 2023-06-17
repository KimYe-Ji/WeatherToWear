import 'dart:math';

class Clothes {
  double temp = -273;

  String imgPath = "assets/image/clothes/";
  // default - man
  String gender = "male";

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

  // setter - 성별
  void setGender(String gender) {
    this.gender = gender;
  }

  // 상의 - 온도 따른 구분
  List getTops() {
    List list;

    if(temp > 28.0) {
      if(gender == "female") {
        list = ["wshirt1", "wshirt2", "wshirt3", "wshirt4", "wshirt5"];
      } else {
        list = ["shirt1", "shirt2", "shirt3", "shirt4", "shirt5"];
      }
    } else if(temp <= 28.0 && temp > 23.0) {
      if(gender == "female") {
        list = ["wshirt1", "wshirt2", "wshirt3", "wshirt4", "wshirt5"];
      } else {
        list = ["shirt1", "shirt2", "shirt3", "shirt4", "shirt5"];
      }
    } else if(temp <= 23.0 && temp > 20.0) {
      if(gender == "female") {
        list = ["wshirt1", "wshirt2", "wshirt3", "wshirt4", "wshirt5"];
      } else {
        list = ["shirt1", "shirt2", "shirt3", "shirt4", "shirt5"];
      }
    } else if(temp <= 20 && temp > 17) {
      if(gender == "female") {
        list = ["wshirt1", "wshirt2", "wshirt3", "wshirt4", "wshirt5"];
      } else {
        list = ["shirt1", "shirt2", "shirt3", "shirt4", "shirt5"];
      }
    } else if(temp <= 17 && temp > 12) {
      list = ["jacket", "cardigan", "blazer"];
    } else if(temp <= 12 && temp > 9) {
      list = ["jacket", "trenchcoat", "blazer", "knit"];
    } else if(temp <=9 && temp > 5) {
      list = ["coat", "leatherjacket", "knit"];
    } else {
      list = ["padding", "coat"];
    }

    return list; 
  }

  // 하의 - 성별 따른 구분 + 온도 따른 구분
  List getBottoms() {
    List list;

    if(temp > 28.0) {
      if(gender == "female") {
        list = ["wshorts1", "wshorts2", "wshorts3", "skirt"];
      } else {
        list = ["shorts1", "shorts2", "shorts3", "shorts4", "shorts5", "shorts6"];
      }
    } else if(temp <= 28.0 && temp > 23.0) {
      if(gender == "female") {
        list = ["wshorts1", "wshorts2", "wshorts3", "skirt"];
      } else {
        list = ["shorts1", "shorts2", "shorts3", "shorts4", "shorts5", "shorts6"];
      }
    } else if(temp <= 23.0 && temp > 20.0) {
      if(gender == "female") {
        list = ["wshorts1", "wshorts2", "wshorts3", "skirt", "wjeans"];
      } else {
        list = ["shorts1", "shorts2", "shorts3", "shorts4", "shorts5", "shorts6", "jeans"];
      }
    } else if(temp <= 20 && temp > 17) {
      if(gender == "female") {
        list = ["wshorts1", "wshorts2", "wshorts3", "skirt", "wjeans"];
      } else {
        list = ["shorts1", "shorts2", "shorts3", "shorts4", "shorts5", "shorts6", "jeans"];
      }
    } else if(temp <= 17 && temp > 12) {
      if(this.gender == "female") {
        list = ["slacks", "jeans", "stockings"];
      } else {
        list = ["jeans"];
      }
    } else if(temp <= 12 && temp > 9) {
      if(this.gender == "female") {
        list = ["slacks", "jeans", "stockings"];
      } else {
        list = ["slacks", "jeans"];
      }
    } else if(temp <=9 && temp > 5) {
      if(this.gender == "female") {
        list = ["slacks", "jeans", "stockings"];
      } else {
        list = ["slacks", "jeans"];
      }
    } else {
      if(this.gender == "female") {
        list = ["slacks", "jeans", "stockings"];
      } else {
        list = ["slacks", "jeans"];
      }
    }

    return list; 
  }

  String getImage() {
    String path = "";

    if(temp > 28.0) {
      path = "img1.png";
    } else if(temp <= 28.0 && temp > 23.0) {
      path = "img2.png"; 
    } else if(temp <= 23.0 && temp > 20.0) {
      path = "img3.png";
    } else if(temp <= 20 && temp > 17) {
      path = "img4.png";
    } else if(temp <= 17 && temp > 12) {
      path = "img5.png";
    } else if(temp <= 12 && temp > 9) {
      path = "img6.png";
    } else if(temp <=9 && temp > 5) {
      path = "img7.png";
    } else {
      path = "img8.png";
    }
    
    return imgPath+path;
  }

  // 상의 img path
  String getTopImg() {
    // 온도 따른 상의 list
    List list = getTops();

    // 난수 생성
    int num = Random().nextInt(list.length);

    String p = imgPath+getTops()[num]+".png";
    
    return p;
  }

  // 하의 img path
  String getBottomImg() {
    // 온도 따른 하의 list
    List list = getBottoms();

    // 난수 생성
    int num = Random().nextInt(list.length);

    String p = imgPath+getBottoms()[num]+".png";
    
    return p;
  }
}