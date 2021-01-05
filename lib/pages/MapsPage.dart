import 'dart:async';
import 'package:ProjectLocus/dataModels/Location.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/utils/LocationUtils.dart';
import 'package:ProjectLocus/utils/NetworkUtils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget{
  final List<String> emails;
  MapsPage(this.emails);

  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage>{
  List<String> _emails;
  Position _userLocation;
  Map<String,Profile> _profiles;
  Completer<GoogleMapController> _controller = Completer();

  @override 
  void initState() {
    _emails = widget.emails;
    _profiles = {};
    super.initState();
  }

  Future<Map<String,Location>> getLocations() async {
    _userLocation = await LocationUtils.getLocation();
    Map<String,Location> locations = await NetworkUtils.getLocations(_emails);
    _profiles = await NetworkUtils.getPublicProfiles(_emails);
    return locations;
  }

  Set<Marker>fromMapToSet(Map<String,Location> locations){
    Set<Marker> markers = {};
    locations.forEach((key, value) {
      markers.add(Marker(
        position: LatLng(value.latitude, value.longitude),
        markerId: MarkerId(key),
        infoWindow: InfoWindow(
          title: _profiles[key].name,
          snippet: "Last seen at, " + value.time + " , on " + value.date
        )
      ));
    });
    return markers;
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder(
        future: getLocations(),
        builder: (BuildContext context, AsyncSnapshot<Map<String,Location>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return GoogleMap(
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
            markers: fromMapToSet(snapshot.data),
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
              zoom: 14,
              target: LatLng(_userLocation.latitude, _userLocation.longitude)
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.arrow_back, color: Color(0xff33ffcc),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.person_add, color: Color(0xff33ffcc),), 
              onPressed: () => {}
            ),
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.person_remove,color:Color(0xff33ffcc),), 
              onPressed: null
            ),
             IconButton(
              iconSize: 30,
              icon: Icon(Icons.refresh, color: Color(0xff33ffcc),), 
              onPressed: null
            ),
          ],
        ),
      ),
    );
  }
}