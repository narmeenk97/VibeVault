import '../widgets/analysis_chart.dart';
import 'package:flutter/material.dart';
import '../models/mode_entry_model.dart';
import '../utils/analysis_service.dart';

class AnalysisPage extends StatefulWidget {

  const AnalysisPage({super.key});
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final AnalysisService _analysisService = AnalysisService();
  List<MoodEntry> _entries = [];
  bool _isLoading = false;

  String _selectedTimeRange = '7 Days';
  String _selectedMood = 'Happy';

  final List<String> _timeRanges = ['7 Days', 'Month', 'Year'];
  final List<String> _moods = ['Happy', 'Sad', 'Anxious', 'Excited', 'Calm', 'Angry', 'Tired',
    'Irritable', 'Hangry'];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<MoodEntry> data = await _analysisService.fetchMoodData();
      setState(() {
        _entries = data;
      });
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //filter by time range using analysis service
    List<MoodEntry> filteredData = _analysisService.filterDateByTime(_entries, _selectedTimeRange);
    //group data by day for selected mood
    Map<String, double> groupedData = _analysisService.groupDateByDay(filteredData, _selectedMood);
    //chart labels and values
    List<String> labels = groupedData.keys.toList();
    List<double> values = groupedData.values.toList();
    //sort the labels by date ('MM/dd' format)
    labels.sort((a, b) {
      List<String> aParts = a.split('/');
      List<String> bParts = b.split('/');
      DateTime aDate = DateTime(DateTime.now().year, int.parse(aParts[0]), int.parse(aParts[1]));
      DateTime bData = DateTime(DateTime.now().year, int.parse(bParts[0]), int.parse(bParts[1]));
      return aDate.compareTo(bData);
    });

    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text('Mood Analysis', style: TextStyle(fontWeight: FontWeight.bold)),
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //time range drop down
            Row(
              children: [
                Text('Time Range: ', style: TextStyle(fontSize: 18, color: Colors.deepPurple[900])),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedTimeRange,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                      items: _timeRanges
                          .map((range) => DropdownMenuItem(
                        value: range,
                        child: Text(range, style: TextStyle(fontSize: 15, color: Colors.deepPurple[900])),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTimeRange = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Mood dropdown
            Row(
              children: [
                Text("Mood: ", style: TextStyle(fontSize: 18, color: Colors.deepPurple[900])),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedMood,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                      items: _moods
                          .map((mood) => DropdownMenuItem(
                        value: mood,
                        child: Text(mood, style: TextStyle(fontSize: 15, color: Colors.deepPurple[900])),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMood = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Chart display
            Expanded(
              child: groupedData.isEmpty
                  ? Center(
                child: Text(
                  'No data available for the selected options.',
                  style: TextStyle(fontSize: 15, color: Colors.deepPurple[900]),
                ),
              )
                  : AnalysisChart(
                labels: labels,
                values: values,
                title: '$_selectedMood pattern over the past $_selectedTimeRange',
              ),
            ),
          ],
        ),
      ),
    );
  }
}