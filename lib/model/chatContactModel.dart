// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatContactModel {
  final String name;
  final String profilePic;
  final DateTime time;
  final String lastmessage;
  final String contactId;

  ChatContactModel({
    required this.name,
    required this.profilePic,
    required this.time,
    required this.lastmessage,
    required this.contactId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'time': time.millisecondsSinceEpoch,
      'lastmessage': lastmessage,
      'contactId': contactId,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      contactId: map['contactId'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      lastmessage: map['lastmessage'] ?? '',
    );
  }
}
