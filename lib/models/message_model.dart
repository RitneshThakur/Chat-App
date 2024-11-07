class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  DateTime? createdOn;
  bool? seen;

  MessageModel({this.sender, this.text, this.createdOn, this.seen,this.messageId});

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map['sender'];
    text = map['text'];
    createdOn = map['createdOn'].toDate();
    seen = map['seen'];
    messageId=map['messageId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
      'createdOn': createdOn,
      'seen': seen,
      "messageId":messageId
    };
  }
}
