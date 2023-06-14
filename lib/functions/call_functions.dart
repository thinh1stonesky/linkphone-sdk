import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linphone_sdk/models/log.dart';
import 'package:linphone_sdk/providers/contact_provider.dart';
import 'package:linphone_sdk/providers/features_provider.dart';
import 'package:linphone_sdk/providers/log_provider.dart';
import 'package:linphone_sdk/providers/message_provider.dart';
import 'package:linphone_sdk/screen/chatbox.dart';
import 'package:provider/provider.dart';
import '../models/constants.dart';
import '../models/contact.dart';
import '../providers/call_status_provider.dart';
import '../screen/home_screen.dart';

void mute() async {
  try{
    await callChannel.invokeMethod(MUTE);

  } on PlatformException catch(e){
    print(e);
  }
}

void speakerOff() async {
  try{
    await callChannel.invokeMethod(SPEAKER_OFF);

  } on PlatformException catch(e){
    print(e);
  }
}


void pause() async {
  try{
    String callState = await callChannel.invokeMethod(PAUSE);
    print(callState);

  } on PlatformException catch(e){
    print(e);
  }
}



Future<void> accept() async{
  try{
    await callChannel.invokeMethod(ACCEPT);
  }on PlatformException catch(e){
    print(e);
  }
}

Future<void> deny() async{
  try{
    await callChannel.invokeMethod(HANG_UP);
  }on PlatformException catch(e){
    print(e);
  }
}


void adjustMic(double value) async{
  try{
    await callChannel.invokeMethod(ADJUST_MIC, {
      "value" : value.toString()
    });
  }on PlatformException catch(e){
    print(e);
  }
}

void adjustAudio(double value) async{
  try{
    await callChannel.invokeMethod(ADJUST_AUDIO, {
      "value" : value.toString()
    });
  }on PlatformException catch(e){
    print(e);
  }
}

void callTranfer(String tranferNB, BuildContext context) async{
  try{
    if(tranferNB.trim() != ""){
      FeaturesProvider featuresProvider = Provider.of(context, listen: false);
      await callChannel.invokeMethod(CALL_TRANFER, {
        "address" : "*2$tranferNB",
        "domain" : featuresProvider.domain
      });
    }
  }on PlatformException catch(e){
    print(e);
  }
}

Future<void> sendMessage(String message, String address ,BuildContext context) async{
  try{
    if(message.trim() != ""){
      DateTime dateTime = DateTime.now();
      var time = dateTime.millisecondsSinceEpoch;
      FeaturesProvider featuresProvider = Provider.of(context, listen: false);
      await callChannel.invokeMethod(SEND_MESSAGE, {
        "message" : message,
        "address" : address,
        "domain" : featuresProvider.domain,
        "time" : time.toString()
      });
    }
  }on PlatformException catch(e){
    print(e);
  }
}

void createConference() async{
  try{
    await callChannel.invokeMethod(CREATE_CONFERENCE);
  }on PlatformException catch(e){
    print(e);
  }
}

Future<int> checkCalls() async{
  try{
    int callsNb = await callChannel.invokeMethod(CHECK_CALLS);
    return callsNb;
  }on PlatformException catch(e){
    print(e);
  }
  return 0;
}

void snoopingCall(String address, BuildContext context) async{
  try{
    if(address.trim() !=  ""){
      FeaturesProvider featuresProvider = Provider.of(context, listen: false);
      String? domain = featuresProvider.domain;
      await callChannel.invokeMethod(SNOOPING_CALL,
          {
            "address" : address,
            "domain" : domain
          });
    }
  }on PlatformException catch(e){
    print(e);
  }
}



void addParticipant(String address, BuildContext context) async{
  try{
    if(address.trim() !=  ""){
      FeaturesProvider featuresProvider = Provider.of(context, listen: false);
      String? domain = featuresProvider.domain;
      await callChannel.invokeMethod(ADD_PARTICIPANT,
          {
            "address" : address,
            "domain" : domain
          });
    }
  }on PlatformException catch(e){
    print(e);
  }
}

Future<void> call(String address, BuildContext context) async {
  print("call pressed");
  try{
    CallStatusProvider callStatusProvider = Provider.of(context, listen: false);
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    LogProvider logProvider = Provider.of(context, listen: false);
    if(!featuresProvider.isCall)
    {
      //call
      if(address != ""){
        featuresProvider.addContacts("sip:" +address +"@"+featuresProvider.domain!);
        logProvider.log.contact = address;
        logProvider.log.type = "Outgoing call";
        callStatusProvider.updateCallerChannel(address);
        await callChannel.invokeMethod(OUTGOING_CALL,{
          "address" : address,
          "domain" : featuresProvider.domain
        });
      }
    }else{
      //hang up
      // featuresProvider.updateIsConference(false);
      if(logProvider.log.type == "Missed call") {
        logProvider.log.type = "Declined call";
      }
      await deny();
      print("hang-up");
    }

  } on PlatformException catch(e) {
    print(e);
  }
}



Future<void> invokedMethods({required MethodCall call, required BuildContext context, Contact? contact, String? mess, String? className})  async{

  CallStatusProvider callStatusProvider = Provider.of(context, listen: false);
  FeaturesProvider featuresProvider = Provider.of(context, listen: false);
  MessageProvider messageProvider = Provider.of(context, listen: false);
  ContactProvider contactProvider = Provider.of(context, listen: false);
  LogProvider logProvider = Provider.of(context, listen: false);

  ///notification intiallize
  // late final LocalNotificationService service;
  // service = LocalNotificationService();
  // service.intialize();

  switch (call.method){
    case GO_TO_CALL_SCREEN:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => HomeScreen(),)
      );
      break;
    case GO_TO_MESS_SCREEN:
      String remoteAddress = await call.arguments;

      print(remoteAddress);
      if(contactProvider.getListContact.length == 0){
        contactProvider.fetchContactData(context: context);
      }
      List<Contact> list = contactProvider.getListContact;
      Contact contact = list.where((cont) => cont.id == remoteAddress).first;
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ChatBox(contact: contact),)
      );
      break;
    case REQUEST_FETCH_MESSAGE_DATA:
      String remoteAddress = await call.arguments;
      messageProvider.fetchMessageData(context: context, messageWithId: remoteAddress);
      messageProvider.fetchMessageWithData(context: context);
      break;
    case INCOMING_CALL:
      String addressExample = "sip:100@192.162.61.112";
      int startIndex = addressExample.indexOf(":") + 1;
      int endIndex = addressExample.indexOf("@");
      String remoteAddress = await call.arguments;
      featuresProvider.updateIsCall(true);

      callStatusProvider.updateCallerChannel(remoteAddress.substring(startIndex,endIndex));
      featuresProvider.addContacts(remoteAddress);
      logProvider.log.type = "Missed call";
      logProvider.log.contact = remoteAddress.substring(startIndex,endIndex);
      break;
    case UPDATE_CALL_STATE:
      String callState = await call.arguments;
      callStatusProvider.updateCallState(callState);
      switch (callState){
        case "Remote ringing":
          featuresProvider.isDisableCoachingButton = true;
          // isDisableMonitoringButton = true;
          featuresProvider.updateIsCall(true);
          break;
        case "Connected":
          if(featuresProvider.timer== null){
            featuresProvider.startTimer();
          }
          featuresProvider.isDisablePickupButton = true;
          featuresProvider.isDisablePauseButton = false;
          if(logProvider.log.type == "Missed call") {
            logProvider.log.type = "Incoming call";
          }
          break;
        case "Streams running":

          featuresProvider.isDisablePickupButton = true;
          break;
        case "Call paused":
          break;
        case "Resuming":
          break;
        case "Call released":
          DateTime dateTime = DateTime.now();
          var time = dateTime.millisecondsSinceEpoch;
          logProvider.log.time = time;
          String twoDigits(int n) => n.toString().padLeft(2, "0");
          final hours = twoDigits(featuresProvider.duration.inMinutes.remainder(60));
          final minutes = twoDigits(featuresProvider.duration.inSeconds.remainder(60));
          logProvider.log.duration = "$hours:$minutes";
          if(logProvider.log.contact != null && logProvider.log.duration != null && logProvider.log.time != null && logProvider.log.type != null)
            logProvider.addLog(context: context, log: logProvider.log);
          logProvider.log = Log();
          featuresProvider.isDisableTranferButton = true;
          featuresProvider.isDisableMeetButton = true;
          getCallsNb(context);
          break;
        case "Incoming call received":
          featuresProvider.isDisablePickupButton = false;
          featuresProvider.isDisableCoachingButton = true;
          break;
      }
      break;
    case UPDATE_REGISTRATION_STATE:

      String registrationState = await call.arguments;
      callStatusProvider.updateRegistation(registrationState);
      break;
    case UPDATE_PARTICIPANT_LIST:
      String participantList = await call.arguments;
      List<String> parts;
      if(participantList.contains(" ")){
        parts = participantList.split(" "); // Tách chuỗi dựa trên khoảng trắng
      }else{
        parts = [participantList];
      }
      featuresProvider.updateContacts(parts);

      break;
    case UPDATE_CONFERENCE_STATE:
      String conferenceState = await call.arguments;
      switch (conferenceState){

        case "Created":
          featuresProvider.updateIsConference(true);
          break;
        case "Deleted":
        // if(featuresProvider.contacts.length == 1){
        // featuresProvider.updateIsConference(false);
        // }

          break;
      }
      break;
    case MESSAGE_DELIVERED:
        String rawInfo = await call.arguments;
        List<String> splitInfo = rawInfo.split("-");
        await messageProvider.addMessage(context: context, content: splitInfo[1], isOutgoing: true, messageWith: splitInfo[0]);
        messageProvider.fetchMessageData(context: context, messageWithId: splitInfo[0]);
        messageProvider.fetchMessageWithData(context: context);
      break;
    case REQUSET_UPDATE_FEATURE_ID:
        String id = call.arguments;
        featuresProvider.updateId(id);
      break;
    default:
      break;
  }
}

Future<void> getCallsNb(BuildContext context) async {
  FeaturesProvider featuresProvider = Provider.of(context, listen: false);
  CallStatusProvider callStatusProvider = Provider.of(context, listen: false);
  int getCallsNb = await checkCalls();
  if(getCallsNb == 0){
    if(featuresProvider.timer != null){
      featuresProvider.resetTimer();
    }

    featuresProvider.isDisablePauseButton = true;
    featuresProvider.isDisableCoachingButton = false;
    featuresProvider.isDisableMonitoringButton = false;
    featuresProvider.isDisablePickupButton = true;

    callStatusProvider.updateCallerChannel("");
    callStatusProvider.updateCallState("");
    featuresProvider.updateIsCall(false);
    featuresProvider.updateIsConference(false);
    featuresProvider.clearContacts();
  }
}

Future<String> register(String domain, String id, String password, BuildContext context) async {
  FeaturesProvider featuresProvider = Provider.of(context, listen: false);
  // featuresProvider.updateDomain(domain);
  // featuresProvider.updateId(id);
  try{
    if(domain != "" && id != "" && password != ""){
      String userState = await callChannel.invokeMethod(REGISTER,{
        "domain" : domain,
        "id" : id,
        "password" : password
      });

      featuresProvider.addContacts("sip:"+id+"@"+domain);

      print(userState);
      featuresProvider.updateDomain(domain);
      featuresProvider.updateId(id);
      return userState;
    }
  } on PlatformException catch(e){
    print(e);
  }
  return "";
}


Future<void> checkInCall(BuildContext context) async {
  FeaturesProvider featuresProvider = Provider.of(context, listen: false);
  CallStatusProvider callStatusProvider = Provider.of(context, listen: false);
  try{
    print("**********************");
      // String checkCall = await callChannel.invokeMethod(CHECK_IN_CALL);
      String checkCall = await callChannel.invokeMethod(CHECK_IN_CALL);
      var data = json.decode(checkCall);
      switch(data["state"]){
        case "IncomingReceived":
          String remoteAddress = data["address"].toString();
          featuresProvider.updateIsCall(true);
          callStatusProvider.updateCallState("Incoming call");
          callStatusProvider.updateCallerChannel(remoteAddress);
          featuresProvider.addContacts(remoteAddress);
          break;
        case "StreamsRunning":
          String remoteAddress = data["address"].toString();
          callStatusProvider.updateCallState("Stream running");
          featuresProvider.updateIsCall(true);
          callStatusProvider.updateCallerChannel(remoteAddress);
          featuresProvider.addContacts(remoteAddress);

          // featuresProvider.startTimer();
          featuresProvider.isDisablePickupButton = true;
          featuresProvider.isDisablePauseButton = false;
          featuresProvider.updateIsCall(true);
          featuresProvider.isDisablePickupButton = true;
          break;
      }

  } on PlatformException catch(e){
    print(e);
  }
  return;
}


Future<void> test() async {
  try{
    callChannel.invokeMethod("test");
  } on PlatformException catch(e){
    print(e);
  }
  return;
}




