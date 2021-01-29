import 'dart:math';

import 'package:ProjectLocus/pages/EntryOptionsPage.dart';
import 'package:ProjectLocus/pages/LocusHome.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:flutter/material.dart';

class EmailVerificationPage extends StatefulWidget{

  @override 
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerificationPage> with WidgetsBindingObserver{
  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print("resumed");
      this.setState(() {
        showLoader = true;
      });
      await Future.delayed(Duration(seconds: 2));
      final userstate = await AuthUtils.getUserState();
      print(userstate.toString());
      if(userstate == UserState.signed_in_and_verified){
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) =>LocusHome()), 
          (route) => false
        );
      }
      else{
        this.setState(() {
          showLoader = false;
        });
      }
    }
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff303030),
        title: Text("Email Verifcation", style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ), 
            onPressed: () async {
              this.setState(() {
                showLoader = true;
              });
              final userstate = await AuthUtils.getUserState();
              if(userstate == UserState.signed_in_and_verified){
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context) =>LocusHome()), 
                  (route) => false
                );
              }
              else{
                this.setState(() {
                  showLoader = true;
                });
              }
            }
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff33ffcc),
        heroTag: Random().nextInt(1000),
        icon: Icon(
          Icons.logout,
          color: Colors.black,
        ),
        label: Text("Log out", style: TextStyle(color: Colors.black),),
        onPressed: () async {
          this.setState(() {
            showLoader = true;
          });
          final confirm = await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Log out confirmation"),
              content: Text("Do you wigh to log out?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context,true), 
                  child: Text("Yes", style: TextStyle(color: Color(0xff33ffcc)),)
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context,false),  
                  child: Text("No", style: TextStyle(color: Color(0xff33ffcc)),)
                ),
              ],
            )
          );
          if(confirm != null && confirm == true){
            await AuthUtils.signOut();
            Navigator.pushAndRemoveUntil(context, 
              MaterialPageRoute(builder: (context) =>EntryOptionsPage()), 
              (route) => false
            );
          }
          else{
            this.setState(() {
              showLoader = false;
            });
          }
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
                    child: Text("Welcome " + AuthUtils.getCurrentUser() + " and thank you for using Locus. Your email id verification is pending. Please complete the verification to continue.",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top:15, bottom: 10),
                    child: FloatingActionButton.extended(
                      heroTag: 'emailverification',
                      backgroundColor: Color(0xff33ffcc),
                      label: Text("Send verification mail again",style: TextStyle(color: Colors.black,fontSize: 16),),
                      onPressed: () async {
                        this.setState(() {
                          showLoader = true;
                        });
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Sending verification mail...", style: TextStyle(fontWeight: FontWeight.bold),),
                        ));
                        await AuthUtils.sendEmailVerification();
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Email sent. Please verify to continue.", style: TextStyle(fontWeight: FontWeight.bold),),
                        ));
                        this.setState(() {
                          showLoader = false;
                        });
                      }
                    ),
                  ),
                  showLoader ? Container(
                    padding: EdgeInsets.all(10),
                    child: LinearProgressIndicator(),
                  ) : Container(height: 0,)
                ],
              ),
            ),
          );
        }
      )
    );
  }
}