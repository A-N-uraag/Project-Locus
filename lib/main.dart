import 'dart:io';

import 'package:ProjectLocus/pages/EntryOptionsPage.dart';
import 'package:ProjectLocus/pages/EmailVerificationPage.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/pages/LocusHome.dart';
import 'package:ProjectLocus/utils/BackgroundUtils.dart';
import 'package:ProjectLocus/utils/LocationUtils.dart';
import 'package:ProjectLocus/utils/NetworkUtils.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Locus());
  BackgroundFetch.registerHeadlessTask(BackgroundUtils.bgFetchCallback);
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

  Future<UserState> initializeApp(BuildContext context) async {
    bool permission = await LocationUtils.checkPermission();
    if(!permission){
      await LocationUtils.getPermission(context);
    }
    await Firebase.initializeApp();
    if(Platform.isAndroid){
      await AndroidAlarmManager.initialize();
      await BackgroundUtils.scheduleAndroidBgTask();
    }
    else{
      await BackgroundUtils.scheduleBgFetchTask();
    }
    final connState = await NetworkUtils.checkConnection();
    if(!connState){
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("No Internet connection"),
          content: Text("Please ensure that you are connected to a network in order use the facilities of this app"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Ok", style: TextStyle(color: Color(0xff33ffcc)),))
          ],
        ),
        barrierDismissible: true,
      );
    }
    return await AuthUtils.getUserState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeApp(context),
      builder: (BuildContext context, AsyncSnapshot<UserState> snapshot){
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: Image(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/locus.jpg'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      child: LinearProgressIndicator(),
                    )
                  ],
                )
              ),
            ),
          );
        }
        switch(snapshot.data){
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