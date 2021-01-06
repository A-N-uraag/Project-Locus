import 'package:ProjectLocus/components/UserListView.dart';
import 'package:ProjectLocus/components/namecard.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:flutter/material.dart';
import '../utils/NetworkUtils.dart';

class HasAccess extends StatefulWidget {
  @override
  _HasAccessState createState() => _HasAccessState();
}

class _HasAccessState extends State<HasAccess> {
  var userMail;

  @override
  void initState() {
    Map<String,String> userData = AuthUtils.getCurrentUser();
    userMail = userData["email"].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          List<Profile> content = snapshot.data;
          return Container(
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
                  child: Text("Users visible to you", style: TextStyle(fontSize: 20),),
                ),
                (content != null && content.isNotEmpty) ? UserListView(content, (Profile user){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => NameCard(user.name, user.email, user.bio),
                    barrierDismissible: true
                  );
                }) : Center(
                  child: Text("It looks like you do not have acces to anyone's location"),
                )
              ],
            ),
          );
        }
      )
    );
  }
}
