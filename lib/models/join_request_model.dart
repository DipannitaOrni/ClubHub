import 'package:cloud_firestore/cloud_firestore.dart';

class JoinRequestModel {
  final String requestId;
  final String clubId;
  final String studentUid;
  final String studentName;
  final String studentEmail;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime requestedAt;

  JoinRequestModel({
    required this.requestId,
    required this.clubId,
    required this.studentUid,
    required this.studentName,
    required this.studentEmail,
    this.status = 'pending',
    required this.requestedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'clubId': clubId,
      'studentUid': studentUid,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'status': status,
      'requestedAt': Timestamp.fromDate(requestedAt),
    };
  }

  factory JoinRequestModel.fromMap(Map<String, dynamic> map) {
    return JoinRequestModel(
      requestId: map['requestId'] ?? '',
      clubId: map['clubId'] ?? '',
      studentUid: map['studentUid'] ?? '',
      studentName: map['studentName'] ?? '',
      studentEmail: map['studentEmail'] ?? '',
      status: map['status'] ?? 'pending',
      requestedAt: (map['requestedAt'] as Timestamp).toDate(),
    );
  }

  JoinRequestModel copyWith({String? status}) {
    return JoinRequestModel(
      requestId: requestId,
      clubId: clubId,
      studentUid: studentUid,
      studentName: studentName,
      studentEmail: studentEmail,
      status: status ?? this.status,
      requestedAt: requestedAt,
    );
  }
}