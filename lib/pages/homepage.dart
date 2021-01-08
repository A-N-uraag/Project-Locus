import 'package:ProjectLocus/components/buttonIcon.dart';
import 'package:ProjectLocus/pages/MapsPage.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> userMails = [AuthUtils.getCurrentUser()["email"].toString()];
    return Container(
      
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Hey! Find your friends over here!",), 
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/locusLite.jpg'),
                      ),
            ),
            VisitMap(userMails),
            VisitFavourites(),
          ]
        )
      )
    );
  }
}

class VisitFavourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            spreadRadius: 15,
            offset: Offset(0, 0),
          )                       
        ],
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.purple,
          Colors.greenAccent
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: Color(0xff33ffcc)), borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}

class VisitMap extends StatelessWidget {

  final List<String> userMails;

  VisitMap(this.userMails);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => MapsPage(userMails)
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
          Colors.purple,
          Colors.greenAccent
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: Color(0xff33ffcc)), borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.black),
      ),
    );
  }
}