

import 'package:flutter/material.dart';
import 'package:linphone_sdk/functions/dialog.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import '../providers/contact_provider.dart';

class NewContactScreen extends StatefulWidget {
  NewContactScreen({Key? key, this.contact, this.isDetail}) : super(key: key);
  Contact? contact;
  bool? isDetail;
  @override
  State<NewContactScreen> createState() => _NewContactScreenState();
}

class _NewContactScreenState extends State<NewContactScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneNumCtrl = TextEditingController();
  Contact? contact;
  bool? isDetail;
  @override
  void initState() {
    contact = widget.contact;
    isDetail = widget.isDetail;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _nameCtrl.text = contact?.name ?? "";
    _phoneNumCtrl.text = contact?.id.toString() ?? "";
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: ()=> Navigator.of(context).pop(),
              child: Icon(Icons.clear)),
          title: Text("Create new contact",),
          actions: [
            isDetail == null ? Container():Padding(
              padding: EdgeInsets.only(right: size.width * 0.05, top: size.height * 0.015, bottom: size.height * 0.015),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton(
                  onPressed: () {
                    ContactProvider contactProvider = Provider.of(context, listen: false);

                    if(contact != null){
                      contact!.name = _nameCtrl.text;
                      contactProvider.updateContact(context: context, contact: contact!);
                    }else{
                      contactProvider.addContact(context: context, name: _nameCtrl.text, id: int.parse(_phoneNumCtrl.text));
                    }
                    contactProvider.fetchContactData(context: context);

                    setState(() {

                    });
                    Navigator.pop(context);
                    showSnackBar(context, "saved", 3);
                    _nameCtrl.text = "";
                    _phoneNumCtrl.text = "";
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(left: size.width * 0.03),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  CircleAvatar(
                    radius: size.width*0.1,
                    child: Image.asset("assets/profile-user.png", color: Colors.blue,),
                    backgroundColor: Colors.white,
                  )
                ] ,
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Row(
                  children: [
                    Image.asset("assets/user.png", width: size.width * 0.05,),
                    SizedBox(width: size.width * 0.025,),
                    Expanded(
                        flex: 9,
                        child: TextField(
                          enabled: isDetail == null ? true :false,
                          textInputAction: TextInputAction.next,
                          //onSubmitted: (_) => FocusScope.of(context).nextFocus,
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                              ),
                              label: Text("name")
                          ),
                          onChanged: (text) {

                          },
                        )),
                    SizedBox(width: size.width * 0.025,),
                  ],
                ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              Row(
                children: [
                  Image.asset("assets/phone.png", width: size.width * 0.05,),
                  SizedBox(width: size.width * 0.025,),
                  Expanded(
                    flex: 9,
                    child: TextField(
                      // enabled: contact == null ? true :false,
                      textInputAction: TextInputAction.done,
                      controller: _phoneNumCtrl,
                      enabled: contact == null ? true :false,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Phone number')
                      ),
                      onChanged: (text) {

                      },
                    ),
                  ),
                  SizedBox(width: size.width * 0.025,),
                ],
              ),
            ]
          ),
        )
      );

  }
}
