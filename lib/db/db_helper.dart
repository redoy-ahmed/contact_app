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
    });
  }

  static Future<int> insert(Contact contact) async {
    final db = await open();
    return await db.insert(tableContact, contact.toMap());
  }

  static Future<List<Contact>> getAllContacts() async {
    final db = await open();
    final mapList = await db.query(tableContact);
    return List.generate(
        mapList.length, (index) => Contact.fromMap(mapList[index]));
  }
}
