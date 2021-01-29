import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';


class LocationUtils{

  static Future<bool> canAccessLocationInBg() async {
    return await Geolocator.checkPermission() == LocationPermission.always;
  }

  static Future<bool> isLocationEnabled() async {
    final permission = await Geolocator.checkPermission();
    return  permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  static Future<Position> getLocation() async {
    final permission = await Geolocator.checkPermission();
    if ( permission == LocationPermission.always || permission == LocationPermission.whileInUse){
      return await Geolocator.getCurrentPosition();
    }
    else{
      return Future.error('The required location permissions are absent or some thing is wrong');
    }
  }

  static Future<Position> getLocationInBg() async {
    final permission = await Geolocator.checkPermission();
    if ( permission == LocationPermission.always){
      return await Geolocator.getCurrentPosition();
    }
    else{
      return await Geolocator.getLastKnownPosition();
    }
  }

  static Future<void> getPermission(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Color(0xff303030),
        title: Text("Requesting location access"),
        content: Text("This app collects location data to enable the location sharing feature of the app, even when the app is closed or not in use. Please permit the app to always be able to access the device location (even in background)"),
        actions: [
          TextButton(
            onPressed: () async {
              const url = 'https://anuragreddy2000.github.io/LocusPolicy/';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }, 
            child: Text("Privacy policy", style: TextStyle(color: Color(0xff33ffcc)),)
          ),
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text("Ok", style: TextStyle(color: Color(0xff33ffcc)),)
          )
        ],
      ),
      barrierDismissible: false,
    );
    LocationPermission permission = await Geolocator.requestPermission();
    while(permission == LocationPermission.denied){
      print("pfft");
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Location Access request", style: TextStyle(color: Color(0xff33ffcc)),),
          content: Text("This app needs to access the device location. Please permit the app to always be able to access the device location (even in background)."),
          actions: [
            FlatButton(
              onPressed: () async {
                permission = await Geolocator.checkPermission();
                Navigator.pop(context);
              }, 
              child: Text("Reload",style: TextStyle(color: Color(0xff33ffcc)))
            ),
            FlatButton(onPressed: () async {
              permission = await Geolocator.requestPermission();
              Navigator.pop(context);
            }, child: Text("Give access",style: TextStyle(color: Color(0xff33ffcc))))
          ],
          backgroundColor: Color(0xff212121),
        ),
        barrierDismissible: false
      );
    }
    while(permission == LocationPermission.deniedForever){
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Location Access request", style: TextStyle(color: Color(0xff33ffcc)),),
          content: Text("This app needs to access the device location even in background. Please enable the required permissions to proceed"),
          actions: [
            FlatButton(
              onPressed: () async {
                permission = await Geolocator.checkPermission();
                Navigator.pop(context);
              }, 
              child: Text("Reload",style: TextStyle(color: Color(0xff33ffcc)))
            ),
            FlatButton(
              onPressed: () async {
                await Geolocator.openAppSettings();
                Navigator.pop(context);
              }, 
              child: Text("Go to Settings",style: TextStyle(color: Color(0xff33ffcc)))
            )
          ],
          backgroundColor: Color(0xff212121),
        ),
        barrierDismissible: false
      );
    }
  }
}