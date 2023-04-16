part of 'contacts_bloc.dart';

@immutable
abstract class ContactsEvent {}

class FetchContacts extends ContactsEvent {}

class UpdateContacts extends ContactsEvent {
  final Contact contact;
  final String id;
  UpdateContacts(this.contact, this.id);
}

class DeleteContacts extends ContactsEvent {
  final String id;
  DeleteContacts(this.id);
}

class AddContacts extends ContactsEvent {
  final Contact contact;
  AddContacts(this.contact);
}
