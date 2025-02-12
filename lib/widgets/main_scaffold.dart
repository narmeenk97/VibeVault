import 'package:flutter/material.dart';
import '../pages/dashboard.dart';
import '../pages/mood_entry.dart';
import '../pages/analysis.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}
class _MainScaffoldState extends State<MainScaffold> {
  //set the index to zero so the app opens on the dashboard page everytime
  int _selectedIndex = 0;
  //List of pages for navigation
  static final List<Widget> _pages = <Widget>[
  const DashboardPage(),
  //add the rest of the pages here
  ];
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