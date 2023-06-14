import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linphone_sdk/firebase/firebase_app.dart' as fb;
import 'package:linphone_sdk/providers/call_status_provider.dart';
import 'package:linphone_sdk/providers/contact_provider.dart';
import 'package:linphone_sdk/providers/features_provider.dart';
import 'package:linphone_sdk/providers/log_provider.dart';
import 'package:linphone_sdk/providers/message_provider.dart';
import 'package:linphone_sdk/screen/register_page.dart';
import 'package:provider/provider.dart';
import 'functions/call_functions.dart';
import 'functions/service.dart';
import 'models/constants.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LogProvider(),),
          ChangeNotifierProvider(create: (context) => CallStatusProvider(),),
          ChangeNotifierProvider(create: (context) => MessageProvider(),),
          ChangeNotifierProvider(create: (context) => ContactProvider(),),
          ChangeNotifierProvider(create: (context) => FeaturesProvider(),)
      ],
    child:  MyApp()),
  );

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.


  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  _MyAppState(){
    callChannel.setMethodCallHandler((call)async{
      if(call.method == MESSAGE_DELIVERED )
        invokedMethods(call: call, context: context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);

    if(state.toString() == 'AppLifecycleState.paused' || state.toString() == 'AppLifecycleState.inactive') {
      featuresProvider.isInBackgroud = true;
    }else{
      featuresProvider.isInBackgroud = false;
    }
    print('App state changed to: $state');
  }

  initialService() async {
    await initializeService();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initialService();
    // String id = "100";
    // String password = "100";
    // String domain = "192.168.61.10";
    // register(domain, id, password, context);
    // FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    // featuresProvider.getRegisterInfo();
    // FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    // featuresProvider.getRegisterInfo();
  }

    @override
    void dispose() {
      WidgetsBinding.instance.removeObserver(this);
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    // FeaturesProvider featuresProvider = Provider.of(context, listen: true);
    // String id = featuresProvider.registerInfo![1] ?? "";
    // featuresProvider.updateId(id);
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const fb.FirebaseApp(),

    );
  }
}


