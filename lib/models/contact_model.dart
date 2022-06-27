class Contact {
  String name;
  String mobileNumber;
  String? email;
  String? address;
  String? dob;
  String? gender;
  String? image;
  bool favorite;

  Contact(
      {required this.name,
      required this.mobileNumber,
      this.email,
      this.address,
      this.dob,
      this.gender,
      this.image,
      this.favorite = false});
}
