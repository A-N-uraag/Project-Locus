import 'package:flutter/material.dart';
import '../utils/NetworkUtils.dart';

class HasAccess extends StatefulWidget {
  @override
  _HasAccessState createState() => _HasAccessState();
}

class _HasAccessState extends State<HasAccess> {
  List hasAccessList;
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
        future: NetworkUtils.getHasAccess(userMail),
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
                  leading: hasAccessList[index].name,
                  title: hasAccessList[index].email,
                  subtitle: hasAccessList[index].bio,
                  onTap: () {},
                );
            }
          );
        }
      )
    );
  }
}
