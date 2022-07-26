import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/pages/contact_details.dart';
import 'package:contact_app/pages/contact_new.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/Utils.dart';

class ContactList extends StatefulWidget {
  static const String routeName = '/';

  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  void initState() {
    Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    super.initState();
  }

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
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => ListView.builder(
            itemCount: provider.allContactList.length,
            itemBuilder: (context, index) {
              Contact contact = provider.allContactList[index];
              return Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                child: Card(
                  elevation: 1,
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.delete,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    confirmDismiss: showConfirmationDialog,
                    onDismissed: (direction) async {
                      bool status = await Provider.of<ContactProvider>(context,
                              listen: false)
                          .updateContact(contact);

                      if (status) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Deleted'),
                          duration: const Duration(seconds: 5),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () async {
                              await Provider.of<ContactProvider>(context, listen: false)
                                  .addContact(contact);
                            },
                          ),
                        ));
                      }
                    },
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
                                color: Colors.red,
                              )
                            : const Icon(Icons.favorite_outline),
                        onPressed: () {
                          setState(() {
                            _setFavorite(contact);
                          });
                        },
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, ContactDetails.routeName,
                            arguments: contact);
                      },
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.pushNamed(context, ContactNew.routeName, arguments: null)
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool?> showConfirmationDialog(DismissDirection direction) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete'),
              content: const Text('Are you sure to delete this Contact?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('NO')),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('YES')),
              ],
            ));
  }

  void _setFavorite(Contact contact) async {
    contact.favorite = !contact.favorite;
    bool status = await Provider.of<ContactProvider>(context, listen: false)
        .updateContact(contact);

    if (status) {
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
