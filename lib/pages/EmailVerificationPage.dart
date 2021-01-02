import 'dart:math';

import 'package:ProjectLocus/pages/EntryOptionsPage.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:flutter/material.dart';

class EmailVerificationPage extends StatelessWidget{

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: Random().nextInt(1000),
        backgroundColor: Color(0xff33ffcc),
        label: Text("Sign out",style: TextStyle(color: Colors.black),),
        onPressed: () async {
          await AuthUtils.signOut();
          Navigator.pushAndRemoveUntil(context, 
            MaterialPageRoute(builder: (context) =>EntryOptionsPage()), 
            (route) => false
          );
        },
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width*0.85,
              decoration: BoxDecoration(
                color: Color(0xFF212121),
                border: Border.all(color: Color(0xff33ffcc)),
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    child: Image(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/locus.jpg'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text("Welcome and thank you for using Locus. Your email id verification is pending. Please complete the verification to continue.",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: RaisedButton(
                      color: Color(0xff33ffcc),
                      child: Text("Send verification mail",style: TextStyle(color: Colors.black,fontSize: 16),),
                      onPressed: () async {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Sending verification mail..."),
                        ));
                        await AuthUtils.sendEmailVerification();
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Email sent. Please verify to continue."),
                        ));
                      }
                    ),
                  )
                ],
              ),
            ),
          );
        }
      )
    );
  }
}