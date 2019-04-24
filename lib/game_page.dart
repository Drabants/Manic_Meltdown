import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver, TickerProviderStateMixin{

  bool gameOver = false;
  List<String> blipList = ["GreenBlip.wav", "YellowBlip.wav", "RedBlip.wav"];
  List<MeltdownButton> controlBoard = new List<MeltdownButton>();
  List colorList = [Colors.greenAccent, Colors.amberAccent, Colors.redAccent];
  int timeDifficulty = 0;
  Timer buttonTimer;
  AnimationController controller;
  static AudioCache player = new AudioCache();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller =
        AnimationController(vsync: this, duration: Duration(hours: 20));
    controller.forward();
    _fillBoard();
    _update();
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    buttonTimer.cancel();
    controller.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state){
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:
        if(!gameOver) {
          _pauseGame();
        }
        break;
      case AppLifecycleState.resumed:
        if(!gameOver) {
          _resumeGame();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.suspending:
        break;
    }
  }
  _pauseGame(){
    controller.stop();
    buttonTimer.cancel();
  }

  _resumeGame(){
    controller.forward();
    _update();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return new Text(
                      timerString,
                      style: TextStyle(
                          fontSize: 60,
                          fontFamily: 'Monofett',
                          color: Colors.white),
                    );
                  }),
              Expanded(child: _generateControlBoard()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _generateControlBoard() {
    List<Widget> controlBoardList = new List<Widget>();
    for (int i = 0; i < 12; i++) {
      controlBoardList.add(_generateButton(controlBoard[i]));
    }
    return GridView.count(
        primary: false,
        padding: EdgeInsets.fromLTRB(10, 40, 10, 40),
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        children: controlBoardList);
  }

  Widget _generateButton(MeltdownButton button) {
    return RaisedButton(
        color: colorList[button.state],
        onPressed: () {
          setState(() {
            player.play(blipList[button.state]);
            button._decreaseState();
          });
        },
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(40.0)));
  }

  _fillBoard() {
    for (int i = 0; i < 12; i++) {
      controlBoard.add(new MeltdownButton());
    }
  }

  _update() {
    buttonTimer = new Timer.periodic(
        Duration(milliseconds: 700), (Timer t) => _updateButtons());
  }

  _updateButtons() {
    print(timeDifficulty);
    timeDifficulty++;
    int checkFailure = 0;
    Random random = new Random();
    setState(() {
      for (int i = 0; i < 12; i++) {
        if (checkFailure >= 5 && buttonTimer.isActive) {
          _gameOver();
        }
        if (controlBoard[i].state > 1) checkFailure++;
        if (((random.nextInt(100))/100) < ((log(timeDifficulty)/10)*.65) && buttonTimer.isActive){
          controlBoard[i]._increaseState();
        }
      }
    });
  }

  _gameOver() {
    gameOver = true;
    timeDifficulty = 0;
    player.play("Explosion.wav");
    controller.stop();
    buttonTimer.cancel();
    _resetAllButtonStates();
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("The Plant Has Had a Meltdown!"),
            content: new Text("Try to keep Danger panels below 5!\n \n Time Lasted: $timerString"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("New Game?"),
                onPressed: () {
                  _resetGame();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _resetAllButtonStates() {
    controlBoard.forEach((element) => element.state = 0);
  }

  _resetGame() {
    gameOver = false;
    controller.reset();
    controller.forward();
    _update();
  }

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}:${(duration.inMilliseconds % 60).toString().padLeft(2, '0')}';
  }
}

class MeltdownButton {
  int state;

  MeltdownButton() {
    state = 0;

  }

  _increaseState() {
    if (state < 2) {
      state++;
    }
  }

  _decreaseState() {
    if (state > 0) {
      state--;
    }
  }
}
