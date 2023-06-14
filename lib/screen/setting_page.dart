import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linphone_sdk/providers/call_status_provider.dart';
import 'package:linphone_sdk/providers/features_provider.dart';
import 'package:linphone_sdk/screen/register_page.dart';
import 'package:provider/provider.dart';

import '../functions/call_functions.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key,}) : super(key: key);


  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  MethodChannel callChannel = const MethodChannel("com.example.linphone_sdk/call");



  late CallStatusProvider callStatusProvider;
  late FeaturesProvider featuresProvider;

  late String asterisk_connection = "yes";




  Slider sliderMic(){
    // FeaturesProvider provider = Provider.of(context, listen: true);
    return Slider(
        value: featuresProvider.sliderMicValue,
        max: 15,
        divisions: 6,
        min: -15,
        onChanged: (val) => setState(() {
          FeaturesProvider provider = Provider.of(context, listen: false);
          provider.updateIsMute(false);
          provider.updateSliderMicValue(val);

          adjustMic(val);
        }));
  }
  Slider sliderVolumn(){
    // FeaturesProvider provider = Provider.of(context, listen: true);
    return Slider(
        value: featuresProvider.sliderVolumeValue,
        divisions: 6,
        max: 15,
        min: -15,
        onChanged: (val) => setState(() {
          FeaturesProvider provider = Provider.of(context, listen: false);
          provider.updateIsSpeakerOff(false);
          provider.updateSliderVolumeValue(val);

          adjustAudio(val);
        }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FeaturesProvider featuresProvider = Provider.of(context, listen: true);
    // slider_mic = featuresProvider.sliderMicValue;
    // slider_volumn = featuresProvider.sliderVolumeValue;
  }

  @override
  Widget build(BuildContext context) {

    callChannel.setMethodCallHandler((call) async {
      invokedMethods(call: call, context: context);
    });

    callStatusProvider = Provider.of(context, listen: true);
    featuresProvider = Provider.of(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: Icon(Icons.arrow_back)),
          title: Text("Settings"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Text("User state: ${callStatusProvider.registation_state}"),
              // Text('Asterisk connection: $asterisk_connection'),

              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mic),
                  sliderMic(),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.volume_down),
                  sliderVolumn(),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () async{
                              String userState = await unregister();
                              // if(userState == "unregistered"){
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => const RegisterPage(),)
                                );
                              // }
                            },
                            child: Text("Unregister"),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              onPressed: () async{
                                String userState = await delete();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => const RegisterPage(),)
                                  );
                              },
                              child: Text("Delete")),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );

  }

  Future<String> unregister() async {
    try{
      String userState = await callChannel.invokeMethod("unregister");

      print(userState);

      return userState;
    } on PlatformException catch(e){
      print(e);
    }
    return "";
  }

  Future<String> delete() async {
    try{
      String userState = await callChannel.invokeMethod("delete");

      print(userState);
      return userState;
    } on PlatformException catch(e){
      print(e);
    }
    return "";
  }
}
