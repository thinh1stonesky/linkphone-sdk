
import 'package:flutter/material.dart';
import 'package:linphone_sdk/providers/contact_provider.dart';
import 'package:linphone_sdk/screen/call_screen.dart';
import 'package:linphone_sdk/screen/contacts_screen.dart';
import 'package:linphone_sdk/screen/log_screen.dart';
import 'package:linphone_sdk/screen/setting_page.dart';
import 'package:provider/provider.dart';

import '../functions/call_functions.dart';
import '../providers/features_provider.dart';
import 'messages_screen.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, this.currentIndex = 0, this.address});

  int? currentIndex;
  String? address;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;
  late String userState;
  String? address;

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneNumCtrl = TextEditingController();


  void init()async{

    ContactProvider contactProvider = Provider.of(context, listen: false);
    FeaturesProvider featuresProvider = Provider.of(context, listen: false);
    await featuresProvider.getRegisterInfo();
    // awaitcontactProvider.fetchContactData(context: context);
    await checkInCall(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = widget.currentIndex!;
    address = widget.address ?? "";
    // userState = widget.userState ?? "";
    init();
  }


  @override
  Widget build(BuildContext context) {
    final tabs= [
      address != "" ? CallScreen(address: address) : CallScreen(),
      LogScreen(pContext: context),
      MessageScreen(pContext: context),
      Contacts(pContext: context),
    ];
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset('assets/logo.png', height: 30, width: 30,),
              const SizedBox(width: 10,),
              const Text('Linphone SDK')
            ],
          ),
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingPage(),)),
                icon: Icon(Icons.settings)
            )
          ],
        ),
        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index)=>setState(() {
            setState(() {
              _currentIndex = index;
            });
          }),
          selectedFontSize: 17,
          unselectedFontSize: 13,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.call),
                label: 'Call'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_books_rounded),
                label: 'Logs'),
            BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Message'),
            BottomNavigationBarItem(
                icon: Icon(Icons.perm_contact_calendar),
                label: 'Contacts'),
          ],
        ),
      );

  }
}

