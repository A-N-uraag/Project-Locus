import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationUtils{

  static Future<bool> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.always){
      return true;
    }
    else return false;
  }

  static Future<Position> getLocation() async {
    if (await checkPermission()){
      return await Geolocator.getCurrentPosition();
    }
    else{
      return Future.error('The required location permissions are absent or some thing is wrong');
    }
  }

  static Future<void> getPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.always && permission != LocationPermission.deniedForever){
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Location Access request", style: TextStyle(color: Color(0xff33ffcc)),),
          content: Text("This app needs to access the device location even in background. Please enable the required permissions to proceed"),
          actions: [
            FlatButton(
              onPressed: () async {
                if(await checkPermission()){
                  Navigator.pop(context);
                }
              }, 
              child: Text("Reload",style: TextStyle(color: Color(0xff33ffcc)))
            ),
            FlatButton(onPressed: () async {
              permission = await Geolocator.requestPermission();
            }, child: Text("Give access",style: TextStyle(color: Color(0xff33ffcc))))
          ],
          backgroundColor: Color(0xff212121),
        ),
        barrierDismissible: false
      );
    }
    else if (permission == LocationPermission.deniedForever){
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Location Access request", style: TextStyle(color: Color(0xff33ffcc)),),
          content: Text("This app needs to access the device location even in background. Please enable the required permissions to proceed"),
          actions: [
            FlatButton(
              onPressed: () async {
                if(await checkPermission()){
                  Navigator.pop(context);
                }
              }, 
              child: Text("Reload",style: TextStyle(color: Color(0xff33ffcc)))
            ),
            FlatButton(
              onPressed: () async {
                await Geolocator.openAppSettings();
              }, 
              child: Text("Go to Settings",style: TextStyle(color: Color(0xff33ffcc)))
            )
          ],
          backgroundColor: Color(0xff212121),
        ),
        barrierDismissible: false
      );
      print("The app needs to be able to access the location of the device always in order for its serices to work properly. Redirecting to settings");
    }
  }
}