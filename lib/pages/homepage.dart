import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Hey! Find your friends over here!",), 
            FloatingActionButton(
              heroTag: Random().nextInt(1000),
              child: Icon(Icons.map),
              backgroundColor: Color(0xff33ffcc),
              onPressed: (){
                print('You tapped on FloatingActionButton');
              },
              ),
            FloatingActionButton(
              heroTag: Random().nextInt(1000),
              child: Icon(Icons.favorite_outline_sharp),
              backgroundColor: Color(0xff33ffcc),
              onPressed: (){
                print('You tapped on FloatingActionButton');
              },
            ),
          ]
        )
      )
    );
  }
}