import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contact_model.dart';
import 'db_constants.dart';

class DBHelper {

  static Future<Database> open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = join(rootPath, 'contact.db');
    return openDatabase(dbPath, version: dbVersion, onCreate: (db, version) {
      db.execute(createTableContact);
    }, onUpgrade: (db, oldV, newV) {
      if (newV == 2) {
        db.execute('ALTER TABLE $tableContact ADD COLUMN $tableContactWebsite text');
      }
    });
  }

  static Future<int> insert(Contact contact) async {
    final db = await open();
    return await db.insert(tableContact, contact.toMap());
  }

  static Future<int> update(Contact contact) async {
    final db = await open();
    return await db.update(tableContact, contact.toMap(),
        where: '$tableContactId = ?', whereArgs: [contact.id]);
  }

  static Future<int> delete(int rowId) async {
    final db = await open();
    return await db
        .delete(tableContact, where: '$tableContactId =?', whereArgs: [rowId]);
  }

  static Future<List<Contact>> getAllContacts() async {
    final db = await open();
    final mapList = await db.query(tableContact);
    return List.generate(
        mapList.length, (index) => Contact.fromMap(mapList[index]));
  }
}
