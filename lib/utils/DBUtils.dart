import 'package:ProjectLocus/dataModels/Location.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:sqflite/sqflite.dart';
import 'DBManager.dart';

class DBUtils{

  static Future<OwnerProfile> getDetails() async {
    Database db = await DBManager().database;
    List<Map<String,dynamic>> result = await db.rawQuery("SELECT * FROM " + DBManager.detailsTable, []);
    Map<String,dynamic> details = result[0];
    return OwnerProfile(
      details[DBManager.detailsName].toString(),
      details[DBManager.detailsEmail].toString(),
      details[DBManager.detailsBio].toString(), 
      details[DBManager.detailsMobile].toString(),
      details[DBManager.detailsPrivateMode].toString()=="true"
    );
  }

  static Future<List<Profile>> getFavourites() async {
    Database db = await DBManager().database;
    List<Map<String,dynamic>> results = await db.rawQuery(
      "SELECT * FROM " + DBManager.favouritesTable, []
    );
    return results.map((result) => Profile(
      result[DBManager.favouritesName].toString(),
      result[DBManager.favouritesEmail].toString(),
      result[DBManager.favouritesBio].toString()
    )).toList();
  }

  static Future<List<Map<String,Location>>> getLocations(List<String> emails) async {
    Database db = await DBManager().database;
    List<Map<String,dynamic>> results = await db.query(
      DBManager.locationsTable, 
      where: '${DBManager.locationsTable} IN (${emails.join(', ')})'
    );
    return results.map((result) => {
      result[DBManager.locationsEmail].toString() : Location(
        result[DBManager.locationsLat],
        result[DBManager.locationsLong],
        result[DBManager.locationsTime].toString(),
        result[DBManager.locationsDate].toString())
    }).toList();
  }

  static Future<List<EmergencyContact>> getEmergencyList() async {
    Database db = await DBManager().database;
    List<Map<String,dynamic>> results = await db.rawQuery("SELECT * FROM " + DBManager.emergencyTable, []);
    return results.map(
      (result) => EmergencyContact(
        result[DBManager.emergencyName].toString(),
        result[DBManager.emergencyEmail].toString(),
        result[DBManager.emergencyMobile].toString()
      )
    ).toList();
  }

  static Future<int> insertDetails(OwnerProfile details) async{
    Map<String,dynamic>detailsEntry = {
      DBManager.detailsEmail : details.email,
      DBManager.detailsName : details.name,
      DBManager.detailsBio : details.bio,
      DBManager.detailsMobile : details.mobile,
      DBManager.detailsPrivateMode : details.isPrivateModeOn.toString()
    };
    Database db = await DBManager().database;
    return await db.insert(DBManager.detailsTable, detailsEntry);
  }

  static Future<int> editDetails(OwnerProfile details) async {
    Database db = await DBManager().database;
    Map<String,dynamic>detailsEntry = {
      DBManager.detailsEmail : details.email,
      DBManager.detailsName : details.name,
      DBManager.detailsBio : details.bio,
      DBManager.detailsMobile : details.mobile,
      DBManager.detailsPrivateMode : details.isPrivateModeOn.toString()
    };
    return await db.update(
      DBManager.detailsTable, 
      detailsEntry,
      where: DBManager.detailsEmail + "= ?", 
      whereArgs: [details.email]
    );
  }

  static Future<int> turnOnPrivateMode(OwnerProfile details) async {
    details.isPrivateModeOn = true;
    return await editDetails(details);
  }

  static Future<int> turnOffPrivateMode(OwnerProfile details) async {
    details.isPrivateModeOn = false;
    return await editDetails(details);
  }

  static Future<int> saveLocation(String email, Location location) async {
    Map<String,dynamic> locationsEntry = {
      DBManager.locationsEmail : email,
      DBManager.locationsLat : location.latitude,
      DBManager.locationsLong : location.longitude,
      DBManager.locationsTime : location.time,
      DBManager.locationsDate : location.date
    };
    Database db = await DBManager().database;
    return await db.insert(
      DBManager.locationsTable, 
      locationsEntry, 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<int> saveFavourite(Profile details) async {
    Database db = await DBManager().database;
    Map<String,dynamic>favouritesEntry = {
      DBManager.favouritesEmail : details.email,
      DBManager.favouritesName : details.name,
      DBManager.favouritesBio : details.bio,
    };
    return await db.insert(
      DBManager.favouritesTable, 
      favouritesEntry, 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<int> removeFavourite(String email) async {
    Database db = await DBManager().database;
    return await db.delete(
      DBManager.favouritesTable, 
      where: DBManager.locationsEmail + "= ?",
      whereArgs: [email]
    );
  }

  static Future<int> saveEmergencyContact(EmergencyContact details) async {
    Database db = await DBManager().database;
    Map<String,dynamic> entry = {
      DBManager.emergencyEmail : details.email,
      DBManager.emergencyName : details.name,
      DBManager.emergencyMobile : details.mobile
    };
    return await db.insert(
      DBManager.emergencyTable, 
      entry, 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<int> removeEmergencyContact(String email) async {
    Database db = await DBManager().database;
    return await db.delete(
      DBManager.emergencyTable, 
      where: DBManager.emergencyEmail + "= ?",
      whereArgs: [email]
    );
  }
}