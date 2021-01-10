import 'dart:math';

import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/pages/MapsPage.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/utils/NetworkUtils.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  void locateFavourites(BuildContext context) async {
    String email = AuthUtils.getCurrentUser();
    List<String> favouritesEmails = (await NetworkUtils.getPrivateDetails(email)).favourites;
    Map<String,Profile> favourites = await NetworkUtils.getPublicProfiles(favouritesEmails);  
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MapsPage(favourites.values.toList())
      )
    );
  }

  Widget visitFavouritesButton(BuildContext context){
    return InkWell(
      onTap: () => locateFavourites(context),
      child: Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: MediaQuery.of(context).size.height*0.12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //buttonIcon(Icons.favorite_outline_sharp),
            FloatingActionButton.extended(
              heroTag: Random().nextInt(10),
              backgroundColor: Colors.black,
              onPressed: null, 
              icon: Icon(Icons.favorite, color: Color(0xff33ffcc),),
              label: Text("Locate Favourites", style: TextStyle(color: Color(0xff33ffcc)),)
            ),
          ],
        ),
        decoration: BoxDecoration(
          boxShadow: [                
            BoxShadow(
              color: Colors.blue.withAlpha(125),
              blurRadius: 45,
              spreadRadius: 8,
              offset: Offset(1, 0),
            ),
            BoxShadow(
              color: Colors.greenAccent.withAlpha(125),
              blurRadius: 45,
              spreadRadius: 8,
              offset: Offset(0, 1),
            )                       
          ],
          gradient: LinearGradient(colors: [
            Colors.blue,
            Colors.greenAccent
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: Colors.transparent), borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Image(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/locusLite.jpg'),
                      ),
            ),
            Text("Hey! Find your friends over here!", ), 
            VisitMap(),
            visitFavouritesButton(context),
          ]
        )
      )
    );
  }
}

class VisitMap extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => MapsPage([])
        ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: MediaQuery.of(context).size.height*0.12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //buttonIcon(Icons.map),
            FloatingActionButton.extended(
              heroTag: Random().nextInt(10),
              backgroundColor: Colors.black,
              onPressed: null, 
              icon: Icon(Icons.map, color: Color(0xff33ffcc),),
              label: Text("Visit your location", style: TextStyle(color: Color(0xff33ffcc)),)
            )
          ],
        ),
        decoration: BoxDecoration(
          boxShadow: [                
          BoxShadow(
            color: Colors.blue.withAlpha(125),
            blurRadius: 45,
            spreadRadius: 15,
            offset: Offset(0, 0),
          )                       
        ],
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.greenAccent
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: Colors.transparent), borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.black),
      ),
    );
  }
}