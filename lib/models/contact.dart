


import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String? name;
  int? id;
  Contact({
    this.id,
    this.name,
  }){
    // id = Random().nextInt(1000);
  }


  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'name' : name,
    };
  }
}
