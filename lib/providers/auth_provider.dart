import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentUser;
  String? _userRole;
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  String? get userRole => _userRole;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _init();
  }

  void _init() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) async {
      _currentUser = user;
      if (user != null) {
        _userRole = await _authService.getUserRole(user.uid);
      } else {
        _userRole = null;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

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
    return await _authService.signUpStudent(
      email: email,
      password: password,
      fullName: fullName,
      levelTerm: levelTerm,
      department: department,
      contactNumber: contactNumber,
      fieldsOfInterest: fieldsOfInterest,
    );
  }

  // Sign up club manager
  Future<String?> signUpClubManager({
    required String email,
    required String password,
    required String clubName,
    required String clubDescription,
    required String clubCategory,
  }) async {
    return await _authService.signUpClubManager(
      email: email,
      password: password,
      clubName: clubName,
      clubDescription: clubDescription,
      clubCategory: clubCategory,
    );
  }

  // Sign in
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    return await _authService.signIn(email: email, password: password);
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
  }
}