import 'package:flutter/material.dart';
import 'package:flutter_projects/widgets/main_scaffold.dart';
//import dashboard file as main will redirect to dashboard
import 'pages/dashboard.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VibeVault',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MainScaffold(),
    );
  }
}
