import 'package:flutter/material.dart';

import 'package:timer_app/screens/app_home.dart';
import 'package:timer_app/screens/second_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StopwatchHome(),
      routes: {
        "/secondScreen": (context) => const TimerPage(),
      },
    );
  }
}
