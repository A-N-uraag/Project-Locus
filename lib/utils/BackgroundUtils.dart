import 'package:ProjectLocus/dataModels/Location.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/utils/LocationUtils.dart';
import 'package:ProjectLocus/utils/NetworkUtils.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';

class BackgroundUtils{
  static Future<void> scheduleBgLocationTask() async {
    BackgroundFetch.configure(BackgroundFetchConfig(
      minimumFetchInterval: 15,
      stopOnTerminate: false,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.NONE
    ), (String taskId) async {
      print("[BackgroundFetch] Event received $taskId");
      updateLocationInBg(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });
  }

  static void updateLocationInBg(String taskId) async {
    if(await LocationUtils.checkPermission()){
      Position location = await LocationUtils.getLocation();
      await Firebase.initializeApp();
      if( await AuthUtils.getUserState() != UserState.signed_out){
        Map<String,String> user = AuthUtils.getCurrentUser();
        NetworkUtils.saveLocation(
          user['email'].toString(), 
          Location(location.latitude, 
          location.longitude, 
          location.timestamp.hour.toString() +":"+ location.timestamp.minute.toString() +":"+ location.timestamp.second.toString(), 
          location.timestamp.day.toString() +":"+ location.timestamp.month.toString() +":"+ location.timestamp.year.toString())
        );
      }
      print("current position is " + location.latitude.toString() + " " + location.latitude.toString());
    }
    BackgroundFetch.finish(taskId);
  }
}