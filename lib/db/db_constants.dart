const int dbVersion = 1;

const String tableContact = 'tblContact';

const String tableContactId = 'id';
const String tableContactName = 'name';
const String tableContactMobileNumber = 'mobileNumber';
const String tableContactEmail = 'email';
const String tableContactDob = 'dob';
const String tableContactAddress = 'address';
const String tableContactGender = 'gender';
const String tableContactFavorite = 'favorite';
const String tableContactImage = 'image';

const String createTableContact = '''create table $tableContact(
  $tableContactId integer primary key,
  $tableContactName text,
  $tableContactMobileNumber text,
  $tableContactEmail text,
  $tableContactAddress text,
  $tableContactDob text,
  $tableContactGender text,
  $tableContactImage text,
  $tableContactFavorite integer)''';
