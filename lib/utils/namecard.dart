import 'package:flutter/material.dart';

class NameCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.black,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('Card tapped.');
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.person, color: Color(0xff33ffcc),),
                Text("User 101"),
                Row(mainAxisAlignment: MainAxisAlignment.center, children:[Icon(Icons.email, size: 20,), Text(" 101@usermail.com")]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(children: [Icon(Icons.phone, size: 20), Text(" 9999999999")]),
                    Row(children: [Icon(Icons.cake, size: 20), Text(" 01-01-0000")]),
                ]),
                Text("This is User's bio")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
