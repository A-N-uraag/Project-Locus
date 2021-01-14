import 'package:ProjectLocus/components/UserListView.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:ProjectLocus/utils/NetworkUtils.dart';
import 'package:flutter/material.dart';

class UserSearch extends StatefulWidget{
  List<Profile> givenAccess;
  UserSearch(this.givenAccess);

  @override 
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch>{
  bool _showLoader;
  bool _isListReady;
  String _searchName;
  List<Profile> _searchResults;

  @override
  void initState() {
    _showLoader = false;
    _isListReady = false;
    super.initState();
  }

  void getSearchResults(String name) async {
    this.setState(() {
      _showLoader = true;
      _isListReady = false;
      _searchName = name;
    });
    Map<String,Profile> searchResults = await NetworkUtils.searchUsersByName(name);
    setState(() {
      _showLoader = false;
      _isListReady = true;
      _searchResults = searchResults.values.toList();
    });
  }

  @override 
  Widget build(BuildContext context){
    return Container(
      color: Colors.grey[850],
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: "Search Users",
            ),
            validator: (value){
              if(value.isEmpty){
                return "PLease enter a name to search";
              }
              return null;
            },
            onFieldSubmitted: (value){
              getSearchResults(value);
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 10),
            child: Text("Please note that search is case sensitive", style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center,),
          ),
          _showLoader ? LinearProgressIndicator() : Container(height: 0,),
          _isListReady ? ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height*0.5
            ),
            child: UserListView(
              _searchResults,
              (Profile user) => {},
              emptyListMessage: "Sorry... No users satisfy the given input",
              isCheckable: true,
              preSelectedUsers: widget.givenAccess,
              submitButtonTitle: "Save",
              onSubmit: (List<Profile> users, Map<String, bool> selectedUsers){
                List<String> newGivenAccess = [];
                widget.givenAccess.forEach((element) {
                  if(!selectedUsers.containsKey(element.email)){
                    newGivenAccess.add(element.email);
                  }
                });
                users.forEach((element) {
                  if(selectedUsers[element.email]){
                    newGivenAccess.add(element.email);
                  }
                });
                Navigator.pop(context,newGivenAccess);
              },
            ),
          ) : Container(height: 0),
        ],
      ),
    );
  }
}