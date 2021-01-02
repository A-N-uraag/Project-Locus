import 'package:ProjectLocus/pages/UserRegisterPage.dart';
import 'package:ProjectLocus/pages/UserSignInPage.dart';
import 'package:flutter/material.dart';

class EntryOptionsPage extends StatelessWidget{

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color(0xFF212121),
            border: Border.all(color: Color(0xff33ffcc)),
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          width: MediaQuery.of(context).size.width*0.85,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.9,
                child: Image(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/locus.jpg'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 25),
                child: Text("Welcome to Locus", style: TextStyle(fontSize: 24),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    color: Color(0xff33ffcc),
                    textColor: Colors.black,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UserRegisterPage()));
                    },
                    child: Text("REGISTER",style: TextStyle(fontSize: 16),),
                  ),
                  RaisedButton(
                    color: Color(0xff33ffcc),
                    textColor: Colors.black,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UserSignInPage()));
                    },
                    child: Text("SIGN IN", style: TextStyle(fontSize: 16),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}