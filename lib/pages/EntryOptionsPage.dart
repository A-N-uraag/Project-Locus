import 'package:ProjectLocus/pages/UserEntryPage.dart';
import 'package:flutter/material.dart';

class EntryOptionsPage extends StatelessWidget{

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width*0.85,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 25),
                child: Text("Welcome to Locus", style: TextStyle(color: Color(0xff33ffcc), fontSize: 24),),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Text("Register if you are a new user or Sign In to continue to your account.",style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    color: Color(0xff33ffcc),
                    textColor: Colors.black,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UserEntryPage("Register")));
                    },
                    child: Text("REGISTER",style: TextStyle(fontSize: 16),),
                  ),
                  RaisedButton(
                    color: Color(0xff33ffcc),
                    textColor: Colors.black,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UserEntryPage("SignIn")));
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