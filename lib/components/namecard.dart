import 'package:flutter/material.dart';

class NameCard extends StatelessWidget {
  final String name;
  final String email;
  final String bio;
  final String mobile;
  NameCard(this.name,this.email,this.bio,{this.mobile = "none"});

  Widget getRowElements(){
    if(mobile == "none"){
      return Container();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(Icons.phone, size: 20, color: Color(0xff33ffcc))
        ), 
        Text(mobile)
      ]
    );
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
                Icon(
                  Icons.account_circle,
                  color: Color(0xff33ffcc),
                  size: 30,
                ),
                Text(name, style: TextStyle(fontSize: 16),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.email, size: 20, color: Color(0xff33ffcc)),
                    ), 
                    Text(email)
                  ]
                ),
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
