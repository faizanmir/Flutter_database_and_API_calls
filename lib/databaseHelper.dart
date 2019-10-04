import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class User {
  String name;
  String title;
  int id;
  User();
  User.fromMap(Map<String, dynamic> received) {
    name = received["nameKey"];
    title = received["titleKey"];
  }

  Map toMap() {
    var map = <String, dynamic>{"name": name, "id": id, "title": title};
    print(map);
    return map;
  }
}

class DatabaseHelper {
  final String userTable = 'userTable';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnName = 'name';

  static final _databaseName = "myFirstDataBase.db";
  static final _databaseVersion = 1;

  static Database _database;
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $userTable (
                $columnId INTEGER PRIMARY KEY,
                $columnTitle TEXT NOT NULL,
                $columnName TEXT NOT NULL
              )
              ''');
    print("Created");
  }

  Future<int> insert(User user) async {
    Database db = await database;
    int id = await db.insert(userTable, user.toMap());
    return id;
  }

  Future<User> queryWord(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(userTable,
        columns: [columnName, columnId, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  getAllUsers() async {
    Database db = await database;
    var res = await db.query("$userTable");
    List<User> list = res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }
}

save() async {

  Map <String,dynamic> userMap = new Map();
  userMap.putIfAbsent("nameKey", ()=>"Hello");
  userMap.putIfAbsent("titleKey", ()=>"Title");


  User user = User.fromMap(userMap);

  DatabaseHelper helper = DatabaseHelper.instance;
  int id = await helper.insert(user);
  print('inserted row: $id');
}

read() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  int rowId = 2;
  User user = await helper.queryWord(rowId);
  if (user == null) {
    print('read row $rowId: empty');
  } else {
    print('read row $rowId: ${user.name} ${user.id}');
  }


}


readList() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  List<User> userList = await helper.getAllUsers();
  userList.forEach((user) {
    print(user.name);
  });
}
