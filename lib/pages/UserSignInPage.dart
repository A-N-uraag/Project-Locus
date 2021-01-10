import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/pages/EmailVerificationPage.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/pages/LocusHome.dart';
import 'package:ProjectLocus/utils/DBUtils.dart';
import 'package:ProjectLocus/utils/NetworkUtils.dart';
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

  Widget textFormField(String label){
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      obscureText: label == "Password",
      validator: (value){
        if(value.isEmpty){
          return "Please enter your "+ label.toLowerCase();
        }
        return null;
      },
      onSaved:(value){
        if(label == "Password"){
          _password = value;
        }
        else{
          _email = value;
        }
      },
    );
  }

  Future<void> signIn() async {
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
        Map<String, Profile> publicDetails = await NetworkUtils.getPublicProfiles(<String>[_email]);
        PrivateDetails privateDetails = await NetworkUtils.getPrivateDetails(_email);
        await DBUtils.insertDetails(OwnerProfile.fromProfile(publicDetails[_email], privateDetails.mobile));
        await DBUtils.saveEmergencyList(privateDetails.emergencyList);
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
    },test: (Object inp){
      return true;
    });
  }

  Future<void> resetPassword(BuildContext context) async {
    final key = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Reset Password"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text("Please enter your email id below. A password reset link will be sent to your account."),
              Form(
                key: key,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Email"
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return "Please enter an email id";
                    }
                    return null;
                  },
                  onSaved: (resetEmail) async {
                    this.setState(() {
                      showLoader = true;
                    });
                    await AuthUtils.sendResetPasswordEmail(resetEmail).then((value){
                      this.setState(() {
                        showLoader = false;
                        showMsg = true;
                        msg = Text("Password resent mail sent...",style: TextStyle(color: Color(0xff33ffcc), fontSize: 16),);
                      });
                      Navigator.pop(context);
                    }).catchError((error){
                      this.setState(() {
                        showLoader = false;
                        showMsg = true;
                        msg = Text("Oops... " + error.toString(),style: TextStyle(color: Colors.red, fontSize: 16),);
                      });
                      Navigator.pop(context);
                    },test: (Object inp){return true;});
                  },
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Send verification mail", style: TextStyle(color: Color(0xff33ffcc)),),
            onPressed: (){
              if(key.currentState.validate()){
                key.currentState.save();
              }
            }
          )
        ],
      )
    );
  }

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
                  textFormField("Email ID"),
                  textFormField("Password"),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: Text("Forgot password?", textAlign: TextAlign.end, style: TextStyle(color: Color(0xff33ffcc)),),
                      onPressed: () async {
                        await resetPassword(context);
                      }, 
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: RaisedButton(
                      child: Text("Sign In", style: TextStyle(color: Colors.black,fontSize: 16),),
                      color: Color(0xff33ffcc),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          FocusScope.of(context).unfocus();
                          await signIn();
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