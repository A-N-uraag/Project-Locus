import 'dart:math';

import 'package:ProjectLocus/components/namecard.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NameCard(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              heroTag: Random().nextInt(1000),
              onPressed: () {
                // Add your onPressed code here!
              },
              label: Text("Private Mode"),
              icon: Icon(Icons.privacy_tip),
              backgroundColor: Color(0xff33ffcc),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: Random().nextInt(1000),
        onPressed: () {
          // Add your onPressed code here!
        },
        label: Text("Edit"),
        icon: Icon(Icons.edit),
        backgroundColor: Color(0xff33ffcc),
      ),
    );
  }
}
