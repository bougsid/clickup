import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DBProvider {
  final String tasksTable = 'tasks';
  final String listsTable = 'lists';
  final String foldersTable = 'folders';
  final String spacesTable = 'spaces';

  Future<Database> get db async {
    if (_db == null) {
      _db = await open('clickup.db');
    }
    return _db;
  }

  Database _db;

  _onCreate(Database db, int version) async {
    await db.execute('''
create table $tasksTable ( 
  id text primary key,
  list_id text not null, 
  name text not null,
  status text not null,
  due_date integer)
''');

    await db.execute('''
create table $listsTable ( 
  id text primary key,
  folder_id text,
  name text not null)
''');

    await db.execute('''
create table $foldersTable ( 
  id text primary key,
  space_id text,
  name text not null)
''');

    await db.execute('''
create table $spacesTable ( 
  id text primary key,
  space_id text,
  name text not null)
''');
  }

  cleanDatabase() async {
    try {
      await (await db).transaction((txn) async {
        var batch = txn.batch();
        batch.delete(tasksTable);
        batch.delete(listsTable);
        batch.delete(foldersTable);
        batch.delete(spacesTable);
        await batch.commit();
      });
    } catch (e) {
      throw Exception('DbBase.cleanDatabase: ' + e.toString());
    }
  }

  insertTasks(List<Map<String, dynamic>> tasks) async {
    for (Map<String, dynamic> task in tasks) {
      await (await db).insert(tasksTable, task,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  insertLists(List<Map<String, dynamic>> lists) async {
    for (Map<String, dynamic> list in lists) {
      await (await db).insert(listsTable, list,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  insertFolders(List<Map<String, dynamic>> folders) async {
    for (Map<String, dynamic> folder in folders) {
      await (await db).insert(foldersTable, folder,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  insertSpaces(List<Map<String, dynamic>> spaces) async {
    for (Map<String, dynamic> space in spaces) {
      await (await db).insert(spacesTable, space,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  createTask(Map<String, dynamic> task) async {
    await (await db).insert(tasksTable, task);
  }

  deleteTask(String taskId) async {
    await (await db).delete(tasksTable, where: 'id = ?', whereArgs: [taskId]);
  }

  Future<List<Map>> getSpaces() async {
    return await (await db).rawQuery('SELECT * FROM $spacesTable WHERE 1 = 1');
  }

  Future<List<Map>> getSpaceFolders(String spaceID) async {
    return (await db)
        .rawQuery('SELECT * FROM $foldersTable WHERE space_id = $spaceID');
  }

  Future<List<Map>> getFolderLists(String folderId) async {
    return (await db)
        .rawQuery('SELECT * FROM $listsTable WHERE folder_id = $folderId');
  }

  Future<List<Map>> getListTasks(String listId) async {
    return (await db)
        .rawQuery('SELECT * FROM $tasksTable WHERE list_id = $listId');
  }

  Future open(String dbName) async {
    return await openDatabase(p.join(await getDatabasesPath(), dbName),
        version: 1, onCreate: _onCreate);
  }

  deleteAllData() async {
    await deleteDatabase('clickUpTasks');
  }
}
