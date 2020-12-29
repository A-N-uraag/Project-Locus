import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class DBManager{
  static final _databaseName = "ProjectLocus.db";
  static final _databaseVersion = 1;

  DBManager._();
  static final DBManager _instance = DBManager._();
  factory DBManager() => _instance;

  static final detailsTable = 'Details';
  static final detailsName = 'Name';
  static final detailsDOB = 'DOB';
  static final detailsBio = 'Bio';
  static final detailsEmail = 'Email';
  static final detailsMobile = 'Mobile';
  static final detailsPrivateMode = 'PrivMode';

  static final favouritesTable = 'Favourites';
  static final favouritesEmail = 'Email';
  static final favouritesName = 'Name';
  static final favouritesDOB = 'DOB';
  static final favouritesBio = 'Bio';
  static final favouritesMobile = 'Mobile';

  static final locationsTable = 'Locations';
  static final locationsEmail = 'Email';
  static final locationsLat = 'Latitude';
  static final locationsLong = 'Longitude';
  static final locationsTime = 'Time';
  static final locationsDate = 'Date';

  static Database _db;
  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await _initDatabase();
    return _db;
  }

  _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath,  _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $detailsTable ( $detailsEmail TEXT PRIMARY KEY, $detailsName TEXT NOT NULL, $detailsDOB TEXT NOT NULL, $detailsBio TEXT NOT NULL, $detailsMobile TEXT NOT NULL, $detailsPrivateMode TEXT NOT NULL)");
    await db.execute("CREATE TABLE $favouritesTable ( $favouritesEmail TEXT PRIMARY KEY, $favouritesName TEXT NOT NULL, $favouritesDOB TEXT NOT NULL, $favouritesBio TEXT NOT NULL, $favouritesMobile TEXT NOT NULL)");
    await db.execute("CREATE TABLE $locationsTable ( $locationsEmail TEXT PRIMARY KEY, $locationsLat TEXT NOT NULL, $locationsLong TEXT NOT NULL, $locationsTime TEXT NOT NULL, $locationsDate TEXT NOT NULL)");
  }
}