import 'package:ProjectLocus/components/buttonIcon.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/pages/MapsPage.dart';
import 'package:ProjectLocus/utils/DBUtils.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  void locateFavourites(BuildContext context) async {
    List<Profile> favourites = await DBUtils.getFavourites();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MapsPage(favourites)
      )
    );
  }

  visitFavouritesButton(BuildContext context){
    return InkWell(
      onTap: () => locateFavourites(context),
      child: Container(
        width: MediaQuery.of(context).size.width*0.55,
        height: MediaQuery.of(context).size.height*0.12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buttonIcon(Icons.favorite_outline_sharp),
          ],
        ),
        decoration: BoxDecoration(
          boxShadow: [                
            BoxShadow(
              color: Colors.blue.withAlpha(125),
              blurRadius: 45,
              spreadRadius: 8,
              offset: Offset(0, 0),
            )                       
          ],
          gradient: LinearGradient(colors: [
            Colors.blue,
            Colors.greenAccent
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: Color(0xff33ffcc)), borderRadius: BorderRadius.all(Radius.circular(10))),
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
            Text("Hey ! ",),
            Text("Find your friends over here!"), 
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
        width: MediaQuery.of(context).size.width*0.55,
        height: MediaQuery.of(context).size.height*0.12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buttonIcon(Icons.map),
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
        border: Border.all(color: Color(0xff33ffcc)), borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.black),
      ),
    );
  }
}