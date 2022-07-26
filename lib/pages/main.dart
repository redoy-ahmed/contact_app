import 'package:contact_app/pages/contact_details.dart';
import 'package:contact_app/pages/contact_list.dart';
import 'package:contact_app/pages/contact_new.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ContactProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: ContactList.routeName,
      routes: {
        ContactList.routeName: (context) => const ContactList(),
        ContactDetails.routeName: (context) => const ContactDetails(),
        ContactNew.routeName: (context) => const ContactNew(),
      },
    );
  }
}
