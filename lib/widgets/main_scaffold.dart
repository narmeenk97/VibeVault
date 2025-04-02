import 'package:flutter/material.dart';
import '../pages/dashboard.dart';
import '../pages/mood_entry.dart';
import '../pages/analysis.dart';

//Bottom navigation bar logic

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}
class _MainScaffoldState extends State<MainScaffold> {
  //set the index to zero so the app opens on the dashboard page everytime
  int _selectedIndex = 0;
  //List of pages for navigation
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardPage(onLogMoodTap: () {
        setState(() {
          _selectedIndex = 1;
        });
      }),
      const MoodEntryPage(),
      //const AnalysisPage(), // Add this once ready
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Log Mood'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analysis'),
          ],
          currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurpleAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}