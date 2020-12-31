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

  OwnerProfile(String name,String email,String bio, this.mobile, this.isPrivateModeOn) : super(name, email, bio);

  Map<String,dynamic> toPublicViewJson() => {
    "name" : name,
    "email" : email,
    "bio" : bio,
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