import 'package:flutter/material.dart';
import '../pages/mood_entry.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../pages/analysis.dart';
import '../utils/date_formatting.dart';
import '../pages/mood_details.dart';

//Main dashboard where the app opens and the first page the user sees

class DashboardPage extends StatefulWidget {

  final VoidCallback onLogMoodTap;
  const DashboardPage({super.key, required this.onLogMoodTap});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  List<Map<String, dynamic>> pastEntries = [];

  @override
  void initState() {
    super.initState();
    fetchPastMoodEntries();
  }

  Future<void> fetchPastMoodEntries() async {
    final url = Uri.parse('https://6jjalnxit7.execute-api.us-east-2.amazonaws.com/prod/getLastMoodEntry');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          pastEntries = data.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      print('Error fetching mood entries: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    final String todayDate = DateFormat('EEE, MMMM d, y').format(DateTime.now());
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text("VibeVault", style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.deepPurple[200],
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Display todays date
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.deepPurple, width: 1.5),
              ),
              child: Text(
                  'Welcome to a greater sense of self-awareness',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
              textAlign: TextAlign.center,
              ),

            ),
            const SizedBox(height: 20),
            //Log Mood button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.deepPurple, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Log Todays Mood', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                //Display todays date
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
              color: Colors.deepPurple[100],
              borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                todayDate,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
                  ElevatedButton(
                      onPressed: widget.onLogMoodTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent[50],
                        foregroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.deepPurple, width: 1.5),
                        ),
                      ),
                      child: const Text('Log Mood Now'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            //Past mood entries
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Past Mood Entries: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AnalysisPage()),
                      );
                    },
                    child: const Text(
                      "View Analysis",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                  )
                ],
            ),
            const SizedBox(height: 10),
            //List view of past mood entries
            if (pastEntries.isEmpty)
              const Text('No entries found.'),
            ...pastEntries.map((entry) {
            DateTime? entryDate;
            try {
              entryDate = DateTime.parse(entry['date']);
            } catch (e) {
              entryDate = null;
            }
            final formattedDate = entryDate != null
                ? DateFormatter.formatDate(entryDate)
                : 'Unknown Date';
            final day = entry['day'] ?? '';
            return Card(
            elevation: 2,
            color: Colors.deepPurple[100],
            margin: const EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(
              "$formattedDate - $day",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text("Click for past vibes!", style: TextStyle(color: Colors.deepPurple),),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
                //navigate to the read only detail page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoodDetailsPage(moodEntry: entry),
                  )
              );
            }
            )
            );
            }
          )
          ]
        ),
        )
    );
  }
}