import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatelessWidget{

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              iconSize: 30,
              padding: EdgeInsets.all(5),
              icon: Icon(Icons.arrow_back, color: Color(0xff999999),), 
              onPressed: () => Navigator.pop(context)
            ),
            IconButton(
              iconSize: 30,
              padding: EdgeInsets.only(top: 5, right: 30, bottom: 5),
              icon: Icon(Icons.location_pin, color: Color(0xff999999),), 
              onPressed: null
            ),
            IconButton(
              iconSize: 30,
              padding: EdgeInsets.only(top: 5, left: 30, bottom: 5),
              icon: Icon(Icons.refresh, color: Color(0xff999999),), 
              onPressed: null
            ),
            IconButton(
              iconSize: 30,
              padding: EdgeInsets.all(5),
              icon: Icon(Icons.person_remove,color:Color(0xff999999),), 
              onPressed: null
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff33ffcc),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      body: GoogleMap(
        markers: {
          Marker(
            position: LatLng(15.4022923, 76.6155665),
            markerId: MarkerId("new"),
            infoWindow: InfoWindow(title: "This a pin", snippet: "This is snippet")
          ),
          Marker(
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            position: LatLng(15.400098, 76.615889),
            markerId: MarkerId("nen"),
            infoWindow: InfoWindow(title: "This a pin 2", snippet: "This is snippet")
          )
        },
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          zoom: 15,
          target: LatLng(15.4022923, 76.6155665)
        ),
      ),
    );
  }
}