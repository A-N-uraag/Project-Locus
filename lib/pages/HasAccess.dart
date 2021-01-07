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
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text("Users visible to you", style: TextStyle(fontSize: 20),),
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
          List<Profile> content = snapshot.data;
          return Container(
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 15, right: 15, bottom: 5),
              child: (content != null && content.isNotEmpty) ? UserListView(content, (Profile user){
                showDialog(
                  context: context,
                  builder: (BuildContext context) => NameCard(user.name, user.email, user.bio),
                  barrierDismissible: true
                );
              }) : Center(
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
                      child: Text("Looks like none of your friends want to be seen.", style: TextStyle(fontSize: 17, color: Color.fromARGB(250, 0, 227, 229)), textAlign: TextAlign.center,),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      )
    );
  }
}
