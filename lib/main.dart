import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum dangerLevel {green, orange, red}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  AnimationController controller;
  String get timerString {
    Duration duration = controller.duration *controller.value;
    return '${duration.inMinutes%60}:${(duration.inSeconds%60).toString().padLeft(2,'0')}';
  }
  @override
  void initState(){
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(hours:20));
    controller.forward();
  }

  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: Center(
        child: Container(
          color: Colors.blue,
          padding: EdgeInsets.all(25),
          child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, Widget child){
                      return new Text(
                        timerString,
                        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
                      );
                    }),
              ),
            ),
          ],
          ),
        ),
      ),
    );

  }

}


class meltdownButton{
    
}
