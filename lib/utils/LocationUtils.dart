import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;

class LocationUtils{

  Future<bool> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.always){
      return true;
    }
    else return false;
  }

  Future<Position> getLocation() async {
    if (await checkPermission()){
      return await Geolocator.getCurrentPosition();
    }
    else{
      return Future.error('The required location permissions are absent');
    }
  }

  void getPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.always && permission != LocationPermission.deniedForever){
      print("The app needs to be able to access the location of the device always in order for its serices to work properly");
      permission = await Geolocator.requestPermission();
    }
    else if (permission == LocationPermission.deniedForever){
      print("The app needs to be able to access the location of the device always in order for its serices to work properly. Redirecting to settings");
      await Geolocator.openAppSettings();
      if(Platform.isAndroid){
        await Geolocator.openLocationSettings();
      }
    }
  }
}