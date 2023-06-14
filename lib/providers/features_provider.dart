


import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:linphone_sdk/models/contact.dart';
import 'package:linphone_sdk/providers/contact_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeaturesProvider extends ChangeNotifier{

  bool _isMute = false;
  bool _isSpeakerOff = false;
  bool _isCall = false;
  bool _isConference = false;
  bool _isSave = false;
  bool _isInBackgroud = false;

  bool get isInBackgroud => _isInBackgroud;

  set isInBackgroud(bool value) {
    _isInBackgroud = value;
  }

  List<String> _contacts = [];

  List<int> get listNotificationId => _listNotificationId;

  void addListNotificationId(int value) {
    _listNotificationId.add(value);
  }

  void removeInListNotificationId(int value) {
    _listNotificationId.remove(value);
  }

  List<int> _listNotificationId = [];



  String? _domain;
  List<String>? _registerInfo = ["", "", ""];
  String? _id= "";

  double _sliderMicValue = 0;
  double _sliderVolumeValue = 0;


  Duration _duration = Duration();
  Timer? _timer;


  bool get isDisablePauseButton => _isDisablePauseButton;

  set isDisablePauseButton(bool value) {
    _isDisablePauseButton = value;
  }

  bool _isDisablePauseButton = true;
  bool _isDisableTranferButton = false;
  bool _isDisableMeetButton = true;
  bool _isDisableMonitoringButton = true;
  bool _isDisableCoachingButton = true;
  bool _isDisablePickupButton = true;




  List<String> get contacts => _contacts;
  Duration get duration => _duration;
  Timer? get timer => _timer;
  List<String>? get registerInfo => _registerInfo;

  bool get isCall => _isCall;
  bool get isConference => _isConference;
  bool get isMute => _isMute;
  bool get isSpeakerOff => _isSpeakerOff;
  bool get isSave => _isSave;

  String? get domain => _domain;
  String? get id => _id;


  double get sliderMicValue => _sliderMicValue;
  double get sliderVolumeValue => _sliderVolumeValue;

  void clearContacts(){
    _contacts.clear();
    addContacts("sip:100@192.168.41.112");
    notifyListeners();
  }
  void updateContacts(List<String> contacts){
    _contacts.clear();
    for(int i = 0; i < contacts.length; i++){
      _contacts.add(contacts[i]);
    }
    notifyListeners();
  }
  void addContacts(String contact){
    if(!_contacts.contains(contact)){
      _contacts.add(contact);
      notifyListeners();
    }
  }

  void updateDomain(String newDomain){
    _domain = newDomain;
    notifyListeners();
  }

  void updateId(String id){
    _id = id;
    notifyListeners();
  }

  Future<bool> checkSave() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSave = prefs.getBool("isSave") ?? false;
    return _isSave;
  }

  getRegisterInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _registerInfo = prefs.getStringList("registerInfo") ?? ["","", ""];
    _isSave = prefs.getBool("isSave") ?? false;
    notifyListeners();
  }

  void updateIsMute(bool isMute){
    _isMute = isMute;
    notifyListeners();
  }

  void updateIsCall(bool isCall){
    _isCall = isCall;
    notifyListeners();
  }
  void updateIsConference(bool isConference){
    _isConference = isConference;
    notifyListeners();
  }

  void updateIsSpeakerOff(bool isSpeakerOff){
    _isSpeakerOff = isSpeakerOff;
    notifyListeners();
  }

  void updateSliderMicValue(double sliderValue){
    _sliderMicValue = sliderValue;
    notifyListeners();
  }
  void updateSliderVolumeValue(double sliderValue){
    _sliderVolumeValue = sliderValue;
    notifyListeners();
  }

  void addTime(){
    final addSeconds = 1;

    print("time add");
      final seconds = _duration.inSeconds + addSeconds;

      _duration = Duration(seconds: seconds);
    notifyListeners();
  }

  void resetTimer() {
      _duration = const Duration(seconds: 0);
      _timer!.cancel();
      _timer = null;
  }


 void resumeTimer(){
    _timer = null;
    _timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
 }

  void startTimer(){
    _timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
    notifyListeners();
  }

  void stopTimer(){

      _timer!.cancel();
      notifyListeners();
  }

  bool get isDisableTranferButton => _isDisableTranferButton;

  set isDisableTranferButton(bool value) {
    _isDisableTranferButton = value;
  }

  bool get isDisableMeetButton => _isDisableMeetButton;

  set isDisableMeetButton(bool value) {
    _isDisableMeetButton = value;
  }

  bool get isDisableMonitoringButton => _isDisableMonitoringButton;

  set isDisableMonitoringButton(bool value) {
    _isDisableMonitoringButton = value;
  }

  bool get isDisableCoachingButton => _isDisableCoachingButton;

  set isDisableCoachingButton(bool value) {
    _isDisableCoachingButton = value;
  }

  bool get isDisablePickupButton => _isDisablePickupButton;

  set isDisablePickupButton(bool value) {
    _isDisablePickupButton = value;
  }
}