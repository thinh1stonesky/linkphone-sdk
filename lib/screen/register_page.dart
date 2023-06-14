

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linphone_sdk/firebase/firebase_app.dart';
import 'package:linphone_sdk/functions/call_functions.dart';
import 'package:linphone_sdk/models/constants.dart';
import 'package:linphone_sdk/providers/features_provider.dart';
import 'package:linphone_sdk/screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController idCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController domainCtrl = TextEditingController();

  FeaturesProvider? featuresProvider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    featuresProvider.getRegisterInfo();
  }

  bool? isSave = false;
  bool? flag = false;
  int flagcount = 1;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    callChannel.setMethodCallHandler((call) async {
      invokedMethods(call: call, context: context);
    });

    FeaturesProvider featuresProvider = Provider.of(context, listen: true);


    // callChannel.setMethodCallHandler((call)  async{
    //   invokedMethods(call: call, context: context);    });


    // List<String> registerInfo = featuresProvider.getRegisterInfo();
    // List<String> listInfo = featuresProvider.registerInfo!;


    if (flag == false || flagcount <= 2) {
      idCtrl.text = featuresProvider.registerInfo![1];
      passwordCtrl.text = featuresProvider.registerInfo![2];
      domainCtrl.text = featuresProvider.registerInfo![0];
      isSave = featuresProvider.isSave;
      flag = true;
      flagcount++;
    }

    // idCtrl.text = "102";
    // passwordCtrl.text = "102";
    // domainCtrl.text = "192.168.61.112";


    return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo.png', height: 70, width: 70,),
                      SizedBox(width: 20,),
                      const Text(
                        "Linphone \nSDK",
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                  ),
                  SizedBox(height: 30,),
                  Container(
                    padding: EdgeInsets.all(20),
                    height: size.height * 0.53,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.greenAccent
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Domain'),
                        TextField(
                          controller: domainCtrl,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(8),
                              isDense: true
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text('ID'),
                        TextField(
                          controller: idCtrl,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(8),
                              isDense: true
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text('Password'),
                        TextField(
                          obscureText: true,
                          controller: passwordCtrl,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                              ),
                              contentPadding: EdgeInsets.all(8),
                              isDense: true
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: isSave,
                              onChanged: (value) {
                                isSave = value!;
                                setState(() {

                                });
                              },),
                            Text('Save ID'),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (
                                          context) => HomeScreen(),)
                                  );
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  featuresProvider.updateId(idCtrl.text);


                                  // if (registerState == "ok") {
                                    if (isSave == true) {
                                      await prefs.setStringList("registerInfo", [domainCtrl.text, idCtrl.text, passwordCtrl.text]);
                                      await prefs.setBool("isSave", true);
                                    } else {
                                      await prefs.setStringList("registerInfo", ["", "", ""]);
                                      await prefs.setBool("isSave", false);
                                    }
                                    featuresProvider.getRegisterInfo();
                                  await register(
                                      domainCtrl.text, idCtrl.text,
                                      passwordCtrl.text, context);
                                  // }
                                },
                                child: Text('Register')))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
      );

  }

}