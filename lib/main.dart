import 'package:ProjectLocus/pages/EntryOptionsPage.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/pages/LocusHome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Locus());
}

class Locus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Locus',
      theme: ThemeData(
        primaryColor: Colors.black,
        brightness: Brightness.dark
      ),
      home: LocusApp(),
    );
  }
}

class LocusApp extends StatelessWidget {

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeFirebase(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(
            body: Center(
              child: Container(
                alignment: Alignment.center,
                child: Text("Welcome to Locus...",style: TextStyle(color: Color(0xff33ffcc),fontSize: 20),),
              ),
            ),
          );
        }
        switch(AuthUtils.getUserState()){
          case UserState.signed_in_and_verified:{
            return LocusHome();
          } 
          case UserState.signed_out:{
            return EntryOptionsPage();
          }
          case UserState.signed_in_not_verified:{
            return Scaffold(
              body: Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff33ffcc)),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Welcome and thanks for using Locus. Your email id verification is pending. Please complete the verification to continue.",
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: RaisedButton(
                          child: Text("Send verification mail",style: TextStyle(color: Colors.black,fontSize: 16),),
                          onPressed: ()async {
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
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }
      }
    );
  }
}