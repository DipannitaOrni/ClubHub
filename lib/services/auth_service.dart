import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/student_model.dart';
import '../models/club_model.dart';
import '../utils/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up student
  Future<String?> signUpStudent({
    required String email,
    required String password,
    required String fullName,
    required String levelTerm,
    required String department,
    required String contactNumber,
    required List<String> fieldsOfInterest,
  }) async {
    try {
      // Create auth user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Create user document
      UserModel user = UserModel(
        uid: uid,
        email: email,
        role: AppConstants.studentRole,
        createdAt: DateTime.now(),
      );

      await _firestore.collection(AppConstants.usersCollection).doc(uid).set(user.toMap());

      // Create student document
      StudentModel student = StudentModel(
        uid: uid,
        fullName: fullName,
        email: email,
        levelTerm: levelTerm,
        department: department,
        contactNumber: contactNumber,
        fieldsOfInterest: fieldsOfInterest,
        createdAt: DateTime.now(),
      );

      await _firestore.collection(AppConstants.studentsCollection).doc(uid).set(student.toMap());

      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  // Sign up club manager
  Future<String?> signUpClubManager({
    required String email,
    required String password,
    required String clubName,
    required String clubDescription,
    required String clubCategory,
  }) async {
    try {
      // Create auth user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Create user document
      UserModel user = UserModel(
        uid: uid,
        email: email,
        role: AppConstants.clubManagerRole,
        createdAt: DateTime.now(),
      );

      await _firestore.collection(AppConstants.usersCollection).doc(uid).set(user.toMap());

      // Create club document
      ClubModel club = ClubModel(
        clubId: uid,
        clubName: clubName,
        clubDescription: clubDescription,
        clubCategory: clubCategory,
        clubEmail: email,
        createdAt: DateTime.now(),
      );

      await _firestore.collection(AppConstants.clubsCollection).doc(uid).set(club.toMap());

      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  // Sign in
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user role
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(AppConstants.usersCollection).doc(uid).get();
      if (doc.exists) {
        return (doc.data() as Map<String, dynamic>)['role'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}