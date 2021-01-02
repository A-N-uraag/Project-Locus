import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:flutter/material.dart';
import '../utils/NetworkUtils.dart';

class GivenAccess extends StatefulWidget {
  @override
  _GivenAccessState createState() => _GivenAccessState();
}

class _GivenAccessState extends State<GivenAccess> {
  static List<Profile> givenAccessList;
  var userMail = "trial1";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getGivenAccessList() {
    if (givenAccessList == null) {
      var component = new FutureBuilder(
        future: NetworkUtils.getGivenAccess(userMail),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          givenAccessList = snapshot.data;
          return new ListView.builder(
            scrollDirection: Axis.vertical,
            padding: new EdgeInsets.all(6.0),
            itemCount: givenAccessList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(givenAccessList[index].name),
                subtitle: Text(givenAccessList[index].email),
                onTap: () {},
              );
            }
          );
        }
      );
      return component;
    }
    else {
      return new ListView.builder(
          scrollDirection: Axis.vertical,
          padding: new EdgeInsets.all(6.0),
          itemCount: givenAccessList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(givenAccessList[index].name),
              subtitle: Text(givenAccessList[index].email),
              onTap: () {},
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getGivenAccessList());
  }
}
