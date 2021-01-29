import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/pages/EmailVerificationPage.dart';
import 'package:ProjectLocus/utils/AuthUtils.dart';
import 'package:ProjectLocus/utils/DBUtils.dart';
import 'package:ProjectLocus/utils/NetworkUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class UserRegisterPage extends StatefulWidget {

  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool showMsg = false;
  bool showLoader = false;
  Widget msg;
  String _email;
  String _password;
  String _name;
  String _bio;
  String _mobile;

  String getErrorMsg(String label){
    switch(label){
      case "Name":{
        return "Please enter your name";
      }
      case "Email ID":{
        return "Please enter an email id";
      }
      case "Password":{
        return "Please enter a password";
      }
      case "Bio":{
        return "Please write a short bio about yourself";
      }
      default:{
        return "This field must not be empty";
      }
    }
  }

  TextInputType getKeyboardType(String label){
    switch(label){
      case "Email ID":{
        return TextInputType.emailAddress;
      }
      default:{
        return TextInputType.text;
      }
    }
  }

  Widget textFormField(String label){
    return TextFormField(
      obscureText: label == "Password",
      keyboardType: getKeyboardType(label),
      decoration: InputDecoration(labelText: label),
      validator: (value){
        if(value.isEmpty){
          return getErrorMsg(label);
        }
        return null;
      },
      onChanged: (value){
        if(label == "Password"){
          _password = value;
        }
      },
      onSaved:(value){
        switch(label){
          case "Name":{
            _name = value;
            break;
          }
          case "Email ID":{
            _email = value;
            break;
          }
          case "Password":{
            _password = value;
            break;
          }
          case "Bio":{
            _bio = value;
            break;
          }
        }
      },
    );
  }

  Future<void> registerNewUser(BuildContext context) async {
    this.setState(() {
      showLoader = true;
      showMsg = false;
    });
    await AuthUtils.registerWithEmail(_email, _password)
    .then((value) async {
      OwnerProfile details = OwnerProfile(_name, _email, _bio, _mobile, false);
      await DBUtils.insertDetails(details);
      await NetworkUtils.createNewUserDocs(details);
      this.setState(() {
        showLoader = false;
        showMsg = true;
        msg = Text("Successfully registered. A verification mail has been sent to your email id.",
          style: TextStyle(color: Color(0xff33ffcc), fontSize: 16),
        );
      });
      await Future.delayed(Duration(seconds: 1),);
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (BuildContext context) => EmailVerificationPage()), 
        (route) => false
      );
    })
    .catchError((e){
      this.setState(() {
        showLoader = false;
        showMsg = true;
        msg = Text("Oops... " + e.toString() + ". Try again",style: TextStyle(color: Colors.red, fontSize: 16),);
      });
    },test: (Object inp){return true;});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff303030),
        title: Text("User Registration", style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width*0.85,
            decoration: BoxDecoration(
              color: Color(0xFF303030),
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
                    margin: EdgeInsets.all(5),
                    child: Text("Details", style: TextStyle(fontSize: 22, color: Colors.white), textAlign: TextAlign.center,),
                  ),
                  textFormField("Name"),
                  textFormField("Email ID"),
                  textFormField("Password"),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                    ),
                    obscureText: true,
                    validator: (value){
                      if(value != _password){
                        return "doesn't match the password";
                      }
                      return null;
                    },
                  ),
                  textFormField("Bio"),
                  InternationalPhoneNumberInput(
                    spaceBetweenSelectorAndTextField: 0,
                    initialValue: PhoneNumber(phoneNumber: "", isoCode: "IN", dialCode: "+91"),
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      showFlags: true,
                      backgroundColor: Color(0xff303030),
                    ),
                    inputDecoration: InputDecoration(
                      labelText: "Mobile",
                      helperText: "- required for the emergency service",
                    ),
                    onInputChanged: (PhoneNumber number){},
                    onSaved: (PhoneNumber number){
                      _mobile = number.dialCode.toString() + number.phoneNumber.toString();
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: FloatingActionButton.extended(
                      heroTag: "newuserRegister",
                      label: Text("Register", style: TextStyle(color: Colors.black,fontSize: 16),),
                      backgroundColor: Color(0xff33ffcc),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if(_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          await registerNewUser(context);
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