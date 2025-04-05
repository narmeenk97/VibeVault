import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mode_entry_model.dart';

class AnalysisService {
  final String endpointURL = 'https://6jjalnxit7.execute-api.us-east-2.amazonaws.com/prod/getLastMoodEntry';
  //fetch the mood data
  Future<List<MoodEntry>> fetchMoodData() async {
    final response = await http.get(Uri.parse(endpointURL));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<MoodEntry> entries = data.map((json) => MoodEntry.fromJson(json)).toList();
      return entries;
    } else {
      throw Exception('Error fetching mood data: ${response.statusCode}');
    }
  }
  //filter the data based on the selected time range
  List<MoodEntry> filterDateByTime(
      List<MoodEntry> entries, String timeRange) {
    DateTime now = DateTime.now();
    DateTime startDate;
    //when selection is 7 days
    if (timeRange == '7 days') {
      startDate = now.subtract(Duration(days: 7));
      //when selection is the past month
    } else if (timeRange == 'Month') {
      startDate = DateTime(now.year, now.month - 1, now.day);
      //when the selection is for the whole year
    } else {
      startDate = DateTime(now.year - 1, now.month, now.day);
    }
    return entries.where((entry) => entry.date.isAfter(startDate)).toList();
  }
  //group the entries by day and sum up the counts for the selected mood
  Map<String, double> groupDateByDay(List<MoodEntry> entries, String mood) {
    Map<String, double> groupedData = {};
    for (var entry in entries) {
      if (entry.moods.containsKey(mood)) {
        int count = entry.moods[mood]!;
        //Format the date as 'MM/dd'
        String label = "${entry.date.month}/${entry.date.day}";
        groupedData[label] = (groupedData[label] ?? 0) + count.toDouble();
      }
    }
    return groupedData;
  }
}