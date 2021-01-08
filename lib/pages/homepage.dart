import 'dart:math';

import 'package:ProjectLocus/pages/MapsPage.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => MapsPage(["loneelf123@gmail.com"])
                ));
              },
            ),
            FloatingActionButton(
              heroTag: Random().nextInt(1000),
              child: Icon(Icons.favorite_outline_sharp),
              backgroundColor: Color(0xff33ffcc),
              onPressed: () async {
                await AuthUtils.signOut();
                Navigator.pop(context);
                print('You tapped on FloatingActionButton');
              },
            ),
          ]
        )
      )
    );
  }
}