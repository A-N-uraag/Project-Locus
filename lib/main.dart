import 'package:ProjectLocus/pages/EntryOptionsPage.dart';
import 'package:ProjectLocus/pages/EmailVerificationPage.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/pages/LocusHome.dart';
import 'package:ProjectLocus/utils/BackgroundUtils.dart';
import 'package:ProjectLocus/utils/LocationUtils.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Locus());
  BackgroundFetch.registerHeadlessTask(BackgroundUtils.updateLocationInBg);
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
    bool permission = await LocationUtils.checkPermission();
    if(!permission){
      await LocationUtils.getPermission();
    }
    await Firebase.initializeApp();
    await BackgroundUtils.scheduleBgLocationTask();
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
                width: MediaQuery.of(context).size.width*0.85,
                decoration: BoxDecoration(
                  color: Color(0xFF212121),
                  border: Border.all(color: Color(0xff33ffcc)),
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: Image(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/locus.jpg'),
                      ),
                    ),
                    LinearProgressIndicator()
                  ],
                )
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
            return EmailVerificationPage();
          }
        }
      }
    );
  }
}