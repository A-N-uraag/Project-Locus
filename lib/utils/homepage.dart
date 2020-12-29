import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
        child: Container(
            // color: Colors.red,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                <Widget>[Text("Hey! Find your friends over here!",), 
                  FloatingActionButton(
                  child: Icon(Icons.map),
                  backgroundColor: Color(0xff33ffcc),
                  onPressed: (){
                    print('You tapped on FloatingActionButton');
                  },
                  ),
                  FloatingActionButton(
                  child: Icon(Icons.favorite_outline_sharp),
                  backgroundColor: Color(0xff33ffcc),
                  onPressed: (){
                    print('You tapped on FloatingActionButton');
                  },
                  ),]
                )
            )
        )
    );
  }
}
