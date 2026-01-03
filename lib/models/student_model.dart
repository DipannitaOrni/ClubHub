import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String uid;
  final String fullName;
  final String email;
  final String levelTerm;
  final String department;
  final String contactNumber;
  final List<String> fieldsOfInterest;
  final List<String> joinedClubs; // Club IDs
  final List<String> registeredEvents; // Event IDs
  final DateTime createdAt;

  StudentModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.levelTerm,
    required this.department,
    required this.contactNumber,
    required this.fieldsOfInterest,
    this.joinedClubs = const [],
    this.registeredEvents = const [],
    required this.createdAt,
  });

  // Get batch from email (e.g., u2104129@student.cuet.ac.bd -> "21")
  String get batch {
    if (email.startsWith('u')) {
      return email.substring(1, 3);
    }
    return 'Unknown';
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'levelTerm': levelTerm,
      'department': department,
      'contactNumber': contactNumber,
      'fieldsOfInterest': fieldsOfInterest,
      'joinedClubs': joinedClubs,
      'registeredEvents': registeredEvents,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      levelTerm: map['levelTerm'] ?? '',
      department: map['department'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      fieldsOfInterest: List<String>.from(map['fieldsOfInterest'] ?? []),
      joinedClubs: List<String>.from(map['joinedClubs'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      registeredEvents: List<String>.from(map['registeredEvents'] ?? []),
    );
  }

  StudentModel copyWith({
    String? fullName,
    String? levelTerm,
    String? department,
    String? contactNumber,
    List<String>? fieldsOfInterest,
    List<String>? joinedClubs,
    List<String>? registeredEvents,
  }) {
    return StudentModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email,
      levelTerm: levelTerm ?? this.levelTerm,
      department: department ?? this.department,
      contactNumber: contactNumber ?? this.contactNumber,
      fieldsOfInterest: fieldsOfInterest ?? this.fieldsOfInterest,
      joinedClubs: joinedClubs ?? this.joinedClubs,
      registeredEvents: registeredEvents ?? this.registeredEvents,
      createdAt: createdAt,
    );
  }
}
