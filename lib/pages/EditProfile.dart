import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/utils/DBUtils.dart';
import 'package:flutter/material.dart';
import '../utils/NetworkUtils.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String userMail = AuthUtils.getCurrentUser()["email"].toString();
  static Profile userUpdated;
  static OwnerProfile user;
  static String mobile;

  Widget myTextField(String label, OwnerProfile user) {
    String hintText;
    switch (label) {
      case "User Name":
        hintText = user.name;
        break;
      case "Email ID":
        hintText = user.email;
        break;
      case "Bio":
        hintText = user.bio;
        break;
      case "Mobile":
        hintText = user.mobile;
        break;
      default:
    }
    var wid = Column(children: [
      Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    label,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          )),
      Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  decoration: InputDecoration(hintText: hintText),
                  onChanged: (text) {
                    switch (label) {
                      case "User Name":
                        userUpdated.name = text;
                        break;
                      case "Email ID":
                        userUpdated.email = text;
                        break;
                      case "Bio":
                        userUpdated.bio = text;
                        break;
                      case "Mobile":
                        mobile = text;
                        break;
                      default:
                    }
                  },
                ),
              ),
            ],
          ))
    ]);
    return wid;
  }

  Widget edit(user) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          myTextField("User Name", user),
          myTextField("Email ID", user),
          myTextField("Bio", user),
          myTextField("Mobile", user)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("Edit your profile"),
            backgroundColor: Colors.grey[850]
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: new FutureBuilder(
                    future: DBUtils.getDetails(),
                    builder: (BuildContext context, AsyncSnapshot<OwnerProfile> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator()
                        );
                      }
                      user = snapshot.data;
                      userUpdated = new Profile(user.name, user.email, user.bio);
                      mobile = user.mobile;
                      return edit(user);
                    }
                  ),
            ),
            FloatingActionButton.extended(
              heroTag: "Edit",
              label: Text("Save"),
              icon: Icon(Icons.save),
              onPressed: () async {
                user = OwnerProfile(userUpdated.name, userUpdated.email, userUpdated.bio, mobile, user.isPrivateModeOn);
                await DBUtils.insertDetails(user);
                await NetworkUtils.savePublicDetails(userUpdated);
                await NetworkUtils.updateMobile(userMail, mobile);
                Navigator.pop(context);
              },
              backgroundColor: Color(0xff33ffcc),
            )
          ])
          ),
        )
      );
  }
}
