import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/pages/LocusHome.dart';
import 'package:flutter/material.dart';

class UserEntryPage extends StatefulWidget {
  final String entryType;
  UserEntryPage(this.entryType);

  @override
  _UserEntryState createState() => _UserEntryState();
}

class _UserEntryState extends State<UserEntryPage>{
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
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.close,
          color:  Color(0xff33ffcc),
        ),
        onPressed: (){Navigator.pop(context);},
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width*0.85,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white,),
            borderRadius: BorderRadius.all(Radius.circular(5.0))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  (widget.entryType == 'Register') ? "Register as new user" : "Sign In to your account", 
                  style: TextStyle(fontSize: 22)
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                        child: Text(widget.entryType=='Register' ? "Register" : "Sign In", style: TextStyle(color: Colors.black,fontSize: 16),),
                        color: Color(0xff33ffcc),
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if(widget.entryType == 'Register'){
                              this.setState(() {showLoader = true;});
                              await AuthUtils.registerWithEmail(_email, _password)
                              .whenComplete(() => this.setState(() {
                                showLoader = false;
                              }))
                              .then((value){
                                this.setState(() {
                                  showMsg = true;
                                  msg = Text("Successfully registered. A verification mail has been sent to your email id. Please complete the verification to continue.",style: TextStyle(color: Color(0xff33ffcc), fontSize: 16),);
                                });
                              })
                              .catchError((e){
                                this.setState(() {
                                  showMsg = true;
                                  msg = Text("Oops... " + e.toString() + ". Try again",style: TextStyle(color: Colors.red, fontSize: 16),);
                                });
                              },test: (Object inp){return true;});
                            }
                            else if(widget.entryType == 'SignIn'){
                              this.setState(() {
                                showLoader = true;
                              });
                              await AuthUtils.signInWithEmail(_email, _password)
                              .whenComplete(() => this.setState(() {
                                showLoader = false;
                              }))
                              .then((value){
                                this.setState(() {
                                  showMsg = true;
                                  msg = Text("Successfully signed in!",style: TextStyle(color: Color(0xff33ffcc), fontSize: 16),);
                                });
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) =>LocusHome()), 
                                  (Route<dynamic> route) => false
                                );
                              })
                              .catchError((e){
                                this.setState(() {
                                  showMsg = true;
                                  msg = Text("Oops... " + e.toString() + ". Try again",style: TextStyle(color: Colors.red, fontSize: 16),);
                                });
                              },test: (Object inp){return true;});
                            }
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
            ],
          )
        ),
      )
    );
  }
}