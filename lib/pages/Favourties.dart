import 'dart:math';

import 'package:ProjectLocus/components/UserListView.dart';
import 'package:ProjectLocus/components/namecard.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/utils/NetworkUtils.dart';
import 'package:flutter/material.dart';

class Favourites extends StatefulWidget{
  static final _instance = Favourites._internal();

  Favourites._internal();

  factory Favourites(){
    return _instance;
  } 

  @override 
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites>{
  List<Profile> favourites;
  List<Profile> hasAccess;
  String currentUser;

  @override
  void initState() {
    currentUser = AuthUtils.getCurrentUser();
    super.initState();
  }

  Future<List<Profile>> initialize() async {
    hasAccess = await NetworkUtils.getHasAccess(currentUser);
    List<String> favouritesEmails = (await NetworkUtils.getPrivateDetails(currentUser)).favourites;
    return (await NetworkUtils.getPublicProfiles(favouritesEmails)).values.toList();
  }

  void manageFavourites(BuildContext context) async {
    List<String> addedUsers = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text("Add/Remove Favourites", style: TextStyle(color: Colors.white, fontSize: 20),),
            ),
            Container(
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height*0.6,
              ),
              child: UserListView(
                hasAccess, 
                (Profile user) => {},
                emptyListMessage: "Your list of visible users is empty. You can only add visible users under favourites",
                isCheckable: true,
                submitButtonTitle: "Save",
                onSubmit: (List<Profile> users, Map<String,bool> selectedUsers){
                  List<String> newList = [];
                  selectedUsers.forEach((key, value) {if(value){newList.add(key);}});
                  Navigator.pop(context,newList);
                },
                preSelectedUsers: favourites,
              )
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
      isDismissible: true,
      isScrollControlled: true,
    );
    if(addedUsers != null){
      Map<String,Profile> addedProfiles = await NetworkUtils.getPublicProfiles(addedUsers);
      await NetworkUtils.saveFavourites(currentUser, addedUsers);
      this.setState(() {
        favourites = addedProfiles.values.toList();
      });
    }
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text("Your Favourites", style: TextStyle(fontSize: 20),),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: initialize(),
        builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot){
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
          favourites = snapshot.data;
          return Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 15, right: 15, bottom: 5),
            child: (favourites != null && favourites.isNotEmpty) ? UserListView(
              favourites, 
              (Profile user){
                showDialog(
                  context: context,
                  builder: (BuildContext context) => NameCard(user.name, user.email, user.bio),
                  barrierDismissible: true
                );
              },
            ) : Center(
              child: Column(
              mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    fit: BoxFit.fitWidth,
                        image: AssetImage('assets/favourites.png'),
                  ),
                  Center(child: Text("It looks like you don't have any favourites. Isn't there a special one?", style: TextStyle(fontSize: 17), textAlign: TextAlign.center,)),
                ],
              ),
            ),
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: Random().nextInt(10),
        backgroundColor: Color(0xff33ffcc),
        icon: Icon(
          Icons.group,
          color: Colors.black,
        ),
        label: Text("Manage",style: TextStyle(color: Colors.black,),),
        onPressed: () => manageFavourites(context),
      ),
    );
  }
}