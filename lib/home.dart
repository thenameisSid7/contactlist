import 'package:contactlist/bloc/contacts_bloc.dart';
import 'package:contactlist/service/contactservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/contact.dart';
import 'models/contacthelper.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final contactsBloc = ContactsBloc(ContactService());
  final _newContactNameController = TextEditingController();
  final _newContactPhoneController = TextEditingController();

  @override
  void initState() {
    contactsBloc.add(FetchContacts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contacts',
          style: GoogleFonts.pacifico(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
        ),
      ),
      body: BlocListener<ContactsBloc, ContactsState>(
        bloc: contactsBloc,
        listener: (context, state) {
          if (state is ContactAdded) {
            contactsBloc.add(FetchContacts());
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(const SnackBar(content: Text('Contact Added')));
          } else if (state is ContactDeleted) {
            contactsBloc.add(FetchContacts());
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(const SnackBar(content: Text('Contact Deleted')));
          } else if (state is ContactUpdated) {
            contactsBloc.add(FetchContacts());
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Contact Updated')));
          }
        },
        child: BlocBuilder<ContactsBloc, ContactsState>(
          bloc: contactsBloc,
          builder: (context, state) {
            if (state is ContactListState &&
                state.contactList.contact != null) {
              return mainBody(state.contactList);
            } else if (state is ContactPageError) {
              // print(state.message)l÷÷
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: floatingButton(),
    );
  }

  Widget mainBody(ContactList contactlist) {
    var contacts = contactlist.contact;
    return ListView.builder(
      itemCount: contacts!.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          title: (contact.name != null) ? Text(contact.name!) : null,
          subtitle:
              (contact.phone != null) ? Text(contact.phone!.toString()) : null,
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit'),
                    onTap: () {
                      Navigator.pop(context);
                      editContact(context, contact);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete'),
                    onTap: () {
                      Navigator.pop(context);
                      _deleteContact(contact);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void editContact(BuildContext context, Contact _contact) async {
    _newContactNameController.text = _contact.name!;
    _newContactPhoneController.text = _contact.phone!.toString();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _newContactNameController,
              onChanged: (value) => _contact.name = value,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _newContactPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Contact contact = Contact(
                  name: _newContactNameController.text,
                  phone: int.parse(_newContactPhoneController.text));
              contactsBloc.add(DeleteContacts(_contact.sId!));
              contactsBloc.add(AddContacts(contact));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addContact() {
    String? Name = _newContactNameController.text;
    String? Phone = _newContactPhoneController.text;

    if (Name.isEmpty || Phone.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Fields can't be empty")));
      return;
    }
    print(Name);
    print(Phone);

    Contact contact = Contact(name: Name, phone: int.parse(Phone), sId: null);
    contactsBloc.add(AddContacts(contact));
  }

  void _deleteContact(Contact contact) {
    contactsBloc.add(DeleteContacts(contact.sId!));
  }

  Widget floatingButton() {
    return FloatingActionButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _newContactNameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newContactPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _newContactNameController.text = "";
                _newContactPhoneController.text = "";
                _addContact();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
      child: const Icon(Icons.add),
    );
  }
}
