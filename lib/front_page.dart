import 'package:flutter/material.dart';
import 'package:meltdown/game_page.dart';



class FrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(0, 150, 0, 100),
            child: FittedBox(child: Text('Manic Meltdown', style: TextStyle(fontSize: 50, color: Colors.white),)),
          ),
          Container(
          alignment: Alignment.center,
          color: Colors.blueGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _selectionButton("New Game", context),
            ],
          ),
        ),
      ]
      ),
    );
  }

  Padding _selectionButton(String title, BuildContext context){
    return Padding(
      padding: EdgeInsets.all(30),
      child: ButtonTheme(
        minWidth: 200,
        child: RaisedButton(
          highlightElevation: 20,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(40.0)),
          onPressed: (){
            if(title == "New Game"){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
            }
          } ,
          color: Colors.greenAccent,
          textColor: Colors.blueGrey,
          child: Text(title, style: TextStyle(fontSize: 25),),
          padding: const EdgeInsets.all(10.0),
        ),
      ),
    );
  }


}
