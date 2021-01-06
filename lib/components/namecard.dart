import 'package:flutter/material.dart';

class NameCard extends StatelessWidget {
  final String name;
  final String email;
  final String bio;
  final String mobile;
  NameCard(this.name,this.email,this.bio,{this.mobile = "none"});

  Widget getRowElements(){
    if(mobile == "none"){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Icon(Icons.email, size: 20,), 
          Text(email)
        ]
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(children: [Icon(Icons.phone, size: 20), Text(mobile)]),
        Row(children:[Icon(Icons.email, size: 20,), Text(email)]),
    ]);
  }

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
            color: Color(0xff212121),
            width: MediaQuery.of(context).size.width / 1.1,
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.person, color: Color(0xff33ffcc),),
                Text(name),
                getRowElements(),
                Text(bio)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
