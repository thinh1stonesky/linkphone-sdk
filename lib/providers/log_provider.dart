

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/log.dart';
import 'features_provider.dart';

class LogProvider extends ChangeNotifier{

  Log log = Log();
  List<Log> _listLog =[];
  int selectedLogIndex = -1;

  List<Log> get listLog{
    return _listLog;
  }

  void selectLog(int index) {
    selectedLogIndex = index;
    notifyListeners();
  }

  void addLog({
    required BuildContext context,
    Log? log
  })async{
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    FirebaseFirestore.instance.collection("Log")
        .doc(featuresProvider.id.toString())
        .collection("YourLog")
        .doc(log!.time.toString())
        .set({
      'contact': log.contact,
      'duration' : log.duration,
      'time' : log.time.toString(),
      'type' : log.type,
    });
    fetchLogData(context: context);
  }

  fetchLogData({required BuildContext context}) async{
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    List<Log> newListLog = [];
    QuerySnapshot value = await FirebaseFirestore.instance.collection("Log")
        .doc(featuresProvider.id.toString())
        .collection("YourLog")
        .get();
    value.docs.forEach((element) {
      Log log = Log(
          contact : element.get("contact") as String,
          duration: element.get('duration') as String,
          time: int.parse(element.get('time')),
          type: element.get('type') as String);
      newListLog.add(log);
    });
    newListLog.sort((a, b) => b.time!.compareTo(a.time!),);
    _listLog = newListLog;
    notifyListeners();
  }
  deleteLog({required BuildContext context, required Log log}){
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    FirebaseFirestore.instance.collection("Log")
        .doc(featuresProvider.id.toString())
        .collection("YourLog")
        .doc(log.time.toString())
        .delete();
  }
}


