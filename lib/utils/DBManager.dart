import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';

class DBManager{
  static final _databaseName = "ProjectLocus.db";
  static final _databaseVersion = 1;

  DBManager._();
  static final DBManager _instance = DBManager._();
  factory DBManager() => _instance;

  static final detailsTable = 'Details';
  static final detailsName = 'Name';
  static final detailsBio = 'Bio';
  static final detailsEmail = 'Email';
  static final detailsMobile = 'Mobile';
  static final detailsPrivateMode = 'PrivMode';

  static final favouritesTable = 'Favourites';
  static final favouritesEmail = 'Email';
  static final favouritesName = 'Name';
  static final favouritesBio = 'Bio';

  static final emergencyTable = 'Emergency_list';
  static final emergencyName = 'Name';
  static final emergencyEmail = 'Email';
  static final emergencyMobile = 'Mobile';

  static Database _db;
  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await _initDatabase();
    return _db;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath,  _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $detailsTable ( $detailsEmail TEXT PRIMARY KEY, $detailsName TEXT NOT NULL, $detailsBio TEXT NOT NULL, $detailsMobile TEXT NOT NULL, $detailsPrivateMode TEXT NOT NULL)");
    await db.execute("CREATE TABLE $favouritesTable ( $favouritesEmail TEXT PRIMARY KEY, $favouritesName TEXT NOT NULL, $favouritesBio TEXT NOT NULL)");
    await db.execute("CREATE TABLE $emergencyTable ( $emergencyEmail TEXT PRIMARY KEY, $emergencyName TEXT NOT NULL, $emergencyMobile TEXT NOT NULL)");
  }
}