import 'dart:io';
import 'dart:async';

import 'package:ProjectLocus/dataModels/Location.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/utils/DBUtils.dart';
import 'package:ProjectLocus/utils/LocationUtils.dart';
import 'package:ProjectLocus/utils/NetworkUtils.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class BackgroundUtils {

  static Future<void> scheduleBgFetchTask() async {
    BackgroundFetch.configure(BackgroundFetchConfig(
      minimumFetchInterval: 15,
      stopOnTerminate: false,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.ANY,
      forceAlarmManager: true
    ), (String taskId) async {
      print("[BackgroundFetch] Event received $taskId");
      bgFetchCallback(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });
  }

  static void bgFetchCallback(String taskId) async {
    await bgLocationUpdate();
    BackgroundFetch.finish(taskId);
  }

  static Future<void> bgLocationUpdate() async {
    if(await LocationUtils.checkPermission()){
      Position location = await LocationUtils.getLocation();
      bool conn = await NetworkUtils.checkConnection();
      print("conn:" + conn.toString());
      if(conn){
        await Firebase.initializeApp();
        if( await AuthUtils.getUserState() == UserState.signed_in_and_verified){
          OwnerProfile user = await DBUtils.getDetails();
          if(!user.isPrivateModeOn){
            String user = AuthUtils.getCurrentUser();
            NetworkUtils.saveLocation(
              user, 
              Location(location.latitude, 
              location.longitude, 
              location.timestamp.toLocal().hour.toString() +":"+ location.timestamp.toLocal().minute.toString() +":"+ location.timestamp.toLocal().second.toString(), 
              location.timestamp.toLocal().day.toString() +":"+ location.timestamp.toLocal().month.toString() +":"+ location.timestamp.toLocal().year.toString())
            );
          }
        }
      }
    }
    print("Loc update");
  }

  static alarmManagerCallback() async {
    await AndroidAlarmManager.initialize();
    await scheduleAndroidBgTask();
    await bgLocationUpdate();
  }

  static Future<void> scheduleAndroidBgTask() async {
    DateTime datetime  = DateTime.now();
    await AndroidAlarmManager.oneShotAt(
      datetime.add(Duration(minutes: 15)), 
      100000, 
      alarmManagerCallback,
      allowWhileIdle: true,
      exact: true,
      rescheduleOnReboot: true,
      wakeup: true,
    );
  }

  static Future<bool> cancelAndroidBgTask() async {
    return await AndroidAlarmManager.cancel(100000);
  }
}