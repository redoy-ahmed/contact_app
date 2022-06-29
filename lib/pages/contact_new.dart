import 'package:flutter/material.dart';

class ContactNew extends StatefulWidget {
  static const String routeName = '/contactNew';

  const ContactNew({Key? key}) : super(key: key);

  @override
  State<ContactNew> createState() => _ContactNewState();
}

class _ContactNewState extends State<ContactNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Contact',
        ),
      ),
      body: ListView(),
    );
  }
}
