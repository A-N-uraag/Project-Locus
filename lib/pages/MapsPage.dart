import 'dart:async';
import 'dart:math';
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
  final List<Profile> users;
  MapsPage(this.users);

  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage>{
  String _currentUserEmail; 
  Position _userLocation;
  Map<String,Profile> _profiles;
  GoogleMapController _controller;
  List<Profile> _hasAccessList;
  Map<String,Location> _locations;
  Set<Marker> _markers;

  @override 
  void initState() {
    _profiles = {};
    widget.users.forEach((profile) { 
      _profiles.addAll({profile.email : profile});
    });
    _hasAccessList = [];
    _currentUserEmail = AuthUtils.getCurrentUser();
    _locations = {};
    super.initState();
  }

  Future<Map<String,Location>> getLocations() async {
    _userLocation = await LocationUtils.getLocation();
    _locations = {};
    if(_profiles != null){
      _locations = await NetworkUtils.getLocations(_profiles.values.map((e) => e.email).toList());
    }
    if(_hasAccessList.isEmpty){
      _hasAccessList = await NetworkUtils.getHasAccess(_currentUserEmail);
      if(_hasAccessList == null){
        _hasAccessList = [];
      }
    }
    _markers = await getMarkersfromLocations(_locations);
    return _locations;
  }

  Future<Set<Marker>> getMarkersfromLocations(Map<String,Location> locations) async {
    Set<Marker> markers = {};
    if(locations != null && locations.isNotEmpty){
      locations.forEach((key, value) async {
        String name = _profiles[key].name;
        String letter = name.toUpperCase()[0];
        markers.add(Marker(
          icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/pins/"+letter+".png"),
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
    List<Profile> newList = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text("Add/Remove people from the map", style: TextStyle(color: Colors.white, fontSize: 20),),
            ),
            Container(
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height*0.6,
              ),
              child: UserListView(
                _hasAccessList, 
                (Profile user) => {},
                emptyListMessage: "Your list of visible users is empty.",
                isCheckable: true,
                submitButtonTitle: "Save",
                preSelectedUsers: _profiles.values.toList(),
                onSubmit: (List<Profile> users, Map<String,bool> selectedUsers){
                  List<Profile> newList = [];
                  users.forEach((user) {
                    if(selectedUsers[user.email]){
                      newList.add(user);
                    }
                  });
                  Navigator.pop(context,newList);
                },
              ),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
      isDismissible: true,
      isScrollControlled: true,
    );
    if(newList != null){
      setState(() {
        _profiles = {};
        newList.forEach((user) {
          _profiles.addAll({user.email : user});
        });
      });
    }
  }

  void goToPosition(BuildContext context) async {
    String email = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height*0.6,
              ),
              child: UserListView(
                _profiles.values.toList(), 
                (Profile user) => Navigator.pop(context,user.email),
                emptyListMessage: "There's no one else on the map. Add users to the map, in order to go to their location"
              ),
            ),
          ],
        )
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
      isDismissible: true,
      isScrollControlled: true
    );
    if(email != null && email.isNotEmpty){
      _controller.animateCamera(CameraUpdate.newLatLng(LatLng(_locations[email].latitude, _locations[email].longitude)));
    }
  }

  Widget bottomBarButtons(IconData icon, String title,Function onTap){
    return Padding(
      padding: EdgeInsets.all(2),
      child: TextButton.icon(
        onPressed: () => onTap(), 
        icon: Icon(icon, color: Color(0xff33ffcc),),
        label: Text(title, style: TextStyle(color: Color(0xff33ffcc)),)
      ),
    );
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: FloatingActionButton(
        mini: true,
        heroTag: Random().nextInt(10000),
        backgroundColor: Color(0xff33ffcc),
        child: Icon(Icons.arrow_back, color: Colors.black, size: 27),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      body: FutureBuilder(
        future: getLocations(),
        builder: (BuildContext context, AsyncSnapshot<Map<String,Location>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Container(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              )
            );
          }
          return Container(
            padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top),
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller){
                _controller = controller;
              },
              markers: _markers,
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
            bottomBarButtons(
              Icons.person_search, "View User",
              (){goToPosition(context);}
            ),
            bottomBarButtons(
              Icons.group, "Add/Remove",
              (){manageUsers(context);}
            ),
            bottomBarButtons(
              Icons.refresh, "Refresh",
              (){this.setState(() {});}
            )
          ],
        ),
      ),
    );
  }
}