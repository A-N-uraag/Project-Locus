import 'dart:math';

import 'package:ProjectLocus/components/namecard.dart';
import 'package:ProjectLocus/pages/EditProfile.dart';
import 'package:ProjectLocus/pages/EntryOptionsPage.dart';
import 'package:ProjectLocus/pages/UserSignInPage.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
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
          NameCard("bsg","hshs","hh"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              heroTag: Random().nextInt(100),
              onPressed: () {
                // Add your onPressed code here!
              },
              label: Text("Private Mode"),
              icon: Icon(Icons.privacy_tip),
              backgroundColor: Color(0xff33ffcc),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              heroTag: "Edit",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
              },
              label: Text("Edit"),
              icon: Icon(Icons.edit),
              backgroundColor: Color(0xff33ffcc),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: Random().nextInt(10),
        onPressed: () {
          AuthUtils.signOut();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => EntryOptionsPage()), (route) => false);
        },
        label: Text("Log Out"),
        icon: Icon(Icons.logout),
        backgroundColor: Color(0xff33ffcc),
      ),
    );
  }
}
