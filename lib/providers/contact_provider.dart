import 'package:flutter/cupertino.dart';

import '../db/db_helper.dart';
import '../models/contact_model.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> allContactList = [];

  getAllContacts() {
    DBHelper.getAllContacts().then((newList) {
      allContactList = newList;
      notifyListeners();
    });
  }

  Future<bool> addContact(Contact contact) async {
    final rowId = await DBHelper.insert(contact);
    if (rowId > 0) {
      contact.id = rowId;
      allContactList.add(contact);
      allContactList.sort((c1, c2) => c1.name.compareTo(c2.name));
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateContact(Contact contact) async {
    final result = await DBHelper.update(contact);
    if (result > 0) {
      int index = 0;
      for (int i = 0; i < allContactList.length; i++) {
        if (allContactList[i].id == contact.id) {
          index = i;
          break;
        }
      }

      allContactList.removeAt(index);
      allContactList.add(contact);
      allContactList.sort((c1, c2) => c1.name.compareTo(c2.name));
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deleteContact(Contact contact) async {
    await DBHelper.delete(contact.id!);
    allContactList.remove(contact);
    notifyListeners();
    return true;
  }
}
