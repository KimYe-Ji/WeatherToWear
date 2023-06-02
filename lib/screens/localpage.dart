import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:alarm_example/main.dart';

class LocalPage extends StatefulWidget {
  const LocalPage({super.key});

  @override
  _localPageState createState() => _localPageState();
}

class _localPageState extends State<LocalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 뒤로가기 지우기
        // automaticallyImplyLeading: false,
        // backgroundColor: Colors.cyan,
        ),
      body: Center(child: Text("현재 위치 ${currentLocation.address}")),
    );
  }
}
