import 'package:ProjectLocus/components/CircularLetterTile.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:flutter/material.dart';

class UserListView extends StatefulWidget{
  final bool isCheckable;
  final List<Profile> users;
  final String emptyListMessage;
  final String submitButtonTitle;
  final void Function(Profile user) onTap;
  final void Function(List<Profile> users, Map<String,bool> selectedEmails) onSubmit;
  final List<Profile> preSelectedUsers;

  UserListView(this.users, this.onTap, {
    this.emptyListMessage = "No users available",
    this.isCheckable = false, this.submitButtonTitle = "Submit" , 
    this.onSubmit, this.preSelectedUsers}
  );

  @override 
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserListView>{
  Map<String,bool> _selectedEmails;
  final _scrollbarController = ScrollController();

  bool isSelected(String email){
    if(widget.isCheckable){
      if(_selectedEmails[email] == true){
        return true;
      }
    }
    return false;
  }

  Widget listTile(Profile user){
    bool isUserSelected = isSelected(user.email);
    return Container(
      margin: EdgeInsets.only(top:3,bottom:4),
      decoration: BoxDecoration(
        border: Border.all(
          color: isUserSelected ? Color(0xff33ffcc):Colors.grey
        ),
        borderRadius: BorderRadius.circular(5)
      ),
      child: ListTile(
        key: Key(user.email),
        title: Text(user.name, style: TextStyle(color: isUserSelected ? Color(0xff33ffcc) : Colors.white),),
        subtitle: Text(user.email,style: TextStyle(color: isUserSelected ? Color(0xff33ffcc) : Colors.white70),),
        leading: CircularLetterTile(user.name,44,25),
        trailing: (widget.isCheckable && isUserSelected) ? Icon(
          Icons.done,
          color: Color(0xff33ffcc),
        ) : null,
        onTap: (){
          widget.onTap(user);
          if(widget.isCheckable){
            bool presentState = _selectedEmails[user.email];
            this.setState(() {
              _selectedEmails[user.email] = !presentState;
            });
          } 
        },
      ),
    );
  }

  @override 
  void initState() {
    _selectedEmails = {};
    widget.users.forEach((profile) => _selectedEmails.addAll({profile.email : false}));
    if(widget.preSelectedUsers != null){
      widget.preSelectedUsers.forEach((profile){
        if(_selectedEmails.containsKey(profile.email)){
          _selectedEmails.addAll({profile.email : true});
        }
      });
    }
    super.initState();
  }

  @override 
  Widget build(BuildContext context){
    return Stack(
      children: [
        (widget.users.isNotEmpty) ? Container(
          margin: EdgeInsets.only(bottom: widget.isCheckable ? 50 : 0),
          child: Scrollbar(
            isAlwaysShown: true,
            controller: _scrollbarController,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 5, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: widget.users.map((user) => listTile(user)).toList(),
              ),
            )
          ),
        ) : Container(
          height: 50,
          margin: EdgeInsets.all(15),
          child: Text(widget.emptyListMessage, style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
        ),
        widget.isCheckable && widget.users.isNotEmpty ? Positioned(
          bottom: 2,
          right: 10,
          child: FloatingActionButton.extended(
            icon: Icon(Icons.done_all),
            backgroundColor: Color(0xff33ffcc),
            label: Text(widget.submitButtonTitle,style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
            onPressed: () => widget.onSubmit(widget.users,_selectedEmails)
          )
        ) : Container(height: 0),
      ],
    );
  } 
}