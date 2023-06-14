
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:linphone_sdk/providers/log_provider.dart';
import 'package:linphone_sdk/screen/new_contact_screen.dart';
import 'package:provider/provider.dart';
import '../functions/call_functions.dart';
import '../functions/dialog.dart';
import '../models/constants.dart';
import '../models/contact.dart';
import '../models/log.dart';
import '../providers/contact_provider.dart';
import 'chatbox.dart';
import 'home_screen.dart';

class LogScreen extends StatefulWidget {
  LogScreen({Key? key, required this.pContext}) : super(key: key);

  // Function showModalSheet;
  BuildContext pContext;
  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  late LogProvider logProvider;
  ContactProvider? contactProvider;
  late List<Log> logs;
  // late Function showModalSheet;
  late BuildContext pContext;
  int isFirst = 0;
  List<ExpansionTileController> listExpandState = [];

  @override
  void initState() {
    // TODO: implement initState
    LogProvider logProvider = Provider.of(context, listen: false);
    logProvider.fetchLogData(context: context);

    ContactProvider? contactProvider = Provider.of(context, listen: false);
    contactProvider?.fetchContactData(context: context);
    pContext = widget.pContext;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    callChannel.setMethodCallHandler((call) async {
      invokedMethods(call: call, context: context);
    });
    bool check =false;
    logProvider = Provider.of(context, listen: true);
    contactProvider = Provider.of(context, listen: true);
    List<Contact> listContact= contactProvider!.getListContact;

    logs = logProvider.listLog;
    List<Log> newlogs = [];

    for(int i = 0; i< logs.length ; i++){
      for(int j = 0; j < listContact.length; j++){
        if(logs[i].contact == listContact[j].id.toString()){
          newlogs.add(Log(name: listContact[j].name, time: logs[i].time, duration: logs[i].duration, type: logs[i].type, contact: logs[i].contact));
          check = true;
          break;
        }
      }
      if(check == true) {
        check = false;
        continue;
      }
      newlogs.add(logs[i]);
    }

    BuildContext? _dialogContext;
    return Scaffold(

        body: ListView.builder(
            itemCount: newlogs.length,
            itemBuilder: (context, index) {
              Log? log = newlogs[index];
              _dialogContext = context;
              var timeStr = DateFormat('MM/dd hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(log.time!));
              return InkWell(
                onLongPress: ()=> {
                  _delete(context, log)

                },

                child: ExpansionTile(
                  initiallyExpanded: index == logProvider.selectedLogIndex,
                  key: Key(logProvider.selectedLogIndex.toString()),
                  onExpansionChanged: (isExpanded) {
                    setState(() {
                      if(isExpanded){
                        logProvider.selectLog(index);
                      }});                },
                  trailing: Text(timeStr,style: TextStyle(color: Colors.black54, fontSize: 12)),
                  leading:Icon(log.type == "Outgoing call" ? Icons.call_made : log.type == "Incoming call" ? Icons.call_received : log.type == "Missed call" ? Icons.call_missed_outlined : Icons.call_end),
                    title: Column(
                      children: [
                        Row(
                          children: [
                            Text(log.name == null ? log.contact.toString() : log.name!, style: TextStyle(fontSize: 18),),
                            Expanded(child: Container()),
                            // Text(timeStr,style: TextStyle(color: Colors.black54, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
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
                              log.name != null ?
                                Text("address: ${log.contact}")
                              : InkWell(
                                onTap: ()=>{
                                  print("Add contact")
                                },
                                child: Row(
                                  children: [
                                    Text("Add contact ", style: TextStyle(color: Colors.green),),
                                    Icon(Icons.add_circle, size: 14, color: Colors.green,)
                                  ],
                                ),
                              ),
                              SizedBox(height: size.height*0.02,),
                              Row(
                                children: [
                                  Text(log.type!),
                                  SizedBox(width: size.width *0.05,),
                                  Text(log.duration.toString(), style: TextStyle(color: Colors.black54)),
                                ],
                              ),
                              SizedBox(height: size.height*0.02,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: ()=>{
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(address: log.contact),))
                                    },
                                    child: Icon(Icons.call),
                                  ),
                                  SizedBox(width: size.height*0.15),
                                  InkWell(
                                    onTap: ()=>{
                                      if(log.name != null){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatBox(contact: Contact(id: int.parse(log.contact!), name: log.name)),))
                                      }else{
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatBox(contact: Contact(id: int.parse(log.contact!), name: "")),))
                                      }
                                    },
                                    child: Icon(Icons.message),
                                  ),
                                  SizedBox(width: size.height*0.15,),
                                  InkWell(
                                    onTap: ()=>{
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewContactScreen(isDetail: true),))
                                    },
                                    child: Icon(Icons.info),
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
                  ));}
        ),
      );

  }

  void _delete(BuildContext context, Log log) async {
    LogProvider logProvider = Provider.of(context, listen: false);
    String? confirm;
    confirm = await showConfirmDialog(context, "delete this log");
    if(confirm == "ok") {
      logProvider.deleteLog(context: context, log: log);
      logProvider.fetchLogData(context: context);
    }
  }
}
