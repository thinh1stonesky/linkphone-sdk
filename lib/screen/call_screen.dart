


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linphone_sdk/models/constants.dart';
import 'list_contacts_meet.dart';
import 'package:linphone_sdk/providers/call_status_provider.dart';
import 'package:linphone_sdk/providers/features_provider.dart';
import 'package:provider/provider.dart';
import 'package:linphone_sdk/functions/dialog.dart';
import '../functions/call_functions.dart';
import 'mini_call_screen.dart';


class CallScreen extends StatefulWidget {
  CallScreen({Key? key, this.address}) : super(key: key);
  String? address;
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  TextEditingController addressCtrl = TextEditingController();

  String? address;

  TextEditingController tranferNB = TextEditingController();
  TextEditingController addParticipantNB = TextEditingController();

  @override
  void initState() {
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    featuresProvider.isDisableMeetButton = false;
    featuresProvider.isDisableCoachingButton = false;
    featuresProvider.isDisableMonitoringButton = false;
    address = widget.address ?? "";
    addressCtrl.text = address == "" ? "" : address!;
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    BuildContext dialogContext = context;
    CallStatusProvider callStatusProvider = Provider.of(context, listen: true);
    FeaturesProvider featuresProvider = Provider.of(context, listen: true);

    // featuresProvider.updateId(featuresProvider.registerInfo![1] );
    // featuresProvider.updateDomain(featuresProvider.registerInfo![0] );


    callChannel.setMethodCallHandler((call) async {
      invokedMethods(call: call, context: context, className: this.runtimeType.toString());
    });
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("My adress: " + featuresProvider.id.toString()),
                    Row(
                      children:[
                        Text("Status: ")
                        ,CircleAvatar(
                        radius: 5,
                        backgroundColor: callStatusProvider.registation_state == "Registration successful" ? Colors.green : Colors.red,
                      ),
                    ]
                    )
                  ],
                ),
                const SizedBox(height: 5,),
                const Divider(height: 1, color: Colors.black54, ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(callStatusProvider.callerID ?? "", style: const TextStyle(fontSize: 20),)],
                  ),
                ),
                MiniCallScreen(),
                const SizedBox(height: 10),

                //address
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                        controller: addressCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                            hintText: "Who do you want to call?"
                        ),
                      ),
                      SizedBox(height: 5,),
                      SizedBox(height: 5,),
                      //row 1
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: featuresProvider.isDisablePauseButton ? null :  (){
                                  pause();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.pause),
                                    SizedBox(width: 10,),
                                    Text('Pause'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: featuresProvider.isDisableTranferButton ? null :() async{
                                  String res = await _dialogTranfer(dialogContext, size);
                                  res == "ok" ? callTranfer(tranferNB.text, context) : showSnackBar(context, "No transfer", 3);
                                  // tranferNB.text = "";
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.arrow_circle_right),
                                    SizedBox(width: 10,),
                                    Text('Tranfer'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),

                      //row 2
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: featuresProvider.isDisableMeetButton ? null : () async{
                                  // createConference();
                                  _dialogMeet(context);
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.supervised_user_circle_rounded),
                                    SizedBox(width: 10,),
                                    Text('Conference'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: featuresProvider.isDisablePickupButton ? null : (){
                                  accept();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.phone_callback),
                                    SizedBox(width: 10,),
                                    Text('Pick up'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: (!featuresProvider.isCall && !featuresProvider.isConference) ? Colors.blue: Colors.red,
                    child: (!featuresProvider.isCall && !featuresProvider.isConference) ? Icon(Icons.phone, color: Colors.white, size: 30,) : Icon(Icons.call_end_outlined, color: Colors.white, size: 30,)
                  ),
                  onTap: ()=>{
                    call(addressCtrl.text, context)
                  },
                ),
              ],
            ),
          ),
        ),
      );
  }

  Future _dialogTranfer( BuildContext context, Size size) async {

    var dialog = AlertDialog(
      title: Text('Tranfer'),
      content: Row(
        children: [
          Expanded(
              child: TextField(
                controller: tranferNB,
                enabled: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder()
                ),
          ))
        ],
      ),

      actions: [

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildRow("1", "2", "3"),
                buildRow("4", "5", "6"),
                buildRow("7", "8", "9"),
                buildRow("*", "0", "#"),
                Row(
                  children: [
                    ElevatedButton(onPressed: (){
                      if(tranferNB.text.length >= 1){
                        tranferNB.text = tranferNB.text.substring(0, tranferNB.text.length-1);
                      }
                    }, child: Text("<")),
                    SizedBox(width: 10,),
                    ElevatedButton(onPressed: (){
                      tranferNB.text = "${tranferNB.text}+";
                    }, child: Text("+")),
                    SizedBox(width: 10,),
                    ElevatedButton(onPressed: (){
                      tranferNB.text = "";
                    }, child: Text("C")),
                  ],
                ),
              ],
            ),
          ],
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(onPressed: (){
                  // var provider = context.read<QLSanPham>();
                  //provider.delete(index);
                  if(tranferNB.text != ""){
                    Navigator.of(context, rootNavigator: true).pop("ok");
                  }else{
                    Navigator.of(context, rootNavigator: true).pop("cancel");
                  }
                },
                    child: Text("Tranfer")
                ),
              ),
              SizedBox(width: size.width*0.05,),
              Expanded(
                child: ElevatedButton(onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop("cancel");
                },
                    child: Text("Cancel")
                ),
              )
            ],
          ),
        )

      ],
    );
    String? res = await showDialog<String>(
      //barrierDismissible: false,
      context: context,
      builder: (context) => dialog,
    );
    return res;

  }

  Widget buildRow(String a, String b, String c){
    return Row(
      children: [
        ElevatedButton(onPressed: ()=>{
          tranferNB.text = "${tranferNB.text}"+a
        }, child: Text(a)),
        SizedBox(width: 10,),
        ElevatedButton(onPressed: ()=>{
          tranferNB.text = "${tranferNB.text}"+b
        }, child: Text(b)),
        SizedBox(width: 10,),
        ElevatedButton(onPressed: ()=>{
          tranferNB.text = "${tranferNB.text}"+c
        }, child: Text(c)),

      ],
    );
  }
  Future _dialogMeet( BuildContext context) async {
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    var dialog = AlertDialog(
      title: Text('Add participants'),
      content: SizedBox(
        width: 300,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: addParticipantNB,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    )),
                ElevatedButton(onPressed: (){
                  featuresProvider.isDisablePauseButton = true;

                  addParticipant(addParticipantNB.text, context);
                  addParticipantNB.text = "";
                  // featuresProvider.addContacts(addParticipantNB.text);
                }, child: const Text("+"))
              ],
            ),
            const SizedBox(
              height: 300,
              child: ListContactsMeet(),
            )
          ],
        ),
      ),

      actions: [
        ElevatedButton(onPressed: (){
          addParticipantNB.text = "";
          Navigator.of(context, rootNavigator: true).pop();

        },
            child: Text("Done")
        ),
      ],

    );
    showDialog<String>(
      //barrierDismissible: false,
      context: context,
      builder: (context) => dialog,
    );

  }

}
