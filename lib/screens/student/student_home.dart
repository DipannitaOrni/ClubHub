// lib/screens/student/student_home.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/data_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/event_registration_service.dart';
import '../../services/recommendation_service.dart';
import '../../models/event_model.dart';
import '../../utils/theme.dart';
import '../../widgets/event_card.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final EventRegistrationService _registrationService =
      EventRegistrationService();

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final student = dataProvider.currentStudent;
    final user = FirebaseAuth.instance.currentUser;

    if (student == null || user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryBlue,
                  AppTheme.primaryBlue.withOpacity(0.8),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom Header
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.dashboard_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dashboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Welcome, ${student.fullName.split(' ').first}!',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content with rounded container
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // Stats Cards
                        _buildStatsCards(student),
                        const SizedBox(height: 24),

                        // Upcoming Events Section
                        _buildUpcomingEventsSection(user.uid),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(student) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.groups_rounded,
            title: 'Clubs',
            value: '${student.joinedClubs.length}',
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.event_rounded,
            title: 'Events',
            value: '${student.registeredEvents.length}',
            color: AppTheme.primaryOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.15),
                  color.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsSection(String studentUid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to Events tab
                // You can use a callback or state management to switch tabs
              },
              child: const Text(
                'See All',
                style: TextStyle(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Stream of registered event IDs
        FutureBuilder<List<String>>(
          future: _registrationService.getStudentRegisteredEvents(studentUid),
          builder: (context, registrationsSnapshot) {
            if (registrationsSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!registrationsSnapshot.hasData ||
                registrationsSnapshot.data!.isEmpty) {
              // No registrations - show RECOMMENDATIONS
              return _buildRecommendedEvents(studentUid);
            }

            final registeredEventIds = registrationsSnapshot.data!;

            // Now get the actual events from Firestore
            return StreamBuilder<List<EventModel>>(
              stream: FirestoreService().getAllEvents(),
              builder: (context, eventsSnapshot) {
                if (eventsSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (!eventsSnapshot.hasData || eventsSnapshot.data!.isEmpty) {
                  return _buildRecommendedEvents(studentUid);
                }

                // Filter: only registered events that are upcoming
                final registeredUpcomingEvents = eventsSnapshot.data!
                    .where((event) =>
                        registeredEventIds.contains(event.eventId) &&
                        event.isUpcoming)
                    .toList()
                  ..sort((a, b) => a.eventDate.compareTo(b.eventDate));

                if (registeredUpcomingEvents.isEmpty) {
                  // No upcoming registered events - show RECOMMENDATIONS
                  return _buildRecommendedEvents(studentUid);
                }

                // Show only first 3 events on dashboard
                final eventsToShow = registeredUpcomingEvents.take(3).toList();

                return Column(
                  children: eventsToShow
                      .map((event) => EventCard(event: event))
                      .toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // NEW: Show recommended events when no registered events
  Widget _buildRecommendedEvents(String studentUid) {
    return FutureBuilder<List<String>>(
      future: RecommendationService.getRecommendations(studentUid, topN: 3),
      builder: (context, recommendationSnapshot) {
        if (recommendationSnapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading recommendations...',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          );
        }

        // If recommendations failed, show placeholder
        if (!recommendationSnapshot.hasData ||
            recommendationSnapshot.data!.isEmpty) {
          return _buildNoEventsPlaceholder();
        }

        final recommendedEventIds = recommendationSnapshot.data!;

        // Get actual events from Firestore
        return StreamBuilder<List<EventModel>>(
          stream: FirestoreService().getAllEvents(),
          builder: (context, eventsSnapshot) {
            if (eventsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!eventsSnapshot.hasData || eventsSnapshot.data!.isEmpty) {
              return _buildNoEventsPlaceholder();
            }

            // Filter to recommended events that are upcoming
            final recommendedEvents = eventsSnapshot.data!
                .where((event) =>
                    recommendedEventIds.contains(event.eventId) &&
                    event.isUpcoming)
                .toList();

            // Sort by recommendation order
            recommendedEvents.sort((a, b) {
              final indexA = recommendedEventIds.indexOf(a.eventId);
              final indexB = recommendedEventIds.indexOf(b.eventId);
              return indexA.compareTo(indexB);
            });

            if (recommendedEvents.isEmpty) {
              return _buildNoEventsPlaceholder();
            }

            // Take only first 3 for dashboard
            final eventsToShow = recommendedEvents.take(3).toList();

            return Column(
              children: [
                // Recommendation badge
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryOrange.withOpacity(0.15),
                        AppTheme.primaryOrange.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 18,
                        color: AppTheme.primaryOrange,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Recommended For You',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.primaryOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Event cards
                ...eventsToShow
                    .map((event) => EventCard(event: event))
                    .toList(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildNoEventsPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_available_rounded,
              size: 60,
              color: AppTheme.primaryOrange,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Upcoming Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Register for events to see them here',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
