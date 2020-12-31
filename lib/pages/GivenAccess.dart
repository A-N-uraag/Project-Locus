import 'package:flutter/material.dart';
import '../utils/NetworkUtils.dart';

class GivenAccess extends StatefulWidget {
  @override
  _GivenAccessState createState() => _GivenAccessState();
}

class _GivenAccessState extends State<GivenAccess> {
  List GivenAccessList;
  var userMail = "trial1";

  @override
  void initState() {
    super.initState();
  }

  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new FutureBuilder(
        future: NetworkUtils.getGivenAccess(userMail),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (!snapshot.hasData)
            return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black,
                    ),
                  );
          List content = snapshot.data[0];
          return new ListView.builder(
            scrollDirection: Axis.vertical,
            padding: new EdgeInsets.all(6.0),
            itemCount: content.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  leading: GivenAccessList[index].name,
                  title: GivenAccessList[index].email,
                  subtitle: GivenAccessList[index].bio,
                  onTap: () {},
                );
            }
          );
        }
      )
    );
  }
}
