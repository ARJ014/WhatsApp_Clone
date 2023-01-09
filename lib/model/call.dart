// ignore_for_file: public_member_api_docs, sort_constructors_first
class Call {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String recieverId;
  final String recieverName;
  final String recieverPic;
  final bool hasDialed;
  final String callId;

  Call({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.recieverId,
    required this.recieverName,
    required this.recieverPic,
    required this.hasDialed,
    required this.callId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'recieverId': recieverId,
      'recieverName': recieverName,
      'recieverPic': recieverPic,
      'hasDialed': hasDialed,
      'callId': callId,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callerId: map['callerId'] as String,
      callerName: map['callerName'] as String,
      callerPic: map['callerPic'] as String,
      recieverId: map['recieverId'] as String,
      recieverName: map['recieverName'] as String,
      recieverPic: map['recieverPic'] as String,
      hasDialed: map['hasDialed'] as bool,
      callId: map['callId'] as String,
    );
  }
}
