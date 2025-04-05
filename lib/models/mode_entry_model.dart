class MoodEntry {
  final DateTime date;
  final Map<String, int> moods;
  final String id;
  final Map<String, String> notes;
  final String day;

  MoodEntry({
    required this.date,
    required this.moods,
    required this.id,
    required this.notes,
    required this.day,
});

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
        date: DateTime.parse(json['date']),
        moods: Map<String, int>.from(json['moods']),
        id: json['ID'],
        notes: Map<String, String>.from(json['notes']),
        day: json['day'],
    );
  }
}