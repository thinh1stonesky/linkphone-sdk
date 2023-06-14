
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linphone_sdk/models/message.dart';
import 'package:provider/provider.dart';
import 'features_provider.dart';

class MessageProvider extends ChangeNotifier{

  Chat? chat;
  List<Chat> listChat = [];
  List<Messages> _listMessage  =[];
  List<String> _listChatbox  =[];

  List<Messages> get getListMessage{
    return _listMessage;
  }

  List<String> get getListChatBox{
    return _listChatbox;
  }

  String getMessageTime(){
    return '${DateTime.now().day}'
        '${DateTime.now().month}'
        '${DateTime.now().year}'
        '${DateTime.now().hour}'
        '${DateTime.now().minute}'
        '${DateTime.now().second}';
  }

  addMessage({
    required BuildContext context,
    String? content,
    bool? isOutgoing,
    String? messageWith
  })async{
    DateTime dateTime = DateTime.now();
    int time = (dateTime.microsecondsSinceEpoch/1000/1000).round();
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    FirebaseFirestore.instance.collection("Message")
        .doc(featuresProvider.id.toString())
        .collection("YourMessage")
        .doc(messageWith).set({});
    FirebaseFirestore.instance.collection("Message")
        .doc(featuresProvider.id.toString())
        .collection("YourMessage")
        .doc(messageWith)
        .collection("ChatList")
        .add({
      'content': content,
      'isOutgoing' : isOutgoing.toString(),
      'time' : time.toString()
    });
  }

  fetchMessageData({required BuildContext context, required String messageWithId}) async{
    _listMessage = [];
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    List<Messages> newListMessage = [];
    QuerySnapshot value = await FirebaseFirestore.instance.collection("Message")
        .doc(featuresProvider.id.toString())
        .collection("YourMessage")
        .doc(messageWithId)
        .collection("ChatList")
        .get();
    value.docs.forEach((element) {
      chat = Chat(
          content : element.get("content") as String,
          isOutgoing: element.get('isOutgoing').toString().toLowerCase() == "true" ? true : false,
          time : int.parse(element.get('time'))
      );
      listChat.add(chat!);
    });
    listChat.sort((a, b) => b.time!.compareTo(a.time!),);
    _listMessage.add(Messages(contact: messageWithId, chatlist: listChat));
    listChat = [];
    notifyListeners();
  }

  fetchMessageWithData({required BuildContext context}) async{
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    List<String> newListChatBox = [];
    QuerySnapshot value = await FirebaseFirestore.instance.collection("Message")
        .doc(featuresProvider.id.toString())
        .collection("YourMessage")
        .get();
    newListChatBox = value.docs.map((doc) => doc.id).toList();
    _listChatbox = newListChatBox;

  }
}