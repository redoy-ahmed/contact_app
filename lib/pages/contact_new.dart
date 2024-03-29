import 'dart:io';

import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/Utils.dart';

class ContactNew extends StatefulWidget {
  static const String routeName = '/contactNew';

  const ContactNew({Key? key}) : super(key: key);

  @override
  State<ContactNew> createState() => _ContactNewState();
}

class _ContactNewState extends State<ContactNew> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController();

  String? _dob;
  String? _genderGroupValue;
  String? _imagePath;
  final _formKey = GlobalKey<FormState>();

  Contact? contact;

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      contact = ModalRoute.of(context)?.settings.arguments as Contact;
      _nameController.text = contact!.name;
      _mobileController.text = contact!.mobileNumber;
      _emailController.text = contact!.email!;
      _addressController.text = contact!.address!;
      _websiteController.text = contact!.website!;

      _dob = contact!.dob;
      _imagePath = contact!.image;
      _genderGroupValue = contact!.gender;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'New Contact',
        ),
        actions: [
          IconButton(
              onPressed: _saveContact, icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a valid name';
                } else {
                  null;
                }
              },
              decoration: const InputDecoration(
                labelText: 'Contact Name',
                filled: true,
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: _mobileController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a valid mobile number';
                } else if (value.length < 11 || value.length > 14) {
                  return 'Invalid mobile number';
                } else {
                  null;
                }
              },
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                filled: true,
                prefixIcon: Icon(Icons.call),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                filled: true,
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Street Address',
                filled: true,
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _websiteController,
              decoration: const InputDecoration(
                labelText: 'Website',
                filled: true,
                prefixIcon: Icon(Icons.newspaper),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _selectDate,
                    child: const Text('Select Date of Birth'),
                  ),
                  Chip(
                    label: Text(_dob == null ? 'No Date Selected' : _dob!),
                  ),
                ],
              ),
            ),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Select Gender'),
                  Radio<String>(
                    value: 'Male',
                    groupValue: _genderGroupValue,
                    onChanged: (value) {
                      setState(() {
                        _genderGroupValue = value;
                      });
                    },
                  ),
                  const Text('Male'),
                  Radio<String>(
                    value: 'Female',
                    groupValue: _genderGroupValue,
                    onChanged: (value) {
                      setState(() {
                        _genderGroupValue = value;
                      });
                    },
                  ),
                  const Text('Female'),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  Card(
                    child: _imagePath == null
                        ? const Icon(
                            Icons.person,
                            color: Colors.blue,
                            size: 150,
                          )
                        : Image.file(
                            File(_imagePath!),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          _getImage(ImageSource.camera);
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text('Camera'),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          _getImage(ImageSource.gallery);
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text('Gallery'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    var selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950, 1, 1),
        lastDate: DateTime.now());

    if (selectedDate != null) {
      setState(() {
        _dob = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  void _getImage(ImageSource imageSource) async {
    final selectedImage = await ImagePicker().pickImage(source: imageSource);
    if (selectedImage != null) {
      setState(() {
        _imagePath = selectedImage.path;
      });
    }
  }

  void _saveContact() async {
    if (_dob == null) {
      showToast('Please select DOB');
    }

    if (_formKey.currentState!.validate()) {
      final newContact = Contact(
        name: _nameController.text,
        mobileNumber: _mobileController.text,
        email: _emailController.text,
        address: _addressController.text,
        gender: _genderGroupValue,
        dob: _dob,
        image: _imagePath,
        website: _websiteController.text,
      );

      bool status = false;

      if (contact != null) {
        newContact.id = contact!.id;
        status = await Provider.of<ContactProvider>(context, listen: false)
            .updateContact(newContact);
      } else {
        status = await Provider.of<ContactProvider>(context, listen: false)
            .addContact(newContact);
      }

      if (status) {
        Provider.of<ContactProvider>(context, listen: false)
            .setSelectedContact(newContact);
        showToast('Successfully Saved');
        Navigator.pop(context);
      } else {
        showToast('Could not save Contact');
      }
    }
  }
}
