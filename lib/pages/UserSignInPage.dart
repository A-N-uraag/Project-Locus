import 'package:ProjectLocus/pages/EmailVerificationPage.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/pages/LocusHome.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class UserSignInPage extends StatefulWidget {

  @override
  _UserSignInState createState() => _UserSignInState();
}

class _UserSignInState extends State<UserSignInPage>{
  final _formKey = GlobalKey<FormState>();
  bool showMsg = false;
  bool showLoader = false;
  Widget msg;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        heroTag: Random().nextInt(1000),
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.close,
          color:  Color(0xff33ffcc),
        ),
        onPressed: (){Navigator.pop(context);},
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width*0.85,
            decoration: BoxDecoration(
              color: Color(0xFF212121),
              border: Border.all(color: Color(0xff33ffcc),),
              borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            child: Form(
              key: _formKey,
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
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email ID"),
                    validator: (value){
                      if(value.isEmpty){
                        return "Please enter an email id";
                      }
                      return null;
                    },
                    onSaved:(value){
                      _email = value;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                    validator: (value){
                      if(value.isEmpty){
                        return "Please enter a password";
                      }
                      return null;
                    },
                    onSaved:(value){
                      _password = value;
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: RaisedButton(
                      child: Text("Sign In", style: TextStyle(color: Colors.black,fontSize: 16),),
                      color: Color(0xff33ffcc),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          FocusScope.of(context).unfocus();
                          this.setState(() {
                            showLoader = true;
                            showMsg = false;
                          });
                          await AuthUtils.signInWithEmail(_email, _password)
                          .then((value) async {
                            this.setState(() {
                              showLoader = false;
                              showMsg = true;
                              msg = Text("Successfully signed in! Redirecting...",style: TextStyle(color: Color(0xff33ffcc), fontSize: 16),);
                            });
                            if( await AuthUtils.getUserState() == UserState.signed_in_and_verified){
                              Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) =>LocusHome()), 
                                (route) => false
                              );
                            }
                            else {
                              Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) => EmailVerificationPage()), 
                                (route) => false
                              );
                            }
                          })
                          .catchError((e){
                            this.setState(() {
                              showLoader = false;
                              showMsg = true;
                              msg = Text("Oops... " + e.toString() + ". Try again",style: TextStyle(color: Colors.red, fontSize: 16),);
                            });
                          },test: (Object inp){return true;});
                        }
                      }
                    ),
                  ),
                  showMsg ? Container(padding: EdgeInsets.all(10),child: msg,) : Container(),
                  showLoader ? Container(
                    margin: EdgeInsets.all(5),
                    child: LinearProgressIndicator(),
                  ) : Container()
                ],
              )
            )
          ),
        )
      )
    );
  }
}