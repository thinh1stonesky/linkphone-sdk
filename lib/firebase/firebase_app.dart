

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linphone_sdk/screen/home_screen.dart';
import 'package:linphone_sdk/screen/register_page.dart';
import 'package:provider/provider.dart';

import '../providers/features_provider.dart';

class FirebaseApp extends StatefulWidget {
  const FirebaseApp({Key? key}) : super(key: key);

  @override
  State<FirebaseApp> createState() => _FirebaseAppState();
}

class _FirebaseAppState extends State<FirebaseApp> {
  bool isError = false;
  bool isConnect = false;



  @override
  Widget build(BuildContext context) {
    FeaturesProvider featuresProvider = Provider.of(context,listen: true);
    featuresProvider.updateId(featuresProvider.registerInfo![1]);

    if(isError) {
      return Container(
          color: Colors.white,
          child: const Center(
            child: Text('Error!', style: TextStyle(fontSize: 18),
            ),
          )
      );
    } else
    if(!isConnect) {
      return Container(
          color: Colors.white,
          child: const Center(
            child: Text('Đang kết nối', style: TextStyle(fontSize: 18),
            ),
          )
      );
    }else{
      return MaterialApp(
        title: 'Firebase App',
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      );
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _khoiTaoFirebase();

    // FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    // featuresProvider.getRegisterInfo();
  }
  _khoiTaoFirebase() async{
    try{
      await Firebase.initializeApp();
      setState(() {
        isConnect = true;
      });
    }catch(e){
      print(e);
      setState(() {
        isError = true;
      });
    }
  }
}
