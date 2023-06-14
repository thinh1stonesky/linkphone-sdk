
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:linphone_sdk/models/contact.dart';
import 'package:linphone_sdk/providers/contact_provider.dart';
import 'package:linphone_sdk/screen/chatbox.dart';
import 'package:linphone_sdk/screen/home_screen.dart';
import 'package:linphone_sdk/screen/new_contact_screen.dart';
import 'package:provider/provider.dart';

import '../functions/call_functions.dart';
import '../functions/dialog.dart';
import '../models/constants.dart';

class Contacts extends StatefulWidget {
  Contacts({Key? key, required this.pContext}) : super(key: key);

  // Function showModalSheet;
  BuildContext pContext;
  @override
  State<Contacts> createState() => _ContactsState();
}


class _ContactsState extends State<Contacts> {

  late ContactProvider contactProvider;
  late BuildContext pContext;
  final TextEditingController _searchCtrl = TextEditingController();
  List<ExpansionTileController> listExpandState = [];
  int isFirst = 0;
  String? searchContent = "";

  @override
  void initState() {
    // TODO: implement initState
    ContactProvider contactProvider = Provider.of(context, listen: false);
    contactProvider.fetchContactData(context: context);

    pContext = widget.pContext;
    // showModalSheet = widget.showModalSheet;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    callChannel.setMethodCallHandler((call) async {
          invokedMethods(call: call, context: context);
    });

    contactProvider = Provider.of(context, listen: true);
    BuildContext? _dialogContext;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
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
            SizedBox(height: size.height * 0.025,),
            Row(
              children: [
                SizedBox(width: size.width * 0.2,),
                Expanded(
                  child: InkWell(
                    onTap: ()=>Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => NewContactScreen(),)
                    ),
                    child: Container(
                      height: size.height * 0.05,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset("assets/add-user.png", height: 15, width: 15, color: Colors.indigo,),
                          SizedBox(width: size.width * 0.05),
                          Text("Create new contact", style: TextStyle(fontSize: 15, color: Colors.indigo),)
                        ],
                      ),),
                  ),
                )
              ],
            ),
            SizedBox(height: size.height * 0.02,),
            Expanded(
              child: ListView.builder(
                  itemCount: contactProvider.getListContact.length,
                  itemBuilder: (context, index) {
                    Contact? contact = contactProvider.getListContact[index];
                    _dialogContext = context;
                    if(contact.id.toString().contains(searchContent!) || contact.name!.toLowerCase().contains(searchContent!)){
                      return AnimatedContainer(
                        curve: Curves.linear,
                        duration: Duration(milliseconds: 3000),
                        child: InkWell(
                          onLongPress: ()=>_delete(_dialogContext!, contactProvider.getListContact[index]),
                          child: ExpansionTile(
                            initiallyExpanded: index == contactProvider.selectedContactIndex,
                            // controller:listExpandState[index],
                            key: Key(contactProvider.selectedContactIndex.toString()),
                            onExpansionChanged: (isExpanded) {
                              setState(() {
                                if(isExpanded){
                                  contactProvider.selectContact(index);
                                }});
                            },
                            leading: CircleAvatar(
                              radius: size.width*0.04,
                              backgroundColor: Colors.blue,
                              child: Text(contact.name!.substring(0, 1).toUpperCase()),
                            ),
                            trailing: Text("",style: TextStyle(color: Colors.black54, fontSize: 12)),
                            title: Text('${contact.name}'),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.17,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("address: ${contact.id}"),
                                      SizedBox(height: size.height*0.02,),
                                      SizedBox(height: size.height*0.02,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: ()=>{
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(address: contact.id.toString()),))
                                            },
                                            child: Icon(Icons.call),
                                          ),
                                          SizedBox(width: size.height*0.15),
                                          InkWell(
                                            onTap: ()=>{
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatBox(contact: contact),))
                                            },
                                            child: Icon(Icons.message),
                                          ),
                                          SizedBox(width: size.height*0.15,),
                                          InkWell(
                                            onTap: ()=>{
                                              Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context) => NewContactScreen(contact: contact,),)
                                              )
                                            },
                                            child: Icon(Icons.edit),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(" . "),
                                ],
                              ),
                            ],
                          ),

                        ),
                      );
                    }else {
                      return Container();
                    }
                  }
              ),
            )
          ],
        ),
      );

  }

  void _delete(BuildContext context, Contact contact) async {
    ContactProvider contactProvider = Provider.of(context, listen: false);
    String? confirm;
    confirm = await showConfirmDialog(context, "Are you sure want to remove ${contact.name!} from contact list?");
    if(confirm == "ok") {
      contactProvider.deleteContact(context: context, contact: contact);
      contactProvider.fetchContactData(context: context);
    }
  }
}
