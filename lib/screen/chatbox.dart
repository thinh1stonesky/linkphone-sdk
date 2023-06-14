

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linphone_sdk/models/contact.dart';
import 'package:linphone_sdk/providers/message_provider.dart';
import 'package:provider/provider.dart';

import '../functions/call_functions.dart';
import '../models/constants.dart';
import '../models/message.dart';
import 'package:intl/intl.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class ChatBox extends StatefulWidget {
  ChatBox({Key? key, required this.contact, this.addMess}) : super(key: key);
  Contact contact;
  String? addMess;
  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {

  MessageProvider? messageProvider;
  late Contact contact;

  String? preMessage;
  String? addMess;
  @override
  void initState() {
    // TODO: implement initState
    contact = widget.contact;
    addMess = widget.addMess ?? "";
    MessageProvider? messageProvider = Provider.of(context, listen: false);
    messageProvider?.fetchMessageData(context: context, messageWithId: contact.id.toString());
    super.initState();
  }

  TextEditingController _messageCtrl = TextEditingController();



  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    messageProvider = Provider.of(context, listen: true);
    List<Chat> listChat = [];
    for( Messages messages in messageProvider!.getListMessage){
      if(messages.contact == contact.id.toString()){
        listChat = messages.chatlist!;
        break;
      }
    }

    callChannel.setMethodCallHandler((call)async{
      if(call.method == MESSAGE_DELIVERED ) {
        if(addMess != ""){
          preMessage = addMess;
          addMess = "";
        }
        invokedMethods(call: call, context: context, contact: contact, mess: preMessage);
      }
     });
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: ()=> Navigator.of(context).pop(),
          ),
          title: contact.name != "" ? Text(contact.name!) : Text(contact.id.toString()),
        ),
        body: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: ListView.builder(
                  reverse: true,
                  itemCount: listChat.length,
                  itemBuilder: (context, index) {
                    Chat chat = listChat[index];
                    // var time = DateFormat('MM/dd/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(listChat[index].time! *  1000));
                    var time = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(listChat[index].time! *  1000));
                    return ListTile(
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: chat.isOutgoing! ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration:
                                chat.isOutgoing! ?
                                const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(18)),
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.deepPurple,
                                        Colors.lightBlue
                                      ],
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft
                                  ),
                                )
                                    :
                                const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(18)),
                                    color: Colors.black38
                                ),
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [

                                        Text(listChat[index].content!,
                                          style: TextStyle(color: Colors.white),)
                                      ],
                                    )),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
                            child: Row(
                              mainAxisAlignment: chat.isOutgoing! ? MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                Text(time.toString(), style: TextStyle(fontSize: 10, color: Colors.black87),),
                              ],
                            ),
                          ),
                        ],
                      )

                      // buildMessage(message: messageProvider!.getListMessage[index]),
                    );
                  },),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              color: Colors.lightBlue,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: _messageCtrl,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your message",

                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () async{
                        if(
                        _messageCtrl.text.trim() != ""){
                          preMessage = _messageCtrl.text;
                          _messageCtrl.text = "";
                          await sendMessage(preMessage!, contact.id.toString(), context);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 18),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            gradient: const LinearGradient(
                                colors: [
                                  Colors.deepPurple,
                                  Colors.lightBlue
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black38.withOpacity(0.3),
                                  offset: const Offset(0,8),
                                  blurRadius: 8
                              )
                            ]
                        ),
                        child: const Material(
                          color: Colors.transparent,
                          child: Center(
                            child: Text("Send",
                              style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )

                ],
              ),

            )
          ],      ),

    );
  }


}

class buildMessage extends StatelessWidget {
  buildMessage({Key? key, required this.chat}) : super(key: key);

  Chat chat;
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: message.isOutgoing! ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Text(chat.content!,
        style: const TextStyle(color: Colors.white, fontSize: 18,
      ),
        )],
    );
  }


}


