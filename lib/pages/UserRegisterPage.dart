import 'dart:math';

import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/utils/DBUtils.dart';
import 'package:ProjectLocus/utils/NetworkUtils.dart';
import 'package:flutter/material.dart';

class UserRegisterPage extends StatefulWidget {

  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegisterPage>{
  final _formKey = GlobalKey<FormState>();
  bool showMsg = false;
  bool showLoader = false;
  Widget msg;
  String _email;
  String _password;
  String _name;
  String _bio;
  String _mobile;

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
                    decoration: InputDecoration(labelText: "Name"),
                    validator: (value){
                      if(value.isEmpty){
                        return "Please enter your name";
                      }
                      return null;
                    },
                    onSaved:(value){
                      _name = value;
                    },
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
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(labelText: "Bio"),
                    validator: (value){
                      if(value.isEmpty || value.length > 300){
                        return "Please write a short bio about yourself";
                      }
                      return null;
                    },
                    onSaved:(value){
                      _bio = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Mobile"),
                    validator: (value){
                      if(value.isEmpty){
                        return "Please enter your mobile number";
                      }
                      return null;
                    },
                    onSaved:(value){
                      _mobile = value;
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: RaisedButton(
                      child: Text("Register", style: TextStyle(color: Colors.black,fontSize: 16),),
                      color: Color(0xff33ffcc),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          FocusScope.of(context).unfocus();
                          this.setState(() {
                            showLoader = true;
                            showMsg = false;
                          });
                          await AuthUtils.registerWithEmail(_email, _password)
                          .then((value) async {
                            OwnerProfile details = OwnerProfile(_name, _email, _bio, _mobile, false);
                            await DBUtils.insertDetails(details);
                            await NetworkUtils.savePublicDetails(details);
                            await NetworkUtils.savePrivateDetails(_email, PrivateDetails(_mobile,[],[]));
                            this.setState(() {
                              showLoader = false;
                              showMsg = true;
                              msg = Text("Successfully registered. A verification mail has been sent to your email id. Please complete the verification to continue.",
                                style: TextStyle(color: Color(0xff33ffcc), fontSize: 16),
                              );
                            });
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