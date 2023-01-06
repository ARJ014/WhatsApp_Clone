// ignore_for_file: public_member_api_docs, sort_constructors_first

class userModel {
  final String name;
  final String uid;
  final String profilePic;
  final String phone;
  final List<String> groupId;
  final bool isonline;
  userModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.phone,
    required this.groupId,
    required this.isonline,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'phone': phone,
      'groupId': groupId,
      'isonline': isonline,
    };
  }

  factory userModel.fromMap(Map<String, dynamic> map) {
    return userModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isonline: map['isonline'] ?? false,
      phone: map['phone'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }
}
