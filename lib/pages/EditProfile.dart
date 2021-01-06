import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/utils/DBUtils.dart';
import 'package:flutter/material.dart';
import '../utils/NetworkUtils.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String userMail = "mirexal820@cocyo.com";
  static Profile userUpdated;
  static String mobile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget myTextField(String label, Profile user) {
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

  Widget mobileField() {
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
                  new Text("Mobile",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
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
                  decoration: InputDecoration(hintText: mobile),
                  onChanged: (text) {
                    mobile = text;
                  },
                ),
              ),
            ],
          ))
    ]);
    return wid;
  }

  Widget edit() {
    return Form(
      child: Column(
        children: [
          myTextField("User Name", userUpdated),
          myTextField("Email ID", userUpdated),
          myTextField("Bio", userUpdated),
          mobileField()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        )),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new FutureBuilder(
                future: DBUtils.getDetails(),
                builder: (BuildContext context, AsyncSnapshot<OwnerProfile> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(backgroundColor: Colors.black));
                  }
                  userUpdated = snapshot.data.toPublicViewJson() as Profile;
                  mobile = snapshot.data.mobile;
                  return Center(child: edit());
                }),
          ),
          ElevatedButton.icon(
            label: Text("Save"),
            icon: Icon(Icons.save),
            onPressed: () {
              NetworkUtils.savePublicDetails(userUpdated);
              NetworkUtils.updateMobile(userMail, mobile);
              Navigator.pop(context);
            },
          )
        ]));
  }
}
