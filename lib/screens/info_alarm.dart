import "package:alarm_example/main.dart";
import "package:flutter/material.dart";
import "package:flutter_tts/flutter_tts.dart";

//Alarm - TTS, Weather Info
class AlarmInfo extends StatelessWidget {
  final FlutterTts tts = FlutterTts();
  final TextEditingController controller =
      TextEditingController(text: 'Hello world'); //음성 변환 정보 들어가야하는 내용

  AlarmInfo() {
    tts.setLanguage('kr');
    tts.setSpeechRate(0.4);
  }

  @override
  Widget build(BuildContext context) { //UI 구현 메인화면 참고
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 90,
          ),
          Text( //현위치 정보
            currentLocation.address, 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              //fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 30,
          ),
          Icon( //날씨에 따른 아이콘 정보 *switch case 구현 필요
            Icons.sunny,
            size: 170,
            color: Colors.red,
          ),
          Container(
            height: 10,
          ),
          Expanded( //옷차림 정보
            child: Image(
              image : AssetImage('assets/image/cloth_example.png'),
            ),
          ),
          Container(
            height: 20,
          ),
          Row( //기온
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "기온", 
                style: TextStyle(
                  fontSize: 40, 
                  fontWeight: FontWeight.bold
                  ),
              ),
              Container(
              width: 10,
              ),
              Text(
                "기온", //currentLocation.tempList[0], 
                style: TextStyle(
                  fontSize: 40, 
                  fontWeight: FontWeight.bold
                  ),
              ),
            ],
          ),
          Row( //강수확률(pop), 습도(reh), 최저기온(tmn), 최고기온(tmx) 추가 필요
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "강수확률", 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                  ),
              ),
              Container(
              width: 10,
              ),
              Text(
                "강수확률", 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                  ),
              ),
              Container(
              width: 20,
              ),
              Text(
                "습도", 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                  ),
              ),
              Container(
              width: 10,
              ),
              Text(
                "습도", 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                  ),
              ),
            ],
          ),
          Row( //강수확률(pop), 습도(reh), 최저기온(tmn), 최고기온(tmx) 추가 필요
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "최저기온", 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                  ),
              ),
              Container(
              width: 10,
              ),
              Text(
                "최저기온", 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                  ),
              ),
              Container(
              width: 20,
              ),
              Text(
                "최고기온", 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                  ),
              ),
              Container(
              width: 10,
              ),
              Text(
                "최고기온", 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                  ),
              ),
            ],
          ),
          Container(
            height: 50,
          ),
          ElevatedButton( //알람 TTS 끄고 메인화면으로 이동
            onPressed: () {
              Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => MyApp()),  
            );
            }, 
            child: Text('알람 끄기'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),//fromARGB(255, 101, 190, 235)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
          ),
          Container(
            height: 60,
          ),
          /*TextField(
            controller: controller,
          ),
          ElevatedButton(
              onPressed: () {
                tts.speak(controller.text);
              },
              child: Text('Speak'))*/
        ],
      ),
    );
  }
}