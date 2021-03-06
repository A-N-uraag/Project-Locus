import 'dart:math';

import 'package:ProjectLocus/components/namecard.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/pages/EditProfile.dart';
import 'package:ProjectLocus/pages/EntryOptionsPage.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/utils/DBUtils.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  OwnerProfile user;

  Widget currentUserNameCard() {
    return FutureBuilder(
      future: DBUtils.getDetails(),
      builder: (BuildContext context, AsyncSnapshot<OwnerProfile> snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: Container(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
          ));
        user = snapshot.data;
        return NameCard(user.name, user.email, user.bio, mobile: user.mobile);
      },
    );
  }

  Future<bool> signOutConfirmation(BuildContext context) async {
    bool result = await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Confirm log out"),
              content: Text("Are you sure you want to log out?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      "No",
                      style: TextStyle(color: Color(0xff33ffcc)),
                    )),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("Yes", style: TextStyle(color: Color(0xff33ffcc))))
              ],
            ),
        barrierDismissible: true);
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: DBUtils.getDetails(),
        builder: (BuildContext context, AsyncSnapshot<OwnerProfile> snapshot) {
          if (!snapshot.hasData){
            return Center(
              child: Container(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              )
            );
          }
          user = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [                
                        BoxShadow(
                          color: user.isPrivateModeOn ? Colors.purple.withAlpha(125) : Colors.blue.withAlpha(125),
                          blurRadius: 45,
                          spreadRadius: 5,
                          offset: Offset(0, 0),
                        )                       
                      ]
                    ),
                    child: NameCard(user.name, user.email, user.bio, mobile: user.mobile),
                  ),
                  IconButton(
                    padding: EdgeInsets.all(30),
                    icon: Icon(
                      Icons.edit,
                      color: Color(0xff33ffcc),
                    ),
                    onPressed: () async {
                      final hasChanged = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                      if(hasChanged == true){
                        this.setState(() {});
                      }
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  heroTag: Random().nextInt(100),
                  onPressed: () {
                    if(user.isPrivateModeOn){
                      DBUtils.turnOffPrivateMode(user);
                      setState(() {
                        user.isPrivateModeOn = false;
                      });
                    }
                    else{
                      DBUtils.turnOnPrivateMode(user);
                      setState(() {
                        user.isPrivateModeOn = true;
                      });
                    }
                  },
                  label: Text("Turn Private Mode " + (user.isPrivateModeOn ? "Off" : "On")),
                  icon: Icon(Icons.privacy_tip),
                  backgroundColor: Color(0xff33ffcc),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: Random().nextInt(1000),
        onPressed: () async {
          if (await signOutConfirmation(context)) {
            AuthUtils.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => EntryOptionsPage()),
              (route) => false
            );
          }
        },
        label: Text("Log Out"),
        icon: Icon(Icons.logout),
        backgroundColor: Color(0xff33ffcc),
      ),
    );
  }
}
