import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/student_model.dart';
import '../models/club_model.dart';
import '../models/event_model.dart';
import '../models/join_request_model.dart';

class DataProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  StudentModel? _currentStudent;
  ClubModel? _currentClub;

  StudentModel? get currentStudent => _currentStudent;
  ClubModel? get currentClub => _currentClub;

  // Load student data
  Future<void> loadStudent(String uid) async {
    _currentStudent = await _firestoreService.getStudent(uid);
    notifyListeners();
  }

  // Load club data
  Future<void> loadClub(String clubId) async {
    _currentClub = await _firestoreService.getClub(clubId);
    notifyListeners();
  }

  // Update student
  Future<void> updateStudent(StudentModel student) async {
    await _firestoreService.updateStudent(student);
    _currentStudent = student;
    notifyListeners();
  }

  // Update club
  Future<void> updateClub(ClubModel club) async {
    await _firestoreService.updateClub(club);
    _currentClub = club;
    notifyListeners();
  }

  // Add event
  Future<void> addEvent(EventModel event) async {
    await _firestoreService.addEvent(event);
  }

  // Update event
  Future<void> updateEvent(EventModel event) async {
    await _firestoreService.updateEvent(event);
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    await _firestoreService.deleteEvent(eventId);
  }

  // Submit join request
  Future<void> submitJoinRequest(JoinRequestModel request) async {
    await _firestoreService.submitJoinRequest(request);
  }

  // Accept join request - NOW USES THE FIRESTORE SERVICE METHOD
  Future<void> acceptJoinRequest(JoinRequestModel request) async {
    // Use the firestore service method that handles everything atomically
    await _firestoreService.acceptJoinRequest(request);
    
    // Reload club data to reflect updated member count
    if (_currentClub != null) {
      await loadClub(_currentClub!.clubId);
    }
  }

  // Reject join request
  Future<void> rejectJoinRequest(JoinRequestModel request) async {
    await _firestoreService.rejectJoinRequest(request);
  }

  // Remove member from club
  Future<void> removeMemberFromClub(String studentUid, String clubId) async {
    await _firestoreService.removeMemberFromClub(studentUid, clubId);
    
    // Reload club data to reflect updated member count
    if (_currentClub != null) {
      await loadClub(_currentClub!.clubId);
    }
  }

  // Get club by ID
  Future<ClubModel?> getClub(String clubId) async {
    return await _firestoreService.getClub(clubId);
  }

  // Check if student has pending request
  Future<bool> hasJoinRequest(String studentUid, String clubId) async {
    return await _firestoreService.hasJoinRequest(studentUid, clubId);
  }
}