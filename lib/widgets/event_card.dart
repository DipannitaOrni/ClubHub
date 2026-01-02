import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:club_hub/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({
    Key? key,
    required this.event,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format date
    String formattedDate = DateFormat('MMM dd, yyyy').format(event.eventDate);
    String formattedTime = DateFormat('hh:mm a').format(event.eventDate);

    // ClubHub Theme Colors
    const Color navyBlue = Color(0xFF1A237E);
    const Color orange = Color(0xFFFF6F00);
    const Color lightBackground = Color(0xFFF5F5F5);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: lightBackground, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.eventName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: navyBlue,
                      ),
                    ),
                  ),
                  if (event.isCompleted)
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
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Event Description
              if (event.eventDescription.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    event.eventDescription,
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
              if (event.eventLocation.isNotEmpty)
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
                          event.eventLocation,
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
            ],
          ),
        ),
      ),
    );
  }
}