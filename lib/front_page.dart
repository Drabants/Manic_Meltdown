import 'package:flutter/material.dart';
import 'package:meltdown/game_page.dart';



class FrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        centerTitle: true,
        title: Text('Panic Meltdown', style: TextStyle(fontSize: 50),)
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _selectionButton("New Game"),
            _selectionButton("Settings")
          ],
        ),
      ),
    );
  }

  Padding _selectionButton(String title){
    return Padding(
      padding: EdgeInsets.all(30),
      child: ButtonTheme(
        minWidth: 200,
        child: RaisedButton(
          onPressed: (){},
          color: Colors.greenAccent,
          textColor: Colors.blueGrey,
          child: Text(title, style: TextStyle(fontSize: 25),),
          padding: const EdgeInsets.all(10.0),
        ),
      ),
    );
  }
}
