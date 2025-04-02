import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class MoodEntryPage extends StatefulWidget {
  const MoodEntryPage({super.key});

  @override
  State<MoodEntryPage> createState() => _MoodEntryPageState();
}

class _MoodEntryPageState extends State<MoodEntryPage> {
  final List<String> moods = ['Happy', 'Sad', 'Anxious', 'Excited', 'Calm', 'Angry', 'Tired',
  'Irritable', 'Hangry'];
  //Store the mood intensity
  final Map<String, int> selectedMoods = {};
  //Store the note for the mood
  final Map<String, String> moodNotes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(title: Text("Log Your Mood", style: TextStyle(fontWeight: FontWeight.bold)),
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
      body: Column(
        children: [
          Expanded(child: _buildMoodListView()),
          _buildLogVibesButton(),
        ],
      ));

  }
  //listview of the moods which you can select from
  Widget _buildMoodListView() {
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: moods.length,
        itemBuilder: (context, index) {
          String mood = moods[index];
          bool isSelected = selectedMoods.containsKey(mood);

          return GestureDetector(
            onTap: () {
              _showMoodIntensityDialog(mood);
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.deepPurple[300] : Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.deepPurple, width: 2),
              ),
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(mood, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (isSelected)
                    Icon(Icons.check, color: Colors.deepPurple)
                ],
              )
            ),
          );
        }
    );
  }
  //add the dialog box for the intensity and notes
  void _showMoodIntensityDialog(String mood) {
    int intensity = selectedMoods[mood] ?? 3;
    TextEditingController notesController = TextEditingController(text: moodNotes[mood] ?? "");

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Rate your $mood level", style: TextStyle(color: Colors.deepPurple)),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Select intensity (1-5):", style: TextStyle(color: Colors.purple)),
                    Slider(
                      value: intensity.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: intensity.toString(),
                      onChanged: (value) {
                        setDialogState(() => intensity = value.toInt());
                      },
                    ),
                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(labelText: "Add a note (optional)",
                          labelStyle: TextStyle(color: Colors.purple)),
                    ),
                  ],
                ),
              );
            },
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: Colors.purple)),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    selectedMoods[mood] = intensity;
                    moodNotes[mood] = notesController.text.trim();
                  });
                  Navigator.pop(context);
                },
                child: Text('Save', style: TextStyle(color: Colors.purple)),
            )
          ],
        ),
    );
  }
  //Create the button to log the vibes
  Widget _buildLogVibesButton() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
          onPressed: _submitMoodData,
          child: Text('Log Vibes', style: TextStyle(fontSize: 18, color: Colors.deepPurple)),
      ),
    );
  }
  //send the mood data to aws
  void _submitMoodData() async {
    if (selectedMoods.isEmpty) return;

    final DateTime now = DateTime.now();
    final moodData = {
      //generate random id for every mood entry
      "ID" : Uuid().v4(),
      "date" : DateTime.now().toIso8601String(),
      "day" : getDayOfWeek(now),
      "moods" : selectedMoods,
      "notes" : moodNotes
    };
    print("Selected Moods: $selectedMoods");
    print('Mood data being sent: $moodData');
    //send data to AWS
    final response = await sendToAWS(moodData);
    if (response) {
      setState(() {
        selectedMoods.clear();
        moodNotes.clear();
      });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mood Logged Successfully!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to log mood. Try again!"))
        );
      }

    }
  }
  String getDayOfWeek(DateTime date) {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[date.weekday % 7];
  }
  Future<bool> sendToAWS(Map<String, dynamic> data) async {
    final String apiURL = "https://6jjalnxit7.execute-api.us-east-2.amazonaws.com/prod/mood";
    try {
      final response = await http.post(
        Uri.parse(apiURL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        print("Mood entry saved successfully!");
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

