import 'package:ProjectLocus/components/UserListView.dart';
import 'package:ProjectLocus/components/namecard.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/utils/DBUtils.dart';
import 'package:ProjectLocus/utils/NetworkUtils.dart';
import 'package:flutter/material.dart';

class Favourites extends StatefulWidget{

  @override 
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites>{
  List<Profile> favourites;
  List<Profile> hasAccess;
  Map<String,String> currentUser;

  @override
  void initState() {
    currentUser = AuthUtils.getCurrentUser();
    super.initState();
  }

  Future<List<Profile>> initialize() async {
    hasAccess = await NetworkUtils.getHasAccess(currentUser["email"].toString());
    return await DBUtils.getFavourites();
  }

  void addFavourites() {
    
  }

  @override 
  Widget build(BuildContext context){
    return FutureBuilder(
      future: DBUtils.getFavourites(),
      builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        favourites = snapshot.data;
        return Scaffold(
          body: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 15, right: 15, bottom: 5),
            margin: EdgeInsets.only(top:15),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height*0.2,
                  decoration: BoxDecoration(
                    color: Color(0xff212121),
                    border: Border(bottom: BorderSide(color: Color(0xff33ffcc)))
                  ),
                  child: Text("Your Favourites", style: TextStyle(fontSize: 20),),
                ),
                (favourites != null && favourites.isNotEmpty) ? UserListView(favourites, (Profile user){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => NameCard(user.name, user.email, user.bio),
                    barrierDismissible: true
                  );
                }) : Center(
                  child: Text("It looks like you haven't added any favourites"),
                )
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff33ffcc),
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: null,
          ),
        );
      }
    );
  }
}