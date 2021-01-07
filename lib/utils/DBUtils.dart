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
    Map<String,dynamic> detailsEntry = {
      DBManager.detailsEmail : details.email,
      DBManager.detailsName : details.name,
      DBManager.detailsBio : details.bio,
      DBManager.detailsMobile : details.mobile,
      DBManager.detailsPrivateMode : details.isPrivateModeOn.toString()
    };
    Database db = await DBManager().database;
    return await db.insert(DBManager.detailsTable, detailsEntry, conflictAlgorithm: ConflictAlgorithm.replace);
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
      where: DBManager.favouritesEmail + "= ?",
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

  static Future<int> clearData() async {
    Database db = await DBManager().database;
    await db.delete(DBManager.detailsTable);
    await db.delete(DBManager.favouritesTable);
    return await db.delete(DBManager.emergencyTable);
  }
}