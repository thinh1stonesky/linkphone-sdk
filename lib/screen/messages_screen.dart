
import 'package:flutter/material.dart';
import 'package:linphone_sdk/functions/dialog.dart';
import 'package:linphone_sdk/providers/contact_provider.dart';
import 'package:linphone_sdk/screen/chatbox.dart';
import 'package:linphone_sdk/screen/new_message_screen.dart';
import 'package:provider/provider.dart';

import '../functions/call_functions.dart';
import '../models/constants.dart';
import '../models/contact.dart';
import '../providers/message_provider.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({super.key, required this.pContext});

  BuildContext pContext;
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  late BuildContext pContext;
  MessageProvider? messageProvider;
  ContactProvider? contactProvider;
  Contact? cont;
  String? searchContent = "";

  final TextEditingController _contentCtrl = TextEditingController();
  final TextEditingController _phoneNumCtrl = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    pContext = widget.pContext;
    MessageProvider? messageProvider = Provider.of(context, listen: false);
    messageProvider?.fetchMessageWithData(context: context);

    ContactProvider? contactProvider = Provider.of(context, listen: false);
    contactProvider?.fetchContactData(context: context);

    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    callChannel.setMethodCallHandler((call) async {
      invokedMethods(call: call, context: context, contact: cont, mess: _contentCtrl.text);
    });


    messageProvider = Provider.of(context, listen: true);
    contactProvider = Provider.of(context, listen: true);

    bool check =false;
    List<String> listChatBox= messageProvider!.getListChatBox;
    List<Contact> listContact= contactProvider!.getListContact;

    List<Contact> newContact = [];
    for(int i = 0; i< listChatBox.length ; i++){
      for(int j = 0; j < listContact.length; j++){
        if(listChatBox[i] == listContact[j].id.toString()){
          newContact.add(Contact(id: listContact[j].id, name: listContact[j].name));
          check = true;
          break;
        }
      }
      if(check == true) {
        check = false;
        continue;
      }
      newContact.add(Contact(id: int.parse(listChatBox[i]), name: ""));
    }

    return Scaffold(
        body: Stack(
          children:
          [
            Column(
            children:[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2), // Điều chỉnh độ lệch của đổ bóng (x, y)
                    ),
                  ],// Đặt bán kính bo tròn
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        onChanged: (value)=>{
                          setState((){
                            searchContent = value.toLowerCase();
                          })
                        },
                        controller:_searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Search contact',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),),
              Expanded(
                child: ListView.builder(
                  itemCount: newContact.length,
                  itemBuilder: (context, index) {
                    Contact contact = newContact[index];
                    if(contact.id.toString().contains(searchContent!) || contact.name!.toLowerCase().contains(searchContent!)){
                      return ListTile(
                        title: InkWell(
                          onTap: ()=>Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ChatBox(contact: newContact[index]),)
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: size.width*0.04,
                              backgroundColor: Colors.blue,
                              child: newContact[index].name != "" ? Text(newContact[index].name!.substring(0, 1).toUpperCase()): Text("?"),
                            ),
                            title: newContact[index].name != ""? Text('${newContact[index].name}') : Text(newContact[index].id.toString()),
                          ),

                        ),
                      );
                    }

                  },),
              )
            ] ,
          ),
            Positioned(
              right: size.width * 0.05,
              bottom: size.height * 0.05,
              child: InkWell(
                onTap: ()=>{
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NewMessageScreen(),)
                  )
                },
                child: SizedBox(
                  height: size.height * 0.05,
                  width: size.width * 0.4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8), // Đặt bán kính bo tròn ở đây (8 là ví dụ)
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // Màu của đổ bóng
                          blurRadius: 4, // Độ mờ của đổ bóng
                          spreadRadius: 2, // Phạm vi đổ bóng
                          offset: Offset(0, 2), // Vị trí đổ bóng (ngang, dọc)
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/add-mess.png",
                          width: size.width * 0.05,
                          color: Colors.white,
                        ),
                        SizedBox(width: size.width * 0.03),
                        Text("Start a new chat", style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]
        )
      );

  }
}
