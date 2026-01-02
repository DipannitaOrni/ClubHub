import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/data_provider.dart';
import 'screens/welcome_screen_enhanced.dart'; // âœ… ADDED - Welcome screen
import 'screens/auth/login_screen.dart';
import 'screens/student/student_dashboard.dart';
import 'screens/club_manager/manager_dashboard.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        title: 'ClubHub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

// Wrapper to handle authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Show loading while checking auth state
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Not authenticated -> Welcome Screen âœ… CHANGED
        if (authProvider.currentUser == null) {
          return const WelcomeScreenEnhanced(); // âœ… CHANGED from LoginScreen
        }

        // Authenticated -> Route based on role
        if (authProvider.userRole == 'student') {
          return const StudentDashboard();
        } else if (authProvider.userRole == 'club_manager') {
          return const ManagerDashboard();
        }

        // Default fallback
        return const LoginScreen();
      },
    );
  }
}