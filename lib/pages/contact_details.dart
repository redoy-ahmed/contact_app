import 'package:contact_app/db/db_helper.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    contact = ModalRoute.of(context)?.settings.arguments as Contact;
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
                  contact.favorite = !contact.favorite;
                });
              },
              icon: contact.favorite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_outline),
            ),
            IconButton(
              onPressed: () {},
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
                      : Image.asset(contact.image!),
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
    String url =
        'https://www.google.com/maps/search/?api=1&query=${contact.address}';
    bool result = await canLaunchUrl(Uri.parse(url));
    if (result) {
      launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
