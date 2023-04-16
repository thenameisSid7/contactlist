import 'package:bloc/bloc.dart';
import 'package:contactlist/models/contact.dart';
import 'package:contactlist/service/contactservice.dart';
import 'package:meta/meta.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final ContactService contactService;
  ContactsBloc(this.contactService) : super(ContactsLoading()) {
    on<ContactsEvent>((event, emit) async {
      if (event is FetchContacts) {
        try {
          final list = await contactService.getContacts();
          emit(ContactListState(list));
        } catch (e) {
          emit(ContactPageError(e.toString()));
        }
      } else if (event is UpdateContacts) {
        try {
          await contactService.updateContact(event.contact, event.id);
        } catch (e) {
          emit(ContactPageError(e.toString()));
        }
      } else if (event is AddContacts) {
        try {
          await contactService.addContact(event.contact);
          emit(ContactAdded());
        } catch (e) {
          emit(ContactPageError(e.toString()));
        }
      } else if (event is DeleteContacts) {
        try {
          await contactService.deleteContact(event.id);
          emit(ContactDeleted());
        } catch (e) {
          emit(ContactPageError(e.toString()));
        }
      }
    });
  }
}
