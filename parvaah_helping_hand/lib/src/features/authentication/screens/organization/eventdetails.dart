import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({Key? key}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? tAccentColor : tDashboardBg,
      appBar: AppBar(
        backgroundColor: isDarkMode ? tPrimaryColor : tBgColor,
        title: const Text(
          'Events Uploaded',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: const EventGridView(),
    );
  }
}

class EventGridView extends StatelessWidget {
  const EventGridView({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Events').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final events = snapshot.data!.docs;
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return EventCard(
              imageURL: event['imageURL'],
              date: event['date'],
              docId: event.id,
            );
          },
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final String imageURL;
  final String date;
  final String docId;

  const EventCard({
    required this.imageURL,
    required this.date,
    required this.docId,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the date string to DateTime
    DateTime eventDate = DateFormat("dd/MM/yyyy").parse(date);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            imageURL,
            fit: BoxFit.cover,
            height: 200, // Adjust as needed
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  docId,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                TableCalendar(
                  calendarBuilders: CalendarBuilders(
                    // Highlight the event date
                    defaultBuilder: (context, date, _) {
                      if (isSameDay(date, eventDate)) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 100, 33, 243),
                          ),
                          child: Text(
                            '${date.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return null;
                      }
                    },
                  ),
                  focusedDay: eventDate,
                  selectedDayPredicate: (date) => isSameDay(date, eventDate),
                  firstDay: DateTime.utc(2022, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  availableGestures: AvailableGestures.none, // Make non-interactive
                ),
                const SizedBox(height: 8),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Events')
                      .doc(docId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (!snapshot.hasData) {
                      return const Text('No data available');
                    }
                    var eventData = snapshot.data!.data() as Map<String, dynamic>;
                    var venue = eventData['venue'];
                    var time = eventData['time'];
                    if (venue == null || time == null) {
                      return const Text('Venue or Time not available');
                    }
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      color: const Color.fromARGB(255, 197, 196, 197),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Venue: $venue',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Time: $time'),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
