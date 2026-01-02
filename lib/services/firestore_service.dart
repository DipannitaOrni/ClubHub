import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';
import '../models/club_model.dart';
import '../models/event_model.dart';
import '../models/join_request_model.dart';
import '../utils/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============= STUDENT OPERATIONS =============

  // Get student by UID
  Future<StudentModel?> getStudent(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(AppConstants.studentsCollection).doc(uid).get();
      if (doc.exists) {
        return StudentModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Update student profile
  Future<void> updateStudent(StudentModel student) async {
    await _firestore.collection(AppConstants.studentsCollection).doc(student.uid).update(student.toMap());
  }

  // ============= CLUB OPERATIONS =============

  // Get club by ID
  Future<ClubModel?> getClub(String clubId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(AppConstants.clubsCollection).doc(clubId).get();
      if (doc.exists) {
        return ClubModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get all clubs
  Stream<List<ClubModel>> getAllClubs() {
    return _firestore.collection(AppConstants.clubsCollection).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => ClubModel.fromMap(doc.data())).toList(),
    );
  }

  // Update club
  Future<void> updateClub(ClubModel club) async {
    await _firestore.collection(AppConstants.clubsCollection).doc(club.clubId).update(club.toMap());
  }

  // ============= EVENT OPERATIONS =============

  // Add event
  Future<void> addEvent(EventModel event) async {
    await _firestore.collection(AppConstants.eventsCollection).doc(event.eventId).set(event.toMap());
  }

  // Get events by club ID
  Stream<List<EventModel>> getEventsByClub(String clubId) {
    return _firestore
        .collection(AppConstants.eventsCollection)
        .where('clubId', isEqualTo: clubId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => EventModel.fromMap(doc.data())).toList(),
        );
  }

  // Get events by club IDs (for students)
  Stream<List<EventModel>> getEventsByClubs(List<String> clubIds) {
    if (clubIds.isEmpty) {
      return Stream.value([]);
    }
    return _firestore
        .collection(AppConstants.eventsCollection)
        .where('clubId', whereIn: clubIds)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => EventModel.fromMap(doc.data())).toList(),
        );
  }

  // Get all events
  Stream<List<EventModel>> getAllEvents() {
    return _firestore.collection(AppConstants.eventsCollection).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => EventModel.fromMap(doc.data())).toList(),
    );
  }

  // Update event
  Future<void> updateEvent(EventModel event) async {
    await _firestore.collection(AppConstants.eventsCollection).doc(event.eventId).update(event.toMap());
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection(AppConstants.eventsCollection).doc(eventId).delete();
  }

  // ============= JOIN REQUEST OPERATIONS =============

  // Submit join request
  Future<void> submitJoinRequest(JoinRequestModel request) async {
    await _firestore.collection(AppConstants.joinRequestsCollection).doc(request.requestId).set(request.toMap());
  }

  // Get join requests for club
  Stream<List<JoinRequestModel>> getJoinRequestsByClub(String clubId) {
    return _firestore
        .collection(AppConstants.joinRequestsCollection)
        .where('clubId', isEqualTo: clubId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => JoinRequestModel.fromMap(doc.data())).toList(),
        );
  }

  // Update join request
  Future<void> updateJoinRequest(JoinRequestModel request) async {
    await _firestore.collection(AppConstants.joinRequestsCollection).doc(request.requestId).update(request.toMap());
  }

  // Check if student already requested to join
  Future<bool> hasJoinRequest(String studentUid, String clubId) async {
    QuerySnapshot snapshot = await _firestore
        .collection(AppConstants.joinRequestsCollection)
        .where('studentUid', isEqualTo: studentUid)
        .where('clubId', isEqualTo: clubId)
        .where('status', isEqualTo: 'pending')
        .get();
    return snapshot.docs.isNotEmpty;
  }

  // Get members by club ID
  Stream<List<StudentModel>> getMembersByClub(String clubId) {
    return _firestore
        .collection(AppConstants.studentsCollection)
        .where('joinedClubs', arrayContains: clubId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => StudentModel.fromMap(doc.data())).toList(),
        );
  }

  // ============= ACCEPT/REJECT JOIN REQUEST =============

  // Accept join request - THIS IS THE KEY METHOD!
  Future<void> acceptJoinRequest(JoinRequestModel request) async {
    try {
      WriteBatch batch = _firestore.batch();

      // 1. Update request status to 'accepted'
      DocumentReference requestRef = _firestore
          .collection(AppConstants.joinRequestsCollection)
          .doc(request.requestId);
      batch.update(requestRef, {'status': 'accepted'});

      // 2. Add club to student's joinedClubs array
      DocumentReference studentRef = _firestore
          .collection(AppConstants.studentsCollection)
          .doc(request.studentUid);
      batch.update(studentRef, {
        'joinedClubs': FieldValue.arrayUnion([request.clubId])
      });

      // 3. Increment club's totalMembers count
      DocumentReference clubRef = _firestore
          .collection(AppConstants.clubsCollection)
          .doc(request.clubId);
      batch.update(clubRef, {
        'totalMembers': FieldValue.increment(1)
      });

      // Execute all operations atomically
      await batch.commit();
    } catch (e) {
      print('Error accepting join request: $e');
      rethrow;
    }
  }

  // Reject join request
  Future<void> rejectJoinRequest(JoinRequestModel request) async {
    try {
      await _firestore
          .collection(AppConstants.joinRequestsCollection)
          .doc(request.requestId)
          .update({'status': 'rejected'});
    } catch (e) {
      print('Error rejecting join request: $e');
      rethrow;
    }
  }

  // Remove member from club
  Future<void> removeMemberFromClub(String studentUid, String clubId) async {
    try {
      WriteBatch batch = _firestore.batch();

      // 1. Remove club from student's joinedClubs array
      DocumentReference studentRef = _firestore
          .collection(AppConstants.studentsCollection)
          .doc(studentUid);
      batch.update(studentRef, {
        'joinedClubs': FieldValue.arrayRemove([clubId])
      });

      // 2. Decrement club's totalMembers count
      DocumentReference clubRef = _firestore
          .collection(AppConstants.clubsCollection)
          .doc(clubId);
      batch.update(clubRef, {
        'totalMembers': FieldValue.increment(-1)
      });

      // Execute all operations atomically
      await batch.commit();
    } catch (e) {
      print('Error removing member from club: $e');
      rethrow;
    }
  }
}