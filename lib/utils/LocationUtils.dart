import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';


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
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Color(0xff303030),
        title: Text("Requesting location access"),
        content: Text("This app collects location data to enable the location sharing feature of the app, even when the app is closed or not in use."),
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
      barrierDismissible: true,
    );
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