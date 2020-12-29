import 'package:ProjectLocus/profile.dart';
import 'package:ProjectLocus/utils/homepage.dart';
import 'package:ProjectLocus/utils/namecard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Locus());
}

class Locus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Locus',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: LocusNavTabs(),
    );
  }
}
class LocusNavTabs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
              Center( child: Text("Has Access"),),
              Center( child: Text("Favorites")),
              Center( child: Text("Give Access")),
              ProfileView()
            ],
          ),
        ),
        )
      );
  }
}