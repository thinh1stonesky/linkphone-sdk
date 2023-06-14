

import 'package:flutter/material.dart';
import 'package:linphone_sdk/screen/chatbox.dart';
import 'package:provider/provider.dart';

import '../functions/dialog.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({Key? key}) : super(key: key);

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  late ContactProvider contactProvider;

  FocusNode _focusNode = FocusNode();
  TextEditingController _toCtrl = TextEditingController();
  String searchContent = "";
  @override
  void initState() {
    // TODO: implement initState
    ContactProvider contactProvider = Provider.of(context, listen: false);
    contactProvider.fetchContactData(context: context);
    _focusNode.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _toCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmitted(String value) {
    // Xử lý khi người dùng ấn Enter
    if(isNumeric(value)){
      Contact contact = Contact(name: "", id: int.parse(value));
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ChatBox(contact: contact),)
      );
      FocusScope.of(context).unfocus(); // Ẩn bàn phím
    }else{
      showSnackBar(context, "Invalid contact", 3);
    }
    
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      // Ẩn bàn phím khi trường nhập liệu không còn trong trạng thái focus
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    contactProvider = Provider.of(context, listen: true);
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Colors.black54))
                ),
                width: size.width,
                height: size.height * 0.11,
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.15,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: size.height *0.05,
                              child: Center(child: IconButton(onPressed: ()=> Navigator.of(context).pop(), icon: Icon(Icons.arrow_back,))),),
                          Container(
                              height: size.height *0.05,
                              child: Center(child: Text("To: ", style: TextStyle(fontSize: 16),)))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              height: size.height *0.05,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                  children:[ Text("New chat ", style: TextStyle(fontSize: 16),)])),
                          Container(
                              height: size.height *0.05,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _toCtrl,
                                        onSubmitted: _handleSubmitted,
                                        onChanged: (value)=>{
                                          setState(()=>searchContent = value
                                          )
                                        },
                                        textInputAction: TextInputAction.done,
                                        decoration: const InputDecoration(
                                          floatingLabelBehavior: FloatingLabelBehavior.never,
                                          labelText: "Enter name or phone number",
                                          border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                    IconButton(onPressed: ()=>_toCtrl.text ="", icon: Icon(Icons.clear))
                                  ]))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: contactProvider.getListContact.length,
                    itemBuilder: (context, index) {
                      Contact? contact = contactProvider.getListContact[index];
                      if(contact.id.toString().contains(searchContent!) || contact.name!.toLowerCase().contains(searchContent!)){
                        return AnimatedContainer(
                          curve: Curves.linear,
                          duration: Duration(milliseconds: 3000),
                          child: InkWell(
                            onTap: ()=>Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ChatBox(contact: contact),)
                            ),
                            child: ListTile(
                              // controller:listExpandState[index],
                              leading: CircleAvatar(
                                radius: size.width*0.04,
                                backgroundColor: Colors.blue,
                                child: Text(contact.name!.substring(0, 1).toUpperCase()),
                              ),
                              title: Text('${contact.name}'),
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
        ),
      );

  }
}
