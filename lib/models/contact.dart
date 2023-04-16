class ContactList {
  List<Contact>? contact;

  ContactList({this.contact});

  ContactList.fromJson(Map<String, dynamic> json) {
    if (json['contact'] != null) {
      contact = <Contact>[];
      json['contact'].forEach((v) {
        contact!.add(Contact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (contact != null) {
      data['contact'] = contact!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contact {
  String? sId;
  String? name;
  int? phone;

  Contact({this.sId, this.name, this.phone});

  Contact.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}
