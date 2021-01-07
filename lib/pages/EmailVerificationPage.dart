import 'dart:math';

import 'package:ProjectLocus/pages/EntryOptionsPage.dart';
import 'package:ProjectLocus/pages/LocusHome.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:flutter/material.dart';

class EmailVerificationPage extends StatelessWidget{

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        heroTag: Random().nextInt(1000),
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.refresh,
          color: Color(0xff33ffcc),
        ),
        onPressed: () async {
          if(await AuthUtils.getUserState() == UserState.signed_in_and_verified){
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (context) =>LocusHome()), 
              (route) => false
            );
          }
        },
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width*0.85,
              decoration: BoxDecoration(
                color: Color(0xFF212121),
                border: Border.all(color: Color(0xff33ffcc)),
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    child: Image(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/locus.jpg'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text("Welcome " + AuthUtils.getCurrentUser()["name"].toString() + " and thank you for using Locus. Your email id verification is pending. Please complete the verification to continue.",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top:15),
                    child: RaisedButton(
                      color: Color(0xff33ffcc),
                      child: Text("Send verification mail again",style: TextStyle(color: Colors.black,fontSize: 16),),
                      onPressed: () async {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Sending verification mail..."),
                        ));
                        await AuthUtils.sendEmailVerification();
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Email sent. Please verify to continue."),
                        ));
                      }
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: RaisedButton(
                      color: Color(0xff33ffcc),
                      child: Text("Sign out",style: TextStyle(color: Colors.black,fontSize: 16),),
                      onPressed: () async {
                        await AuthUtils.signOut();
                        Navigator.pushAndRemoveUntil(context, 
                          MaterialPageRoute(builder: (context) =>EntryOptionsPage()), 
                          (route) => false
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        }
      )
    );
  }
}