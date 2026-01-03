// lib/services/event_registration_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class EventRegistrationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Check if student is registered for an event
  Future<bool> isStudentRegistered(String studentUid, String eventId) async {
    try {
      final querySnapshot = await _firestore
          .collection('event_registrations')
          .where('studentUid', isEqualTo: studentUid)
          .where('eventId', isEqualTo: eventId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking registration: $e');
      return false;
    }
  }

  /// Get list of event IDs student is registered for
  Future<List<String>> getStudentRegisteredEvents(String studentUid) async {
    try {
      final querySnapshot = await _firestore
          .collection('event_registrations')
          .where('studentUid', isEqualTo: studentUid)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data()['eventId'] as String)
          .toList();
    } catch (e) {
      print('Error getting registered events: $e');
      return [];
    }
  }

  /// Register student for event
  Future<bool> registerForEvent({
    required String studentUid,
    required String eventId,
    required String clubId,
  }) async {
    try {
      // Check if already registered
      final isRegistered = await isStudentRegistered(studentUid, eventId);
      if (isRegistered) {
        return false; // Already registered
      }

      final registrationId =
          'reg_${studentUid}_${eventId}_${DateTime.now().millisecondsSinceEpoch}';

      // Use batch write for atomic operation
      final batch = _firestore.batch();

      // 1. Create registration document
      final registrationRef =
          _firestore.collection('event_registrations').doc(registrationId);

      batch.set(registrationRef, {
        'registrationId': registrationId,
        'studentUid': studentUid,
        'eventId': eventId,
        'clubId': clubId,
        'registeredAt': FieldValue.serverTimestamp(),
        'attended': false,
      });

      // 2. Update student's registeredEvents array
      final studentRef = _firestore.collection('students').doc(studentUid);
      batch.update(studentRef, {
        'registeredEvents': FieldValue.arrayUnion([eventId]),
      });

      // 3. Increment event's totalRegistrations
      final eventRef = _firestore.collection('events').doc(eventId);
      batch.update(eventRef, {
        'totalRegistrations': FieldValue.increment(1),
      });

      await batch.commit();
      print('✅ Successfully registered for event: $eventId');
      return true;
    } catch (e) {
      print('❌ Error registering for event: $e');
      return false;
    }
  }

  /// Unregister student from event
  Future<bool> unregisterFromEvent({
    required String studentUid,
    required String eventId,
  }) async {
    try {
      // Find the registration
      final querySnapshot = await _firestore
          .collection('event_registrations')
          .where('studentUid', isEqualTo: studentUid)
          .where('eventId', isEqualTo: eventId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return false; // Not registered
      }

      final registrationId = querySnapshot.docs.first.id;

      // Use batch write for atomic operation
      final batch = _firestore.batch();

      // 1. Delete registration document
      final registrationRef =
          _firestore.collection('event_registrations').doc(registrationId);
      batch.delete(registrationRef);

      // 2. Update student's registeredEvents array
      final studentRef = _firestore.collection('students').doc(studentUid);
      batch.update(studentRef, {
        'registeredEvents': FieldValue.arrayRemove([eventId]),
      });

      // 3. Decrement event's totalRegistrations
      final eventRef = _firestore.collection('events').doc(eventId);
      batch.update(eventRef, {
        'totalRegistrations': FieldValue.increment(-1),
      });

      await batch.commit();
      print('✅ Successfully unregistered from event: $eventId');
      return true;
    } catch (e) {
      print('❌ Error unregistering from event: $e');
      return false;
    }
  }

  /// Stream to check registration status in real-time
  Stream<bool> isStudentRegisteredStream(String studentUid, String eventId) {
    return _firestore
        .collection('event_registrations')
        .where('studentUid', isEqualTo: studentUid)
        .where('eventId', isEqualTo: eventId)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  /// Get registration count for an event
  Future<int> getEventRegistrationCount(String eventId) async {
    try {
      final querySnapshot = await _firestore
          .collection('event_registrations')
          .where('eventId', isEqualTo: eventId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('Error getting registration count: $e');
      return 0;
    }
  }

  /// Get all registrations for a student
  Stream<List<Map<String, dynamic>>> getStudentRegistrations(
      String studentUid) {
    return _firestore
        .collection('event_registrations')
        .where('studentUid', isEqualTo: studentUid)
        .orderBy('registeredAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Get registration count stream for an event (for managers)
  Stream<int> getRegistrationCountStream(String eventId) {
    return _firestore
        .collection('event_registrations')
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Get list of registered students with their details (for managers)
  Stream<List<Map<String, dynamic>>> getRegisteredStudentsStream(
      String eventId) {
    print('🔍 Getting registered students for event: $eventId');

    return _firestore
        .collection('event_registrations')
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .asyncMap((snapshot) async {
      print('📦 Found ${snapshot.docs.length} registration documents');
      List<Map<String, dynamic>> students = [];

      for (var doc in snapshot.docs) {
        final registrationData = doc.data();
        final studentUid = registrationData['studentUid'] as String?;
        print('👤 Processing registration for student: $studentUid');

        if (studentUid != null) {
          try {
            // Fetch student details
            final studentDoc =
                await _firestore.collection('students').doc(studentUid).get();

            if (studentDoc.exists) {
              final studentData = studentDoc.data() ?? {};
              print('✅ Found student data: ${studentData['fullName']}');
              students.add({
                'uid': studentUid,
                'fullName': studentData['fullName'],
                'email': studentData['email'],
                'department': studentData['department'],
                'levelTerm': studentData['levelTerm'],
                'contactNumber': studentData['contactNumber'],
                'registeredAt': registrationData['registeredAt'],
                'attended': registrationData['attended'] ?? false,
              });
            } else {
              print('⚠️ Student document not found for uid: $studentUid');
            }
          } catch (e) {
            print('❌ Error fetching student details for $studentUid: $e');
          }
        }
      }

      // Sort by registration time (earliest first)
      students.sort((a, b) {
        final aTime = a['registeredAt'] as Timestamp?;
        final bTime = b['registeredAt'] as Timestamp?;
        if (aTime == null || bTime == null) return 0;
        return aTime.compareTo(bTime);
      });

      print('📊 Returning ${students.length} students');
      return students;
    });
  }
}
