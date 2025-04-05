//page for displaying the mood details from a past mood entry
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/date_formatting.dart';

class MoodDetailsPage extends StatelessWidget {
  final Map<String, dynamic> moodEntry;
  const MoodDetailsPage({Key? key, required this.moodEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //parse the data from the mood entry
    DateTime? entryDate;
    try {
      entryDate = DateTime.parse(moodEntry['date']);
    } catch (e) {
      entryDate = null;
    }
    //format the date
    String formattedDate = 'Unknown Date';
    if (entryDate != null) {
      String dayOfWeek = DateFormat('EEE').format(entryDate);
      String formattedDay = DateFormatter.formatDate(entryDate);
      formattedDate = '$dayOfWeek, $formattedDay';
    }
    //extract the mood and notes
    final moods = moodEntry['moods'] as Map<String, dynamic>? ?? {};
    final notes = moodEntry['notes'] as Map<String, dynamic>? ?? {};
    //Create the list of mood details
    final moodDetails = moods.entries.map((entry) {
      final moodName = entry.key;
      final intensity = entry.value;
      final note = notes[moodName];
      return {
        'mood' : moodName,
        'intensity' : intensity,
        'note' : note,
      };
    }).toList();

    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text(formattedDate),
        backgroundColor: Colors.deepPurple[200],
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, color: Colors.deepPurple),
                    SizedBox(width: 8),
                    Text('Help'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(

          itemCount: moodDetails.length,
          itemBuilder: (context, index) {
            final detail = moodDetails[index];
            final moodName = detail['mood'] as String;
            final intensity = detail['intensity'];
            final note = detail['note'];
            return Card(
              color: Colors.deepPurple[100],
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text(
                  '$moodName - Intensity: $intensity',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: (note != null && note.toString().trim().isNotEmpty)
                    ? Text(note.toString())
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}