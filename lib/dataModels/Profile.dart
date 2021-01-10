class Profile{
  String name;
  String email;
  String bio;

  Profile(this.name,this.email,this.bio);

  Profile.fromJson(Map<String,dynamic> json): 
  name = json['name'],
  email = json['email'],
  bio = json['bio'];

  Map<String,dynamic> toJson() => {
    "name" : name,
    "email" : email,
    "bio" : bio
  };
}

class OwnerProfile extends Profile{
  bool isPrivateModeOn;
  String mobile;

  OwnerProfile(
    String name,
    String email,
    String bio, 
    this.mobile, 
    this.isPrivateModeOn
  ) : super(name, email, bio);

  OwnerProfile.fromProfile(Profile user, String mobile):
  mobile = mobile,
  isPrivateModeOn = false,
  super(user.name,user.email,user.bio);

  Profile getProfile(){
    return Profile(name,email,bio);
  }
  

  Map<String,dynamic> toCloudFunctionJson() => {
    "name" : name,
    "email" : email,
    "bio" : bio,
    "mobile": mobile
  };
}

class EmergencyContact{
  String name;
  String email;
  String mobile;

  EmergencyContact.fromJson(Map<String,dynamic> json):
  name = json['name'],
  email = json['email'],
  mobile = json['mobile'];

  Map<String,dynamic> toJson() => {
    "name" : name,
    "email" : email,
    "mobile" : mobile
  };

  EmergencyContact(this.name,this.email,this.mobile);
}

class PrivateDetails{
  String mobile;
  List<String> favourites;
  List<EmergencyContact> emergencyList;

  PrivateDetails(this.mobile,this.favourites,this.emergencyList);

  Map<String,dynamic> toJson() => {
    "mobile": mobile,
    "favourites": favourites,
    "emergency": emergencyList.map((each) => each.toJson()).toList()
  };

  PrivateDetails.fromJson(Map<String,dynamic> json):
  mobile = json['mobile'].toString(),
  favourites = (json['favourites'] as List<dynamic>).map((e) => e.toString()).toList(),
  emergencyList = (json['emergency'] as List<dynamic>).map((each) => EmergencyContact.fromJson(each)).toList();
}