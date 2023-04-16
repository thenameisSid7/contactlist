import 'package:contactlist/models/contact.dart';
import 'package:dio/dio.dart';

String baseUrl = "http://172.20.10.5:8000/api/v1";

class ContactService {
  String url = "$baseUrl/contacts";
  late Dio dio;

  ContactService() {
    dio = Dio();
  }

  Future<ContactList> getContacts() async {
    var response = await dio.get(url);
    var contactList = ContactList.fromJson(response.data);
    return contactList;
  }

  Future<void> updateContact(Contact contact, String id) async {
    await dio.put(url, data: contact.toJson());
  }

  Future<void> deleteContact(String id) async {
    await dio.delete(url, data: {"id": id});
  }

  Future<void> addContact(Contact contact) async {
    await dio.post(url, data:contact);
  }
}
