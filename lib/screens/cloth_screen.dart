//Second Screen
import 'package:alarm_example/models/clothes.dart';
import 'package:flutter/material.dart';
import 'package:alarm_example/main.dart';
import 'package:alarm_example/models/clothes.dart';

double noon_temp = currentLocation.getNoonTemp();
double night_temp = currentLocation.getNightTemp();

class ClothInfo extends StatefulWidget {
  const ClothInfo({super.key});

  @override
  State<ClothInfo> createState() => _ClothInfoState();
}

class _ClothInfoState extends State<ClothInfo> {
  //String sex = '';
  bool isMale = true;
  bool isFemale = false;
  bool isCold = false;
  bool isHot = false;
  bool isNormal = true;
  late List<bool> isSexSelected;
  late List<bool> isSenseSelected;

  Clothes noon_cth = Clothes(noon_temp); //주간
  Clothes night_cth = Clothes(night_temp); //야간

  @override
  void initState() {
    isSexSelected = [isMale, isFemale];
    isSenseSelected = [isCold, isNormal, isHot];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget getNoonImageSlide() {
      String topPath1 = noon_cth.getTopImg();
      String botPath1 = noon_cth.getBottomImg();

      void changeImage2() {
        setState(() {
          topPath1 = noon_cth.getTopImg();
          botPath1 = noon_cth.getBottomImg();
        });
      }

      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [
            // left button
            IconButton(onPressed: changeImage2, icon: Icon(Icons.arrow_left_sharp, size: 50,)),
            // top and bottom
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '주간 옷차림 추천',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  Container(
                    height:10
                  ),
                  // top
                  Image.asset(
                    "${topPath1}", 
                    width: 100,
                    height: 100,
                    //fit: BoxFit.contain,
                  ), 
                  // bottom
                  Image.asset(
                    "${botPath1}",
                    width: 100,
                    height: 100,
                    //fit: BoxFit.contain,
                  ),
                ],
              ),
            ), 
            // right button
            IconButton(onPressed: changeImage2, icon: Icon(Icons.arrow_right_sharp, size: 50,))
          ],
        ),
      );
    }

    Widget getNightImageSlide() {
      String topPath = night_cth.getTopImg();
      String botPath = night_cth.getBottomImg();

      void changeImage() {
        setState(() {
          topPath = night_cth.getTopImg();
          botPath = night_cth.getBottomImg();
        });
      }

      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [
            // left button
            IconButton(onPressed: changeImage, icon: Icon(Icons.arrow_left_sharp, size: 50,)),
            // top and bottom
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '야간 옷차림 추천',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  Container(
                    height:10
                  ),
                  // top
                  Image.asset(
                    "${topPath}", 
                    width: 100,
                    height: 100,
                    //fit: BoxFit.contain,
                  ), 
                  // bottom
                  Image.asset(
                    "${botPath}",
                    width: 100,
                    height: 100,
                    //fit: BoxFit.contain,
                  ),
                ],
              ),
            ), 
            // right button
            IconButton(onPressed: changeImage, icon: Icon(Icons.arrow_right_sharp, size: 50,))
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person, size: 35), 
            onPressed: () {
              showModalBottomSheet( //옷 추천을 위한 사용자 설정 
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 250,
                    width: 300, // 모달 높이 크기
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 30,
                    ), // 모달 좌우하단 여백 크기
                    decoration: const BoxDecoration(
                      color: Colors.white, // 모달 배경색
                      borderRadius: BorderRadius.all(
                        Radius.circular(20), // 모달 전체 라운딩 처리
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("성별",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),),
                        Container(height: 10),
                        ToggleButtons(
                          disabledColor: Colors.white,
                          selectedColor: Colors.lightBlue,
                          children: [
                            Text("남자",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                            Text("여자",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          ], 
                          isSelected: isSexSelected,
                          onPressed: sexSelect,
                        ),
                        Container(height: 30),
                        Text("날씨 민감도",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),),
                        Container(height: 10),
                        ToggleButtons(
                          disabledColor: Colors.white,
                          selectedColor: Colors.lightBlue,
                          children: [
                            Text("추위에 약함",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                            Text("보통",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                            Text("더위에 약함",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          ], 
                          isSelected: isSenseSelected,
                          onPressed: senseSelect,
                        ),
                        Container(height: 10),
                      ],
                    ), // 모달 내부 디자인 영역
                  );
                },
                backgroundColor: Colors.transparent, // 앱 <=> 모달의 여백 부분을 투명하게 처리
              );
            },
          ),]),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 350,
            height: 300,
            decoration: BoxDecoration(
              // color: Colors.lightBlue.withOpacity(0.3),
              color: Color.fromARGB(255, 216, 242, 255),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: getNoonImageSlide(),
          ),
          Container(
            width: 350,
            height: 300,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 186, 231, 253),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: getNightImageSlide(),
          ),
          Container(
            height: 10,
          ),
        ],
          ),
      ),
    );
  }

  void sexSelect(value) {
    if (value == 0) {
      isMale = true;
      isFemale = false;
      noon_cth.setGender("male");
      night_cth.setGender("male");
    } else {
      isMale = false;
      isFemale = true;
      noon_cth.setGender("female");
      night_cth.setGender("female");
    }
    //print("$isMale, $isFemale");
    setState(() {
      isSexSelected = [isMale, isFemale];
    });
  }

  void senseSelect(value) {
    if (value == 0) {
      isCold = true;
      isNormal = false;
      isHot = false;
      noon_temp -= 2;
      night_temp -= 2;

    } 
    else if (value == 1) {
      isCold = false;
      isNormal = true;
      isHot = false;
    }
    else {
      isCold = false;
      isNormal = false;
      isHot = true;
      noon_temp += 2;
      night_temp += 2;
    }
    //print("$isCold, $isNormal, $isHot");
    setState(() {
      isSenseSelected = [isCold, isNormal, isHot];
    });
  }
}

