import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String eventId;
  final String clubId;
  final String eventName;
  final String eventDescription;
  final DateTime eventDate;
  final String eventLocation;
  final bool isCompleted;
  final DateTime createdAt;

  EventModel({
    required this.eventId,
    required this.clubId,
    required this.eventName,
    required this.eventDescription,
    required this.eventDate,
    required this.eventLocation,
    this.isCompleted = false,
    required this.createdAt,
  });

  bool get isUpcoming => eventDate.isAfter(DateTime.now()) && !isCompleted;
  bool get isPast => eventDate.isBefore(DateTime.now()) || isCompleted;

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'clubId': clubId,
      'eventName': eventName,
      'eventDescription': eventDescription,
      'eventDate': Timestamp.fromDate(eventDate),
      'eventLocation': eventLocation,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      eventId: map['eventId'] ?? '',
      clubId: map['clubId'] ?? '',
      eventName: map['eventName'] ?? '',
      eventDescription: map['eventDescription'] ?? '',
      eventDate: (map['eventDate'] as Timestamp).toDate(),
      eventLocation: map['eventLocation'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  EventModel copyWith({
    String? eventName,
    String? eventDescription,
    DateTime? eventDate,
    String? eventLocation,
    bool? isCompleted,
  }) {
    return EventModel(
      eventId: eventId,
      clubId: clubId,
      eventName: eventName ?? this.eventName,
      eventDescription: eventDescription ?? this.eventDescription,
      eventDate: eventDate ?? this.eventDate,
      eventLocation: eventLocation ?? this.eventLocation,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}