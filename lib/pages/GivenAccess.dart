import 'package:ProjectLocus/components/UserListView.dart';
import 'package:ProjectLocus/components/namecard.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/utils/DBUtils.dart';
import 'package:flutter/material.dart';
import '../utils/NetworkUtils.dart';

class GivenAccess extends StatefulWidget {
  @override
  _GivenAccessState createState() => _GivenAccessState();
}

class _GivenAccessState extends State<GivenAccess> {
  static List<Profile> givenAccessList;
  var userMail = AuthUtils.getCurrentUser()["email"].toString();
  List<Profile> allUsers;
  Map<String,String> currentUser;

  Future<List<Profile>> initialize() async {
    allUsers = await NetworkUtils.getAllUsers();
    return await NetworkUtils.getGivenAccess(userMail);
  }

  void manageGivenAccess(BuildContext context) async {
    List<String> addedUsers = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Given Access"),
        content: UserListView(
          allUsers, 
          (Profile user) => {},
          isCheckable: true,
          submitButtonTitle: "Add",
          onSubmit: (List<Profile> users, Map<String,bool> selectedUsers){
            List<String> newList = [];
            selectedUsers.forEach((key, value) {if(value){newList.add(key);}});
            print("Hello!");
            Navigator.pop(context,newList);
            print("Hello!");
          },
          preSelectedUsers: givenAccessList,
        ),
      ),
      barrierDismissible: true
    );
    if(addedUsers != null){
      Map<String,String> currentUser = AuthUtils.getCurrentUser();
      Map<String,Profile> addedProfiles = await NetworkUtils.getPublicProfiles(addedUsers);
      givenAccessList = addedProfiles.values.toList();
      await DBUtils.saveFavourites(givenAccessList);
      await NetworkUtils.saveFavourites(currentUser["email"].toString(), addedUsers);
      this.setState(() {});
    }
  }


  Widget givenAccessBody() {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: Text("Given Access List", style: TextStyle(fontSize: 20))),
      body: Container(
        child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 15,
                right: 15,
                bottom: 5),
            margin: EdgeInsets.only(top: 15),
            child: (givenAccessList != null && givenAccessList.isNotEmpty)
                ? UserListView(givenAccessList, (Profile user) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            NameCard(user.name, user.email, user.bio),
                        barrierDismissible: true);
                  })
                : Center(
                    child: Text(
                        "It looks like you don't wanna be seen! Whatcha doin'?"),
                  )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
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

  Widget getGivenAccessList() {
    if (givenAccessList == null) {
      var component = new FutureBuilder(
          future: initialize(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: Container(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              ));
            givenAccessList = snapshot.data;
            return givenAccessBody();
          });
      return component;
    } else {
      return givenAccessBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getGivenAccessList());
  }
}
