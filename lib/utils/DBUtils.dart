import 'package:ProjectLocus/dataModels/Location.dart';
import 'package:ProjectLocus/dataModels/Profile.dart';
import 'package:sqflite/sqflite.dart';
import 'DBManager.dart';

class DBUtils{

  Future<OwnerProfile> getDetails() async {
    Database db = await DBManager().database;
    List<Map<String,dynamic>> result = await db.rawQuery("SELECT * FROM " + DBManager.detailsTable, null);
    Map<String,dynamic> details = result[0];
    return OwnerProfile(details[DBManager.detailsName].toString(),details[DBManager.detailsEmail].toString(),details[DBManager.detailsBio].toString(),details[DBManager.detailsDOB].toString(),details[DBManager.detailsMobile].toString(),details[DBManager.detailsPrivateMode].toString()=="true");
  }

  Future<List<Profile>> getFavourites() async {
    Database db = await DBManager().database;
    List<Map<String,dynamic>> results = await db.rawQuery("SELECT * FROM " + DBManager.favouritesTable, null);
    return results.map((result) => Profile(result[DBManager.favouritesName].toString(),result[DBManager.favouritesEmail].toString(),result[DBManager.favouritesBio].toString(),result[DBManager.favouritesDOB].toString(),result[DBManager.favouritesMobile].toString())).toList();
  }

  Future<List<Map<String,Location>>> getLocations(List<String> emails) async {
    Database db = await DBManager().database;
    List<Map<String,Location>> locations = [];
    emails.forEach((element) async {
      List<Map<String,dynamic>> results = await db.rawQuery("SELECT * FROM " + DBManager.locationsTable + "WHERE " + DBManager.locationsEmail + "= " + element);
      results.forEach((result) {
        locations.add(
          {
            element : Location(element,result[DBManager.locationsLat],result[DBManager.locationsLong],result[DBManager.locationsTime].toString(),result[DBManager.locationsDate].toString())
          }
        ); 
      });
    });
    return locations;
  }

  Future<int> insertDetails(OwnerProfile details) async{
    Map<String,dynamic>detailsEntry = {
      DBManager.detailsEmail : details.email,
      DBManager.detailsName : details.name,
      DBManager.detailsBio : details.bio,
      DBManager.detailsDOB : details.dob,
      DBManager.detailsMobile : details.mobile,
      DBManager.detailsPrivateMode : details.isPrivateModeOn.toString()
    };
    Database db = await DBManager().database;
    return await db.insert(DBManager.detailsTable, detailsEntry);
  }

  Future<int> editDetails(OwnerProfile details) async {
    Database db = await DBManager().database;
    Map<String,dynamic>detailsEntry = {
      DBManager.detailsEmail : details.email,
      DBManager.detailsName : details.name,
      DBManager.detailsBio : details.bio,
      DBManager.detailsDOB : details.dob,
      DBManager.detailsMobile : details.mobile,
      DBManager.detailsPrivateMode : details.isPrivateModeOn.toString()
    };
    return await db.update(DBManager.detailsTable, detailsEntry,where: DBManager.detailsEmail + "= ?", whereArgs: [details.email]);
  }

  Future<int> turnOnPrivateMode(OwnerProfile details) async {
    details.isPrivateModeOn = true;
    return await editDetails(details);
  }

  Future<int> turnOffPrivateMode(OwnerProfile details) async {
    details.isPrivateModeOn = false;
    return await editDetails(details);
  }

  Future<int> saveLocation(Location location) async {
    Map<String,dynamic> locationsEntry = {
      DBManager.locationsEmail : location.email,
      DBManager.locationsLat : location.latitude,
      DBManager.locationsLong : location.longitude,
      DBManager.locationsTime : location.time,
      DBManager.locationsDate : location.date
    };
    Database db = await DBManager().database;
    return await db.insert(DBManager.locationsTable, locationsEntry, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> saveFavourite(Profile details) async {
    Database db = await DBManager().database;
    Map<String,dynamic>favouritesEntry = {
      DBManager.favouritesEmail : details.email,
      DBManager.favouritesName : details.name,
      DBManager.favouritesBio : details.bio,
      DBManager.favouritesDOB : details.dob,
      DBManager.favouritesMobile : details.mobile,
    };
    return await db.insert(DBManager.favouritesTable, favouritesEntry, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> removeFavourite(String email) async {
    Database db = await DBManager().database;
    return await db.delete(DBManager.favouritesTable, where: DBManager.locationsEmail + "= ?",whereArgs: [email]);
  }

}