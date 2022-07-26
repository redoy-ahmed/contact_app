import 'package:flutter/cupertino.dart';

import '../db/db_helper.dart';
import '../models/contact_model.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> allContactList = [];
  Contact? selectedContact;

  setSelectedContact(Contact? contact) {
    selectedContact = contact;
    notifyListeners();
  }

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
      allContactList.removeWhere((element) => element.id == contact.id);
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
