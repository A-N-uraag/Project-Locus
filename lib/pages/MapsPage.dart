import 'dart:async';
import 'package:ProjectLocus/components/UserListView.dart';
import 'package:ProjectLocus/dataModels/Location.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
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
  String _currentUserEmail; 
  List<String> _emails;
  Position _userLocation;
  Map<String,Profile> _profiles;
  Completer<GoogleMapController> _controller = Completer();
  List<Profile> _hasAccessList;
  Map<String,Location> locations;

  @override 
  void initState() {
    _emails = widget.emails;
    _profiles = {};
    _hasAccessList = [];
    _currentUserEmail = AuthUtils.getCurrentUser()["email"];
    locations = {};
    super.initState();
  }

  Future<Map<String,Location>> getLocations() async {
    _userLocation = await LocationUtils.getLocation();
    locations = {};
    _profiles = {};
    if(_emails != null){
      locations = await NetworkUtils.getLocations(_emails);
      _profiles = await NetworkUtils.getPublicProfiles(_emails);
    }
    if(_hasAccessList.isEmpty){
      _hasAccessList = await NetworkUtils.getHasAccess(_currentUserEmail);
      if(_hasAccessList == null){
        _hasAccessList = [];
      }
    }
    return locations;
  }

  Set<Marker>getMarkersfromLocations(Map<String,Location> locations){
    Set<Marker> markers = {};
    if(locations != null && locations.isNotEmpty){
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
    }
    return markers;
  }

  Future<void> manageUsers(BuildContext context) async {
    List<String> newList = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Color(0xff212121),
        title: Text("Add or remove people from the map"),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height*0.8
          ),
          child:  UserListView(
            _hasAccessList, 
            (Profile user) => {},
            isCheckable: true,
            submitButtonTitle: "Save",
            preSelectedUsers: _profiles.values.toList(),
            onSubmit: (List<Profile> users, Map<String,bool> selectedUsers){
              List<String> newList = [];
              selectedUsers.forEach((key, value) {if(value){newList.add(key);}});
              Navigator.pop(context,newList);
            },
          ),
        )
      ),
      barrierDismissible: true
    );
    if(newList != null){
      setState(() {
        _emails = newList;
      });
    }
  }

  void goToPosition(BuildContext context) async {
    String email = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Color(0xff212121),
        title: Text("Move to Location..."),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height*0.8
          ),
          child:  UserListView(
            _profiles.values.toList(), 
            (Profile user) => Navigator.pop(context,user.email)
          ),
        )
      ),
      barrierDismissible: true
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(LatLng(locations[email].latitude, locations[email].longitude)));
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
          return Container(
            padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top),
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
              },
              markers: getMarkersfromLocations(snapshot.data),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                zoom: 14,
                target: LatLng(_userLocation.latitude, _userLocation.longitude)
              ),
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
              icon: Icon(Icons.person_pin, color: Color(0xff33ffcc),), 
              onPressed: (){
                goToPosition(context);
              },
            ),
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.group, color: Color(0xff33ffcc),), 
              onPressed: (){
                manageUsers(context);
              }
            ),
             IconButton(
              iconSize: 30,
              icon: Icon(Icons.refresh, color: Color(0xff33ffcc),), 
              onPressed: ()=>this.setState(() {})
            ),
          ],
        ),
      ),
    );
  }
}