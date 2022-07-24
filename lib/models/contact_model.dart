import 'package:contact_app/db/db_constants.dart';

class Contact {
  int? id;
  String name;
  String mobileNumber;
  String? email;
  String? address;
  String? dob;
  String? gender;
  String? image;
  String? website;
  bool favorite;

  Contact(
      {this.id,
      required this.name,
      required this.mobileNumber,
      this.email,
      this.address,
      this.dob,
      this.gender,
      this.image,
      this.website,
      this.favorite = false});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      tableContactName: name,
      tableContactMobileNumber: mobileNumber,
      tableContactEmail: email,
      tableContactAddress: address,
      tableContactDob: dob,
      tableContactGender: gender,
      tableContactImage: image,
      tableContactWebsite: website,
      tableContactFavorite: favorite == true ? 1 : 0
    };

    if (id != null) {
      map[tableContactId] = id;
    }

    return map;
  }

  factory Contact.fromMap(Map<String, dynamic> map) => Contact(
        id: map[tableContactId],
        name: map[tableContactName],
        mobileNumber: map[tableContactMobileNumber],
        email: map[tableContactEmail],
        address: map[tableContactAddress],
        dob: map[tableContactDob],
        gender: map[tableContactGender],
        image: map[tableContactImage],
        website: map[tableContactWebsite],
        favorite: map[tableContactFavorite] == 1 ? true : false,
      );
}
