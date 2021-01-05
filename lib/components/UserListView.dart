import 'package:ProjectLocus/components/CircularLetterTile.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:flutter/material.dart';

class UserListView extends StatefulWidget{
  final bool hasCheckBoxes;
  final List<Profile> users;
  final String submitButtonTitle;
  final void Function(Profile user) onTap;
  final void Function(List<Profile> users, Map<String,bool> selectedEmails) onSubmit;
  final List<Profile> preSelectedUsers;
  UserListView(this.users, this.onTap, {this.hasCheckBoxes = false, this.submitButtonTitle , this.onSubmit, this.preSelectedUsers});

  @override 
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserListView>{
  Map<String,bool> _selectedEmails;

  Widget listTile(Profile user){
    if(widget.hasCheckBoxes){
      return CheckboxListTile(
        value: _selectedEmails[user.email],
        title: Text(user.name),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            Text(user.bio)
          ],
        ),
        isThreeLine: true,
        secondary: CircularLetterTile(user.name,50,25),
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: (bool newValue){
          _selectedEmails[user.email] = newValue;
        }
      );
    }
    return ListTile(
      title: Text(user.name),
      subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            Text(user.bio)
          ],
        ),
      isThreeLine: true,
      leading: CircularLetterTile(user.name,50,25),
      onTap: () => widget.onTap(user),
    );
  }

  @override 
  void initState() {
    _selectedEmails = {};
    widget.preSelectedUsers.map((profile) => _selectedEmails.addAll({profile.email : false}));
    widget.preSelectedUsers.map((profile) => _selectedEmails.addAll({profile.email : true}));
    super.initState();
  }

  @override 
  Widget build(BuildContext context){
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height*0.9
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Divider(),
                padding: EdgeInsets.all(5),
                itemCount: widget.users.length,
                itemBuilder: (BuildContext context, int index){
                  return listTile(widget.users[index]);
                }
              ),
            )
          ),
          widget.hasCheckBoxes ? RaisedButton(
            color: Color(0xff33ffcc),
            child: Text(widget.submitButtonTitle,style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
            onPressed: () => widget.onSubmit(widget.users,_selectedEmails)
          ) : Container()
        ],
      )
    );
  } 
}