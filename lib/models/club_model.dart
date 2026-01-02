import 'package:cloud_firestore/cloud_firestore.dart';

class ClubModel {
  final String clubId;
  final String clubName;
  final String clubDescription;
  final String clubCategory;
  final String clubEmail;
  final int totalMembers;
  final int totalCompletedEvents;
  final Map<String, String> clubPosts; // {post: studentUid}
  final DateTime createdAt;

  ClubModel({
    required this.clubId,
    required this.clubName,
    required this.clubDescription,
    required this.clubCategory,
    required this.clubEmail,
    this.totalMembers = 0,
    this.totalCompletedEvents = 0,
    this.clubPosts = const {},
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'clubId': clubId,
      'clubName': clubName,
      'clubDescription': clubDescription,
      'clubCategory': clubCategory,
      'clubEmail': clubEmail,
      'totalMembers': totalMembers,
      'totalCompletedEvents': totalCompletedEvents,
      'clubPosts': clubPosts,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ClubModel.fromMap(Map<String, dynamic> map) {
    return ClubModel(
      clubId: map['clubId'] ?? '',
      clubName: map['clubName'] ?? '',
      clubDescription: map['clubDescription'] ?? '',
      clubCategory: map['clubCategory'] ?? '',
      clubEmail: map['clubEmail'] ?? '',
      totalMembers: map['totalMembers'] ?? 0,
      totalCompletedEvents: map['totalCompletedEvents'] ?? 0,
      clubPosts: Map<String, String>.from(map['clubPosts'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  ClubModel copyWith({
    String? clubName,
    String? clubDescription,
    String? clubCategory,
    int? totalMembers,
    int? totalCompletedEvents,
    Map<String, String>? clubPosts,
  }) {
    return ClubModel(
      clubId: clubId,
      clubName: clubName ?? this.clubName,
      clubDescription: clubDescription ?? this.clubDescription,
      clubCategory: clubCategory ?? this.clubCategory,
      clubEmail: clubEmail,
      totalMembers: totalMembers ?? this.totalMembers,
      totalCompletedEvents: totalCompletedEvents ?? this.totalCompletedEvents,
      clubPosts: clubPosts ?? this.clubPosts,
      createdAt: createdAt,
    );
  }
}