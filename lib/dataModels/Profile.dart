class Profile{
  String name;
  String email;
  String bio;
  String dob;
  String mobile;

  Profile(this.name,this.email,this.bio,this.dob,this.mobile);
}

class OwnerProfile extends Profile{
  bool isPrivateModeOn;
  OwnerProfile(String name,String email,String bio, String dob, String mobile,this.isPrivateModeOn) : super(name, email, bio, dob, mobile);
}