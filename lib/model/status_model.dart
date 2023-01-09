import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class StatusModel {
  final String uid;
  final String username;
  final List photoUrl;
  final String profilePic;
  final DateTime createdAt;
  final String statusId;
  final String phone;
  final List<String> whoCanSee;

  StatusModel({
    required this.uid,
    required this.username,
    required this.photoUrl,
    required this.profilePic,
    required this.createdAt,
    required this.statusId,
    required this.phone,
    required this.whoCanSee,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'photoUrl': photoUrl,
      'profilePic': profilePic,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'statusId': statusId,
      'phone': phone,
      'whoCanSee': whoCanSee,
    };
  }

  static StatusModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return StatusModel(
        uid: snapshot['uid'],
        username: snapshot['username'],
        photoUrl: List.from(snapshot['photoUrl']),
        profilePic: snapshot['profilePic'],
        createdAt: DateTime.now(),
        statusId: snapshot['statusId'],
        phone: snapshot['phone'],
        whoCanSee: []);
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      uid: map['uid'] as String,
      username: map['username'] as String,
      photoUrl: List<String>.from((map['photoUrl'])),
      profilePic: map['profilePic'] as String,
      createdAt: DateTime.now(),
      statusId: map['statusId'] as String,
      phone: map['phone'] as String,
      whoCanSee: (map['whoCanSee']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusModel.fromJson(String source) =>
      StatusModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
