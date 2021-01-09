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
  final List<Profile> users;
  MapsPage(this.users);

  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage>{
  String _currentUserEmail; 
  Position _userLocation;
  Map<String,Profile> _profiles;
  Completer<GoogleMapController> _controller = Completer();
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
    List<Profile> newList = await showDialog(
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
      ),
      barrierDismissible: true
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
    String email = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Color(0xff212121),
        title: Text("Go to Location..."),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height*0.8
          ),
          child:  UserListView(
            _profiles.values.toList(), 
            (Profile user) => Navigator.pop(context,user.email),
            emptyListMessage: "There's no one else on the map. Add users first, to move to their location"
          ),
        )
      ),
      barrierDismissible: true
    );
    if(email != null && email.isNotEmpty){
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(LatLng(_locations[email].latitude, _locations[email].longitude)));
    }
  }

  Widget bottomBarButtons(IconData icon, Function onTap){
    return IconButton(
      iconSize: 30,
      icon: Icon(icon, color: Color(0xff33ffcc),), 
      onPressed: () => onTap()
    );
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
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
                _controller.complete(controller);
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
              Icons.arrow_back, 
              (){Navigator.pop(context);}
            ),
            bottomBarButtons(
              Icons.person_search, 
              (){goToPosition(context);}
            ),
            bottomBarButtons(
              Icons.group, 
              (){manageUsers(context);}
            ),
            bottomBarButtons(
              Icons.refresh, 
              (){this.setState(() {});}
            )
          ],
        ),
      ),
    );
  }
}