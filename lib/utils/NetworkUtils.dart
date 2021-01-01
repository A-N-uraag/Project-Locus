import 'package:ProjectLocus/dataModels/Location.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NetworkUtils{
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final _publicDetailsCollection = "user_public_details";
  static final _privateDetailsCollection = "user_private_details";
  static final _hasAccessCollection = "location_has_access";
  static final _givenAccessCollection = "location_given_access";
  static final _locationsCollection = "locations";

  static Future<Map<String,Location>> getLocation(String email) async {
    DocumentSnapshot result = await firestore.collection(_locationsCollection).doc(email).get();
    Map<String,dynamic> data = result.data();
    return {
      email : Location.fromJson(data)
    };
  }

  static Future<List<Profile>> getHasAccess(String email) async {
    DocumentSnapshot result = await firestore.collection(_hasAccessCollection).doc(email).get();
    Map<String,dynamic> data = result.data();
    List<dynamic> userList = data['accessible_users'];
    QuerySnapshot profileList = await firestore.collection(_publicDetailsCollection).where('email',whereIn: userList).get();
    return profileList.docs.map((doc) => Profile.fromJson(doc.data())).toList();
  }

  static Future<List<Profile>> getGivenAccess(String email) async {
    DocumentSnapshot result = await firestore.collection(_givenAccessCollection).doc(email).get();
    Map<String,dynamic> data = result.data();
    List<dynamic> userList = data['access_given_users'];
    QuerySnapshot profileList = await firestore.collection(_publicDetailsCollection).where('email',whereIn: userList).get();
    return profileList.docs.map((doc) => Profile.fromJson(doc.data())).toList();
  }

  static Future<Profile> getPublicProfile(String email) async {
    DocumentSnapshot result = await firestore.collection(_publicDetailsCollection).doc(email).get();
    Map<String,dynamic> data = result.data();
    return Profile.fromJson(data);
  }

  static Future<List<Profile>> getFavouritesDetails(List<String> emails) async {
    QuerySnapshot profileList = await firestore.collection(_publicDetailsCollection).where('email',whereIn: emails).get();
    return profileList.docs.map((doc) => Profile.fromJson(doc.data())).toList();
  }

  static Future<void> saveGivenAccess(String userEmail,List<String> emails) async {
    return firestore.collection(_givenAccessCollection).doc(userEmail).set({"access_given_users" : emails});
  }

  static Future<void> savePublicDetails(OwnerProfile details) async {
    return firestore.collection(_publicDetailsCollection).doc(details.email).set(details.toPublicViewJson());
  }

  static Future<void> savePrivateDetails(String email, PrivateDetails details) async {
    return firestore.collection(_privateDetailsCollection).doc(email).set(details.toJson());
  }

  static Future<void> saveLocation(String email, Location location){
    return firestore.collection(_locationsCollection).doc(email).set(location.toJson());
  }
}