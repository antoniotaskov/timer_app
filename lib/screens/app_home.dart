import 'package:flutter/material.dart';
import 'package:timer_app/screens/First_screen.dart';
import 'package:timer_app/screens/second_screen.dart';

class StopwatchHome extends StatefulWidget {
  const StopwatchHome({super.key});

  @override
  State<StopwatchHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<StopwatchHome> {
  int currentPageIndex = 0;

  final List<Widget> screens = [
    const NewsScreen(),
    const TimerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Timer App",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 92, 130, 94),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 189, 144, 159),
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.punch_clock_sharp), label: 'Stoppuhr'),
          NavigationDestination(icon: Icon(Icons.timer), label: 'Timer'),
        ],
      ),
      body: Center(
        child: screens[currentPageIndex],
      ),
    );
  }
}
