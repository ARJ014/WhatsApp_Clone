import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class GroupModel {
  final String senderId;
  final String name;
  final String groupId;
  final String lastmessage;
  final String groupPic;
  final List memeberUid;
  final DateTime time;

  GroupModel({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.lastmessage,
    required this.groupPic,
    required this.memeberUid,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'lastmessage': lastmessage,
      'groupPic': groupPic,
      'memeberUid': memeberUid,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
        senderId: map['senderId'] as String,
        name: map['name'] as String,
        groupId: map['groupId'] as String,
        lastmessage: map['lastmessage'] as String,
        groupPic: map['groupPic'] as String,
        memeberUid: List.from((map['memeberUid'] as List)),
        time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int));
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
