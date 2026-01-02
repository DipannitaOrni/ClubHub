import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:club_hub/widgets/event_card.dart';
import 'package:intl/intl.dart';
import '../../providers/data_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/event_model.dart';
import '../../utils/theme.dart';
import '../../widgets/event_card.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final student = dataProvider.currentStudent;

    if (student == null) {
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
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
                              'Welcome Back',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              student.fullName.split(' ').first,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content with rounded top corners
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await dataProvider.loadStudent(student.uid);
                      },
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Stats cards in a SINGLE ROW
                            StreamBuilder<List<EventModel>>(
                              stream: FirestoreService().getEventsByClubs(student.joinedClubs),
                              builder: (context, snapshot) {
                                int upcomingCount = 0;
                                int pastCount = 0;
                                if (snapshot.hasData) {
                                  upcomingCount = snapshot.data!.where((e) => e.isUpcoming).length;
                                  pastCount = snapshot.data!.where((e) => e.isPast).length;
                                }

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildStatCard(
                                        context,
                                        'Clubs\nJoined',
                                        student.joinedClubs.length.toString(),
                                        Icons.groups_rounded,
                                        AppTheme.primaryOrange,
                                      ),
                                      const SizedBox(width: 12),
                                      _buildStatCard(
                                        context,
                                        'Upcoming\nEvents',
                                        upcomingCount.toString(),
                                        Icons.event_rounded,
                                        AppTheme.primaryBlue,
                                      ),
                                      const SizedBox(width: 12),
                                      _buildStatCard(
                                        context,
                                        'Past Events\nAttended',
                                        pastCount.toString(),
                                        Icons.history_rounded,
                                        AppTheme.textSecondary,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 32),

                            // Upcoming events section
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryOrange,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Upcoming Events',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            StreamBuilder<List<EventModel>>(
                              stream: FirestoreService().getEventsByClubs(student.joinedClubs),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(32),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(32),
                                      decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.event_busy_rounded,
                                            size: 64,
                                            color: AppTheme.textSecondary.withOpacity(0.5),
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'No upcoming events',
                                            style: TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                final upcomingEvents = snapshot.data!
                                    .where((event) => event.isUpcoming)
                                    .toList()
                                  ..sort((a, b) => a.eventDate.compareTo(b.eventDate));

                                if (upcomingEvents.isEmpty) {
                                  return Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(32),
                                      decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.event_busy_rounded,
                                            size: 64,
                                            color: AppTheme.textSecondary.withOpacity(0.5),
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'No upcoming events',
                                            style: TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: upcomingEvents.length > 5 ? 5 : upcomingEvents.length,
                                  itemBuilder: (context, index) {
                                    return EventCard(event: upcomingEvents[index]);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}