import 'package:ProjectLocus/dataModels/Location.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:io';

class NetworkUtils{
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final _publicDetailsCollection = "user_public_details";
  static final _privateDetailsCollection = "user_private_details";
  static final _hasAccessCollection = "location_has_access";
  static final _givenAccessCollection = "location_given_access";
  static final _locationsCollection = "locations";

  static Future<void> createNewUserDocs(OwnerProfile newUser) async {
    FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
    HttpsCallable callable = functions.httpsCallable('onUserAdd');
    await callable.call(newUser.toCloudFunctionJson());
  }

  static Future<bool> checkConnection() async {
    try{
      final result = await InternetAddress.lookup("bing.com").timeout(const Duration(seconds: 5));
      if (result != null && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch(_){
      return false;
    }
    return false;
  }

  static Future<Map<String,Location>> getLocations(List<String> emails) async {
    Map<String,Location> locations = {};
    if(emails != null && emails.isNotEmpty){
      QuerySnapshot result = await firestore.collection(_locationsCollection).where(FieldPath.documentId, whereIn: emails).get();
      result.docs.forEach((doc) {
        locations.addAll({
          doc.id : Location.fromJson(doc.data())
        });
      });
    }
    return locations;
  }

  static Future<List<Profile>> getHasAccess(String email) async {
    DocumentSnapshot result = await firestore.collection(_hasAccessCollection).doc(email).get();
    Map<String,dynamic> data = result.data();
    List<dynamic> userList = data['accessible_users'];
    List<Profile> profiles = [];
    if(userList != null && userList.isNotEmpty){
      QuerySnapshot docsList = await firestore.collection(_publicDetailsCollection).where('email',whereIn: userList).get();
      profiles = docsList.docs.map((doc) => Profile.fromJson(doc.data())).toList();
    }
    return profiles;
  }

  static Future<List<Profile>> getGivenAccess(String email) async {
    print("Net Req");
    DocumentSnapshot result = await firestore.collection(_givenAccessCollection).doc(email).get();
    Map<String,dynamic> data = result.data();
    List<dynamic> userList = data['access_given_users'];
    List<Profile> profiles = [];
    if(userList != null && userList.isNotEmpty){
      QuerySnapshot docsList = await firestore.collection(_publicDetailsCollection).where('email',whereIn: userList).get();
      profiles = docsList.docs.map((doc) => Profile.fromJson(doc.data())).toList();
    }
    return profiles;
  }

  static Future<Map<String,Profile>> getPublicProfiles(List<String> emails) async {
    Map<String,Profile> profiles = {};
    if(emails != null && emails.isNotEmpty){
      QuerySnapshot result = await firestore.collection(_publicDetailsCollection).where(FieldPath.documentId, whereIn: emails).get();
      result.docs.forEach((doc) {
        profiles.addAll({
          doc.id : Profile.fromJson(doc.data())
        });
      });
    }
    return profiles;
  }

  static Future<Map<String,Profile>> searchUsersByName(String name) async {
    Map<String,Profile> profiles = {};
    if(name != null && name.trim().isNotEmpty){
      QuerySnapshot result = await firestore.collection(_publicDetailsCollection)
        .where('name', isGreaterThanOrEqualTo: name.trim())
        .where('name',isLessThanOrEqualTo: name.trim() + 'zzz').get();
      result.docs.forEach((doc) {
        profiles.addAll({
          doc.id : Profile.fromJson(doc.data())
        });
      });
    }
    return profiles;
  }

  static Future<PrivateDetails> getPrivateDetails(String email) async {
    DocumentSnapshot result = await firestore.collection(_privateDetailsCollection).doc(email).get();
    Map<String,dynamic> data = result.data();
    return PrivateDetails.fromJson(data);
  }

  static Future<List<Profile>> getFavouritesDetails(List<String> emails) async {
    QuerySnapshot profileList = await firestore.collection(_publicDetailsCollection).where('email',whereIn: emails).get();
    return profileList.docs.map((doc) => Profile.fromJson(doc.data())).toList();
  }

  static Future<List<Profile>> getAllUsers() async {
    QuerySnapshot docsList = await firestore.collection(_publicDetailsCollection).get();
    return docsList.docs.map((doc) => Profile.fromJson(doc.data())).toList();
  } 

  static Future<void> saveGivenAccess(String userEmail,List<String> emails) async {
    return firestore.collection(_givenAccessCollection).doc(userEmail).set({"access_given_users" : emails});
  }

  static Future<void> savePublicDetails(Profile details) async {
    return firestore.collection(_publicDetailsCollection).doc(details.email).set(details.toJson());
  }

  static Future<void> savePrivateDetails(String email, PrivateDetails details) async {
    return firestore.collection(_privateDetailsCollection).doc(email).set(details.toJson());
  }

  static Future<void> saveFavourites(String email, List<String> emails) async {
    return firestore.collection(_privateDetailsCollection).doc(email).update({"favourites" : emails});
  }

  static Future<void> saveLocation(String email, Location location){
    return firestore.collection(_locationsCollection).doc(email).set(location.toJson());
  }

  static Future<void> updateMobile(String email, String newMobile) {
    return firestore.collection(_privateDetailsCollection).doc(email).update({"mobile" : newMobile});
  }
}