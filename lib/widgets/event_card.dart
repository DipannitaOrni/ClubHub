// lib/widgets/event_card.dart
// REPLACE YOUR ENTIRE event_card.dart FILE WITH THIS

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_hub/models/event_model.dart';
import 'package:club_hub/services/event_registration_service.dart';

class EventCard extends StatefulWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({
    Key? key,
    required this.event,
    this.onTap,
  }) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final EventRegistrationService _registrationService =
      EventRegistrationService();
  bool _isLoading = false;

  // ClubHub Theme Colors
  static const Color navyBlue = Color(0xFF1A237E);
  static const Color orange = Color(0xFFFF6F00);
  static const Color lightBackground = Color(0xFFF5F5F5);

  Future<void> _handleRegistration(bool isRegistered) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackBar('Please log in to register for events', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    bool success;
    String message;

    if (isRegistered) {
      // Unregister
      success = await _registrationService.unregisterFromEvent(
        studentUid: user.uid,
        eventId: widget.event.eventId,
      );
      message = success
          ? 'Successfully unregistered from event'
          : 'Failed to unregister';
    } else {
      // Register
      success = await _registrationService.registerForEvent(
        studentUid: user.uid,
        eventId: widget.event.eventId,
        clubId: widget.event.clubId,
      );
      message = success
          ? 'Successfully registered for event!'
          : 'Failed to register. You may already be registered.';
    }

    setState(() => _isLoading = false);

    if (mounted) {
      _showSnackBar(message, success ? Colors.green : Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showConfirmationDialog(bool isRegistered) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              isRegistered ? Icons.cancel_outlined : Icons.check_circle_outline,
              color: isRegistered ? Colors.red : orange,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isRegistered ? 'Unregister?' : 'Register?',
                style: const TextStyle(fontSize: 18, color: navyBlue),
              ),
            ),
          ],
        ),
        content: Text(
          isRegistered
              ? 'Are you sure you want to unregister from "${widget.event.eventName}"?'
              : 'Do you want to register for "${widget.event.eventName}"?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: navyBlue)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleRegistration(isRegistered);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isRegistered ? Colors.red : orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(isRegistered ? 'Unregister' : 'Register'),
          ),
        ],
      ),
    );
  }

  Future<String?> _getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      return userDoc.data()?['role'] as String?;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  void _showRegisteredStudents() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: navyBlue,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.people, color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Registered Students',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.event.eventName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Student List
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _registrationService.getRegisteredStudentsStream(
                    widget.event.eventId,
                  ),
                  builder: (context, snapshot) {
                    // Debug prints
                    print(
                        '📊 Registration Stream - ConnectionState: ${snapshot.connectionState}');
                    print('📊 Event ID: ${widget.event.eventId}');
                    print('📊 Has Data: ${snapshot.hasData}');
                    print('📊 Data Length: ${snapshot.data?.length ?? 0}');
                    if (snapshot.hasError) {
                      print('❌ Stream Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading registrations',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No students registered yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final students = snapshot.data!;
                    print('✅ Showing ${students.length} registered students');

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        final registeredAt =
                            student['registeredAt'] as Timestamp?;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              backgroundColor: orange.withOpacity(0.1),
                              child: Text(
                                student['fullName']
                                        ?.toString()
                                        .substring(0, 1)
                                        .toUpperCase() ??
                                    'S',
                                style: const TextStyle(
                                  color: orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              student['fullName'] ?? 'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  student['email'] ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                if (student['department'] != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    '${student['department']} • ${student['levelTerm'] ?? ''}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                                if (registeredAt != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    'Registered: ${DateFormat('MMM dd, hh:mm a').format(registeredAt.toDate())}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: navyBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '#${index + 1}',
                                style: const TextStyle(
                                  color: navyBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Format date
    String formattedDate =
        DateFormat('MMM dd, yyyy').format(widget.event.eventDate);
    String formattedTime = DateFormat('hh:mm a').format(widget.event.eventDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: lightBackground, width: 1),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name and Status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.event.eventName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: navyBlue,
                      ),
                    ),
                  ),
                  if (widget.event.isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          color: orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else if (widget.event.isUpcoming)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Upcoming',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Event Description
              if (widget.event.eventDescription.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.event.eventDescription,
                    style: TextStyle(
                      fontSize: 14,
                      color: navyBlue.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              Divider(color: lightBackground, thickness: 1),

              // Event Details Row
              Row(
                children: [
                  // Date Icon
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: orange,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 13,
                      color: navyBlue.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Time Icon
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: orange,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 13,
                      color: navyBlue.withOpacity(0.8),
                    ),
                  ),
                ],
              ),

              // Location
              if (widget.event.eventLocation.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: orange,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.event.eventLocation,
                          style: TextStyle(
                            fontSize: 13,
                            color: navyBlue.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

              // Registration count
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.people,
                      size: 16,
                      color: navyBlue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.event.totalRegistrations} registered',
                      style: TextStyle(
                        fontSize: 13,
                        color: navyBlue.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Registration Button for STUDENTS / Analytics for MANAGERS
              if (widget.event.isUpcoming && user != null) ...[
                const SizedBox(height: 12),
                FutureBuilder<String?>(
                  future: _getUserRole(),
                  builder: (context, roleSnapshot) {
                    final userRole = roleSnapshot.data;

                    // Show analytics button for managers
                    if (userRole == 'club_manager') {
                      return StreamBuilder<int>(
                        stream: _registrationService.getRegistrationCountStream(
                          widget.event.eventId,
                        ),
                        builder: (context, countSnapshot) {
                          final count = countSnapshot.data ?? 0;

                          return SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: OutlinedButton.icon(
                              onPressed: () => _showRegisteredStudents(),
                              icon: const Icon(Icons.people_outline, size: 18),
                              label: Text(
                                'View Registrations ($count)',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: navyBlue,
                                side:
                                    const BorderSide(color: navyBlue, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    // Show registration button for students
                    if (userRole == 'student') {
                      return StreamBuilder<bool>(
                        stream: _registrationService.isStudentRegisteredStream(
                          user.uid,
                          widget.event.eventId,
                        ),
                        builder: (context, snapshot) {
                          final isRegistered = snapshot.data ?? false;

                          return SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading
                                  ? null
                                  : () => _showConfirmationDialog(isRegistered),
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Icon(
                                      isRegistered
                                          ? Icons.cancel_outlined
                                          : Icons.check_circle_outline,
                                      size: 18,
                                    ),
                              label: Text(
                                isRegistered ? 'Unregister' : 'Register Now',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isRegistered ? Colors.red.shade400 : orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
