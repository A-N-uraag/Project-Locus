import 'dart:math';

import 'package:ProjectLocus/components/UserListView.dart';
import 'package:ProjectLocus/components/namecard.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/pages/MapsPage.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:flutter/material.dart';
import '../utils/NetworkUtils.dart';

class HasAccess extends StatefulWidget {
  static final _instance = HasAccess._internal();

  HasAccess._internal();

  factory HasAccess(){
    return _instance;
  }

  @override
  _HasAccessState createState() => _HasAccessState();
}

class _HasAccessState extends State<HasAccess> {
  var userMail;
  List<Profile> hasAccess;

  @override
  void initState() {
    String userData = AuthUtils.getCurrentUser();
    userMail = userData;
    super.initState();
  }

  Future<void> locate(BuildContext context, List<Profile> hasAccess) async {
    List<Profile> toLocate = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text("Choose user(s) to locate)", style: TextStyle(color: Colors.white, fontSize: 20),),
            ),
            Container(
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height*0.6,
              ),
              child:  UserListView(
                hasAccess,
                (Profile user) => {},
                isCheckable: true,
                submitButtonTitle: "Locate",
                emptyListMessage: "Your list of accessible users is empty",
                onSubmit: (List<Profile> users, Map<String,bool> selectedUsers){
                  List<Profile> toLocate = [];
                  users.forEach((user) {
                    if(selectedUsers[user.email]){
                      toLocate.add(user);
                    }
                  });
                  Navigator.pop(context,toLocate);
                },
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
      isDismissible: true,
      isScrollControlled: true,
    );
    if(toLocate != null){
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context)=>MapsPage(toLocate)), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text("Users visible to you", style: TextStyle(fontSize: 20),),
        centerTitle: true,
      ),
      body: new FutureBuilder(
        future: NetworkUtils.getHasAccess(userMail),
        builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
          if (!snapshot.hasData){
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
          hasAccess = snapshot.data;
          return Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 15, right: 15, bottom: 5),
            child: (hasAccess != null && hasAccess.isNotEmpty) ? UserListView(
              hasAccess, 
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/blueglobe.png'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width*0.7,
                    child: Text("Looks like none of your friends want to be seen.", style: TextStyle(fontSize: 17,), textAlign: TextAlign.center,),
                  )
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
          Icons.person_pin,
          color: Colors.black,
        ),
        label: Text(
          "Locate",
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () => locate(context,hasAccess),
      ),
    );
  }
}
