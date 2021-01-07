import 'package:ProjectLocus/pages/Favourties.dart';
import 'package:ProjectLocus/pages/GivenAccess.dart';
import 'package:ProjectLocus/pages/HasAccess.dart';
import 'package:ProjectLocus/pages/homepage.dart';
import 'package:ProjectLocus/pages/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocusHome extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
          length: 5,
          child: Theme(
            data: ThemeData(
              brightness: Brightness.dark
            ),
            child: Scaffold(
              bottomNavigationBar: TabBar(
                tabs: [
                    Tab(icon: Icon(Icons.home,), text: "Home",),
                    Tab(icon: Icon(Icons.people), text: "Has Access"),
                    Tab(icon: Icon(Icons.favorite), text: "Favorites"),
                    Tab(icon: Icon(Icons.person_add_alt), text: "Give Access"),
                    Tab(icon: Icon(Icons.settings), text: "Settings"),
                  ],
                unselectedLabelColor: Color(0xff999999),
                labelColor: Color(0xff33ffcc),
                indicatorColor: Colors.transparent
              ),
              body: TabBarView(
                children: [
                  HomePage(),
                  HasAccess(),
                  Favourites(),
                  GivenAccess(),
                  ProfileView()
                ],
              ),
            ),
          )
        );
  }
}