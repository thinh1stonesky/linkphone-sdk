


import 'package:flutter/material.dart';
import 'package:linphone_sdk/providers/call_status_provider.dart';
import 'package:linphone_sdk/providers/contact_provider.dart';
import 'package:provider/provider.dart';
import 'package:linphone_sdk/providers/features_provider.dart';
import '../functions/call_functions.dart';
import '../models/contact.dart';

class MiniCallScreen extends StatefulWidget {

  @override
  State<MiniCallScreen> createState() => _MiniCallScreenState();
}

class _MiniCallScreenState extends State<MiniCallScreen> {
  // bool isMute = false;
  // bool isSpeakerOff = false;
  late ContactProvider contactProvider;
  late List<Contact> contacts = [];
  @override
  void initState() {
    // TODO: implement initState
    ContactProvider contactProvider = Provider.of(context, listen: false);
    contactProvider.fetchContactData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    CallStatusProvider callStatusProvider = Provider.of(context, listen: true);
    FeaturesProvider featuresProvider = Provider.of(context, listen: true);
    contactProvider = Provider.of(context, listen: true);


    featuresProvider.updateId(featuresProvider.registerInfo![1] );
    featuresProvider.updateDomain(featuresProvider.registerInfo![0] );
    contacts = contactProvider.getListContact;

    String name = "";
    for (int i = 0; i< contacts.length; i++){
      if (callStatusProvider.callerChannel == contacts[i].id.toString()){
        name = contacts[i].name!;
      }
    }

    return Stack(
        children: [
          Container(
            height: size.height *0.3,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10)
            ),
          ),
          if (featuresProvider.isCall || featuresProvider.isConference) Container(
              height: size.height *0.3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(featuresProvider.isConference ? "In conference" :callStatusProvider.call_State ?? "No call",style: const TextStyle(color: Colors.white),),
                    Text(featuresProvider.isConference ? "" :
                    callStatusProvider.callerChannel != "" ?
                    contactProvider.getListContact.where((element) => element.id.toString() == callStatusProvider.callerChannel).isNotEmpty
                        ? contactProvider.getListContact.where((element) => element.id.toString() == callStatusProvider.callerChannel).first.name!
                        : callStatusProvider.callerChannel!
                        : "",style: const TextStyle(color: Colors.white)),
                    buildTimer(featuresProvider.duration),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.all(Radius.circular(30))
                              ),
                              child: Center(
                                child: featuresProvider.isSpeakerOff ? Icon(Icons.volume_off) : Icon(Icons.volume_up_sharp),
                              ),
                            ),
                            onTap: (){
                              speakerOff();
                              setState((){
                                featuresProvider.updateIsSpeakerOff(!featuresProvider.isSpeakerOff);
                              });
                            },
                          ),
                          SizedBox(width: 20,),
                          InkWell(
                            onTap: () {
                              mute();
                              setState(() {
                                featuresProvider.updateIsMute(!featuresProvider.isMute);
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.all(Radius.circular(30))
                              ),
                              child: Center(
                                child: featuresProvider.isMute ? const Icon(Icons.mic_off) : const Icon(Icons.mic),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ) else Container()
        ]
    );
  }

  Widget buildTimer(Duration duration) {

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text(
      "$hours:$minutes:$seconds",
        style: const TextStyle(color: Colors.white)
    );
  }



}
