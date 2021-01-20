import 'dart:async';

import 'package:ProjectLocus/dataModels/Location.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/utils/DBUtils.dart';
import 'package:ProjectLocus/utils/LocationUtils.dart';
import 'package:ProjectLocus/utils/NetworkUtils.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';

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
      bool conn = await NetworkUtils.checkConnection(12);
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
}