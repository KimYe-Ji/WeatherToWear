import "package:alarm_example/main.dart";
import "package:flutter/material.dart";
import "package:flutter_tts/flutter_tts.dart";

//메인화면의 날씨 정보를 받아오고, tts 정보 알려주기 
class AlarmInfo extends StatelessWidget {
  final FlutterTts tts = FlutterTts();
  final TextEditingController controller =
      TextEditingController(text: 'Hello world'); //음성 변환 정보 들어가야하는 내용 

  //final Location location = Location();
  var ad = currentLocation.address;

  AlarmInfo() {
    tts.setLanguage('kr');
    tts.setSpeechRate(0.4);
  }

  @override
  Widget build(BuildContext context) { //UI 구현 메인화면 참고해서 
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            currentLocation.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.sunny,
          ),
          Expanded(
            child: Image(
              image : AssetImage('assets/image/cloth_example.png'),
            ),
          ),
          Row(
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
          Row(
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
          ElevatedButton(
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