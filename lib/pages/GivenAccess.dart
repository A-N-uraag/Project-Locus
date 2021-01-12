import 'dart:math';

import 'package:ProjectLocus/components/UserListView.dart';
import 'package:ProjectLocus/components/UserSearch.dart';
import 'package:ProjectLocus/components/namecard.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:flutter/material.dart';
import '../utils/NetworkUtils.dart';

class GivenAccess extends StatefulWidget {
  static final instance = GivenAccess._internal();

  GivenAccess._internal();

  factory GivenAccess(){
    return instance;
  }

  @override
  _GivenAccessState createState() => _GivenAccessState();
}

class _GivenAccessState extends State<GivenAccess> {
  List<Profile> givenAccessList;
  var userMail = AuthUtils.getCurrentUser();
  List<Profile> allUsers;
  Map<String,String> currentUser;

  Future<List<Profile>> initialize() async {
    allUsers = await NetworkUtils.getAllUsers();
    return await NetworkUtils.getGivenAccess(userMail);
  }

  void manageGivenAccess(BuildContext context) async {
    /*List<String> addedUsers = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        contentPadding: EdgeInsets.all(10),
        title: Text("Give or Revoke access"),
        content: UserSearch(givenAccessList)
      ),
      barrierDismissible: true
    );*/
    List<String> addedUsers = await showModalBottomSheet(
      context: context, 
      builder: (BuildContext context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text("Give or Revoke access", style: TextStyle(color: Colors.white, fontSize: 20),),
            ),
            UserSearch(givenAccessList)
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
      isDismissible: true,
      isScrollControlled: true,
    );
    if(addedUsers != null){
      String currentUser = AuthUtils.getCurrentUser();
      Map<String,Profile> addedProfiles = await NetworkUtils.getPublicProfiles(addedUsers);
      await NetworkUtils.saveGivenAccess(currentUser, addedUsers);
      this.setState(() {
        givenAccessList = addedProfiles.values.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text("Users with access to your Location", style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: initialize(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Container(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              )
            );
          givenAccessList = snapshot.data;
          return Container(
            padding: EdgeInsets.only( top: MediaQuery.of(context).padding.top,
              left: 15, right: 15, bottom: 5
            ),
            child: (givenAccessList != null && givenAccessList.isNotEmpty) ? UserListView(
              givenAccessList, 
              (Profile user) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => NameCard(user.name, user.email, user.bio),
                  barrierDismissible: true
                );
              },
            ): Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 35),
                    width: MediaQuery.of(context).size.width*0.6,
                    height: MediaQuery.of(context).size.width*0.6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff212121),
                      boxShadow: [                
                        BoxShadow(
                          color: Colors.blue.withAlpha(125),
                          blurRadius: 45,
                          spreadRadius: 15,
                          offset: Offset(0, 0),
                        )                       
                      ]
                    ),
                    child: Image(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/inco.png'),
                    ),
                  ),
                  Text("It looks like you don't wanna be seen! Whatcha doin'?", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                ],
              )
            )
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
        label: Text(
          "Manage",
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () => manageGivenAccess(context),
      ),
    );
  }
}
