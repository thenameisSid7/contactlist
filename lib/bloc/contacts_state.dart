part of 'contacts_bloc.dart';

@immutable
abstract class ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactListState extends ContactsState {
  final ContactList contactList;
  ContactListState(this.contactList);
}

class ContactPageError extends ContactsState {
  final String message;
  ContactPageError(this.message);
}

class ContactAdded extends ContactsState {}


