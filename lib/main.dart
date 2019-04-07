import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:math';

enum DangerLevel {green, orange, red}

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
  List<MeltdownButton> controlBoard = new List<MeltdownButton>();
  int timeDifficulty = 0;
  String get timerString {
    Duration duration = controller.duration *controller.value;
    return '${duration.inMinutes%60}:${(duration.inSeconds%60).toString().padLeft(2,'0')}';
  }
  @override
  void initState(){
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(hours:20));
    controller.forward();
    _fillBoard(controlBoard);
    _update();
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
              AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return new Text(
                      timerString,
                      style: TextStyle(fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    );
                  }),
              Expanded(child: _generateControlBoard()
              )
              ,
            ],
          ),
        ),
      ),
    );

  }


  _fillBoard(List<MeltdownButton> board){
    for(int i = 0; i < 12; i++){
      board.add(new MeltdownButton());
    }
  }

  Widget _generateControlBoard(){
    List<Widget> bloop = new List<Widget>();
    for(int i =0; i<12; i++){
      bloop.add(buttonState(controlBoard[i]));
    }
    return GridView.count(
        primary: false,
        padding: EdgeInsets.fromLTRB(10, 40, 10, 40),
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        children: bloop
    );
  }

  _update() {
    Timer.periodic(Duration(milliseconds: 1000), (Timer t) => _randomState());
  }

  _randomState(){
    timeDifficulty++;
    Random random = new Random();
    setState(() {
      for(int i = 0; i < 12; i++) {
        if(random.nextInt(200) < timeDifficulty) {
          controlBoard[i]._increaseState();
        }
      }
    });
  }

 Widget buttonState(MeltdownButton button){
    return RaisedButton(
        color: button.colorList[button.state],
        highlightColor: Colors.green,
        child: new Text(button.textList[button.state]),
        onPressed: (){
          setState(() {
            button._decreaseState();
          });
          print(button.state);
        },
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
    );

  }

}

class MeltdownButton{
  int state;
  List colorList = new List();
  List textList = new List();
  Icon buttonIcon;
  MeltdownButton(){
    state = 0;
    colorList = [Colors.green, Colors.deepOrange, Colors.red];
    textList = ["Safe", "Caution", "Danger"];
    buttonIcon = Icon(Icons.adjust, color: colorList[state], size: 100,);
  }
  _increaseState(){
    if(state < 2){
      state++;
    }
  }

  _decreaseState(){
    if(state>0){
      state--;
    }
  }
}
