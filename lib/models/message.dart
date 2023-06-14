

class Chat{
  String? content;
  bool? isOutgoing;
  int? time;
  Chat({
    this.content,
    this.isOutgoing,
    this.time
  }){
    // id = Random().nextInt(1000);
  }


  Map<String, dynamic> toJson(){
    return {
      'content' : content,
      'isOutgoing' : isOutgoing,
      'time' : time
    };
  }
}

class Messages {
  String? contact;
  List<Chat>? chatlist;

  Messages({
    this.contact,
    this.chatlist,
  }) {
    // id = Random().nextInt(1000);
  }
}