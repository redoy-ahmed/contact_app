import 'dart:io';

import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/pages/contact_new.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../db/db_helper.dart';
import '../utils/Utils.dart';

class ContactDetails extends StatefulWidget {
  static const String routeName = '/contactDetails';

  const ContactDetails({Key? key}) : super(key: key);

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  late Contact contact;

  @override
  void didChangeDependencies() {
    contact = ModalRoute
        .of(context)
        ?.settings
        .arguments as Contact;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  _setFavorite();
                });
              },
              icon: contact.favorite
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_outline),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ContactNew.routeName);
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
              height: 250,
              width: double.maxFinite,
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  contact.image == null
                      ? const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 150,
                  )
                      : Image.file(
                    File(contact.image!),
                    height: 200,
                    width: double.maxFinite,
                  ),
                  Text(
                    contact.name,
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ],
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  contact.mobileNumber,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: const Text(
                  'Mobile Number',
                ),
                leading: IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () {
                    _callToNumber();
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.sms),
                  onPressed: () {
                    _smsToNumber();
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  contact.email!,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: const Text(
                  'E-mail',
                ),
                leading: IconButton(
                  icon: const Icon(Icons.email),
                  onPressed: () {
                    _emailToAddress();
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  contact.address!,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: const Text(
                  'Address',
                ),
                leading: IconButton(
                  icon: const Icon(Icons.location_on_rounded),
                  onPressed: () {
                    _locationToMap();
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  contact.dob == null ? 'Not Available' : contact.dob!,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: const Text(
                  'Date of Birth',
                ),
                leading: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () {},
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  contact.gender == null ? 'Not Available' : contact.gender!,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: const Text(
                  'Gender',
                ),
                leading: IconButton(
                  icon: contact.gender == null
                      ? const Icon(Icons.transgender)
                      : (contact.gender == 'Male'
                      ? const Icon(Icons.male)
                      : const Icon(Icons.female)),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ));
  }

  _callToNumber() async {
    String url = 'tel:${contact.mobileNumber}';
    bool result = await canLaunchUrl(Uri.parse(url));
    if (result) {
      launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  _smsToNumber() async {
    String url = 'sms:${contact.mobileNumber}';
    bool result = await canLaunchUrl(Uri.parse(url));
    if (result) {
      launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  _emailToAddress() async {
    String url = 'mailto:${contact.email}?subject=News&body=New%20plugin';
    bool result = await canLaunchUrl(Uri.parse(url));
    if (result) {
      launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  _locationToMap() async {
    late String url;

    if (Platform.isAndroid) {
      url = 'geo:0,0?q=${contact.address}';
    } else if (Platform.isIOS) {
      url = 'maps://?saddr=${contact.address}';
    } else {
      url =
      'https://www.google.com/maps/search/?api=1&query=${contact.address}';
    }

    bool result = await canLaunchUrl(Uri.parse(url));
    if (result) {
      launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _setFavorite() async {
    contact.favorite = !contact.favorite;
    int result = await DBHelper.update(contact);
    if (result > 0) {
      if (contact.favorite) {
        showToast('Added to Favorite');
      } else {
        showToast('Removed from Favorite');
      }
    } else {
      showToast('Could not Update!');
    }
  }
}
