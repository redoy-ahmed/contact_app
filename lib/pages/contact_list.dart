import 'package:contact_app/db/db_helper.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/pages/contact_details.dart';
import 'package:flutter/material.dart';

class ContactList extends StatefulWidget {
  static const String routeName = '/';

  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: ListView.builder(
          itemCount: allContactList.length,
          itemBuilder: (context, index) {
            Contact contact = allContactList[index];
            return Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
              child: Card(
                elevation: 1,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    child: Text(
                      contact.name[0],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
                  title: Text(
                    contact.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  subtitle: Text(contact.mobileNumber),
                  trailing: IconButton(
                    icon: contact.favorite
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.blue,
                          )
                        : const Icon(Icons.favorite_outline),
                    onPressed: () {
                      setState(() {
                        contact.favorite = !contact.favorite;
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, ContactDetails.routeName,
                        arguments: contact);
                  },
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
