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
          Text( //현위치 정보
            currentLocation.address, 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon( //날씨에 따른 아이콘 정보 *switch case 구현 필요
            Icons.sunny,
          ),
          Expanded( //옷차림 정보
            child: Image(
              image : AssetImage('assets/image/cloth_example.png'),
            ),
          ),
          Row( //기온
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "기온", 
                style: TextStyle(
                  fontSize: 40, 
                  fontWeight: FontWeight.bold
                  ),
              ),
            ],
          ),
          Row( //강수확률(pop), 습도(reh), 최저기온(tmn), 최고기온(tmx) 추가 필요
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "기온", 
                style: TextStyle(
                  fontSize: 40, 
                  fontWeight: FontWeight.bold
                  ),
              ),
            ],
          ),
          ElevatedButton( //알람 TTS 끄고 메인화면으로 이동 필요
            onPressed: () {
              print("Turn off");
            }, 
            child: Text('알람 끄기'),
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