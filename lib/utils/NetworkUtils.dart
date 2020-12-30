import 'package:ProjectLocus/dataModels/Location.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NetworkUtils{
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Location> getLocation(String email) async {
    DocumentSnapshot result = await firestore.collection("locations").doc(email).get();
    Map<String,dynamic> data = result.data();
    return Location(email, data['latitude'],data['longitude'],data['time'].toString(),data['date'].toString());
  }

  Future<List<Profile>> getHasAccess(String email) async {
    DocumentSnapshot result = await firestore.collection("location_has_access").doc(email).get();
    Map<String,dynamic> data = result.data();
    List<String> userList = data['accessible_users'];
    QuerySnapshot profileList = await firestore.collection("user_details").where('email',arrayContainsAny: userList).get();
    return profileList.docs.map((doc) => Profile(doc['name'].toString(),doc['email'].toString(),doc['bio'].toString(),doc['dob'].toString(),doc['mobile'].toString())).toList();
  }

  Future<List<Profile>> getGivenAccess(String email) async {
    DocumentSnapshot result = await firestore.collection("location_given_access").doc(email).get();
    Map<String,dynamic> data = result.data();
    List<String> userList = data['access_given_users'];
    QuerySnapshot profileList = await firestore.collection("user_details").where('email',arrayContainsAny: userList).get();
    return profileList.docs.map((doc) => Profile(doc['name'].toString(),doc['email'].toString(),doc['bio'].toString(),doc['dob'].toString(),doc['mobile'].toString())).toList();
  }

  Future<List<Profile>> getFavouritesDetails(List<String> emails) async {
    QuerySnapshot profileList = await firestore.collection("user_details").where('email',arrayContainsAny: emails).get();
    return profileList.docs.map((doc) => Profile(doc['name'].toString(),doc['email'].toString(),doc['bio'].toString(),doc['dob'].toString(),doc['mobile'].toString())).toList();
  }

  Future<void> saveGivenAccess(String userEmail,List<String> emails) async {
    return firestore.collection("location_given_access").doc(userEmail).set({"access_given-users" : emails});
  }

  Future<void> saveDetails(OwnerProfile details) async {
    return firestore.collection("user_details").doc(details.email).set({
      "name" : details.name,
      "email": details.email,
      "bio": details.bio,
      "dob": details.dob,
      "mobile": details.mobile
    });
  }

  Future<void> saveLocation(String email, Location location){
    return firestore.collection("locations").doc(email).set({
      "latitude": location.latitude.toString(),
      "longitude": location.longitude.toString(),
      "time": location.time,
      "date": location.date
    });
  }  
}