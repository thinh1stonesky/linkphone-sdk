

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import 'features_provider.dart';

class ContactProvider extends ChangeNotifier{

  Contact? contact;
  List<Contact> _listContact =[];
  int selectedContactIndex = -1;
  List<Contact> get getListContact{
    return _listContact;
  }

  void selectContact(int index) {
    selectedContactIndex = index;
    notifyListeners();
  }

  void collapseAll() {
    selectedContactIndex = -1;
    notifyListeners();
  }


  void addContact({
    required BuildContext context,
    String? name,
    int? id,
  })async{
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    FirebaseFirestore.instance.collection("Contact")
        .doc(featuresProvider.id.toString())
        .collection("YourContacts")
        .doc(id.toString())
        .set({
      'name': name,
      'id' : id,
    });
    fetchContactData(context: context);
  }



  fetchContactData({required BuildContext context}) async{
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    List<Contact> newListContact = [];
    QuerySnapshot value = await FirebaseFirestore.instance.collection("Contact")
        .doc(featuresProvider.id.toString())
        .collection("YourContacts")
        .get();
    value.docs.forEach((element) {
      contact = Contact(
          id : element.get("id").runtimeType == int ? element.get("id"): int.parse(element.get("id")),
        name: element.get('name') as String);
      newListContact.add(contact!);
    });
    newListContact.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
    _listContact = newListContact;
    notifyListeners();
  }

  updateContact({required BuildContext context, required Contact contact}){
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    FirebaseFirestore.instance.collection("Contact")
        .doc(featuresProvider.id.toString())
        .collection("YourContacts")
        .doc(contact.id.toString())
        .update(contact.toJson());
  }

  deleteContact({required BuildContext context, required Contact contact}){
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    FirebaseFirestore.instance.collection("Contact")
        .doc(featuresProvider.id.toString())
        .collection("YourContacts")
        .doc(contact.id.toString())
        .delete();

  }
}