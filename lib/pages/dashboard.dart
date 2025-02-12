import 'package:flutter/material.dart';
import '../pages/mood_entry.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Log today's mood section
            Container(
              padding: const EdgeInsets.all(80.0),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // ✅ Align text to left
                mainAxisAlignment: MainAxisAlignment.center, // ✅ Center vertically
                children: [
                  // App Name (VibeVault)
                  const Text(
                    "VibeVault",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // "Log Today's Mood" Text (Aligned Left)
                  const Text(
                    "Log Today's Mood",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // "Log Mood" Button Inside Container
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, //
                      foregroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to Mood Entry Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MoodEntryPage()),
                      );
                    },
                    child: const Text(
                      "Log Mood Now",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            //Past mood entries section
            const Text(
              'Past Mood Entries: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            //ListView for past entries
            Expanded(
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: const Text('No entries found',
                          style: TextStyle(fontSize: 16),
                      ),
                    ),
                    );
                  },
              ),
            )
          ],
        ),
      ),
    );
  }
}