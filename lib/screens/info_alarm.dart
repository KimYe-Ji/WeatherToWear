import 'package:alarm/alarm.dart';
import "package:alarm_example/main.dart";
import "package:flutter/material.dart";
import "package:flutter_tts/flutter_tts.dart";
import 'package:alarm_example/models/translator.dart';

//Alarm - TTS, Weather Info
class AlarmInfo extends StatelessWidget {

  final AlarmSettings alarmSettings;

  AlarmInfo({Key? key, required this.alarmSettings})
      : super(key: key);

  final FlutterTts tts = FlutterTts();
  final TextEditingController controller =
      TextEditingController(
        text: '오늘의 평균 기온은 ${currentLocation.weatherNowList[0]}도입니다. 낮에는 ${currentLocation.tmx}도까지 올라가며 밤에는 최저 ${currentLocation.tmn}도가 될 것입니다. '
      ); 

  /*AlarmInfo() {
    tts.setLanguage('kr');
    tts.setSpeechRate(0.4);
    tts.setPitch(0.9);
    //tts.setVoice(voice)

  }*/


  @override
  Widget build(BuildContext context) {

  
  tts.setLanguage('kr');
  tts.setSpeechRate(0.4);
  tts.setPitch(0.9);
  tts.speak(controller.text);

  Icon icon = new Icon(Icons.error);
  Translator sky = new Translator(currentLocation.weatherNowList);
        switch(sky.isSunny(currentLocation.weatherNowList[3])) {
          case "맑음":
            icon = new Icon(
              Icons.sunny, 
              color: Colors.red,
              size: 170,
              );
            break;
          case "구름 많음":
            icon = new Icon(
              Icons.wb_cloudy, 
              color: Colors.grey[400],
              size: 170,
              );
            break;
          case "흐림":
            icon = new Icon(
              Icons.wb_cloudy_rounded, 
              color: Colors.grey[700],
              size: 170,
              );
            break;
        }

    Widget getAlarmInfoContainer = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Container(
            height: 90,
          ),
          Text( //현위치 정보
            currentLocation.address, 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              //fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 30,
          ),
          icon,
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
          Text(
                "기온 ${currentLocation.weatherNowList[0]}°C", 
                style: TextStyle(
                  fontSize: 40, 
                  fontWeight: FontWeight.bold
                  ),
          ),
          Container(
            height: 10,
          ),
          Row( 
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "강수확률  ${sky.rainPercent(currentLocation.weatherNowList[1])}", 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                  ),
              ),
              Container(
              width: 20,
              ),
              Text(
                "습도  ${currentLocation.weatherNowList[2]}%", 
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
                "최저 기온 ${currentLocation.tmn}°C",
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                  ),
              ),
              Container(
              width: 20,
              ),
              Text(
                "최고 기온 ${currentLocation.tmx}°C", 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                  ),
              ),
            ],
          ),
          Container(
            height: 40,
          ),
          //IconButton(onPressed: () {tts.pause();}, icon: Icon(Icons.pause)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton( //알람 TTS 끄고 메인화면으로 이동
                onPressed: () {
                  tts.speak(controller.text);
                  //tts.pause();
                }, 
                child: Text('다시 듣기'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),//fromARGB(255, 101, 190, 235)),
                 foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
              Container(
                width: 20,
              ),
              ElevatedButton( //알람 TTS 끄고 메인화면으로 이동
                onPressed: () {
                  tts.pause();
                  Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => MyHomePage()),  
                  );
                }, 
                child: Text('알람 끄기'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),//fromARGB(255, 101, 190, 235)),
                 foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
            ],
          ),
          Container(
            height: 70,
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
    
    
     //UI 구현 메인화면 참고
    return Scaffold(
      body: getAlarmInfoContainer
    );
  }
}

  