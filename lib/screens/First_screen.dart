// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  StopwatchHomeState createState() => StopwatchHomeState();
}

class StopwatchHomeState extends State<NewsScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<String> _lapTimes = []; // Liste zum Speichern der Zeiten
  bool isSaving =
      false; // Flag, um den Status des Speichern-Buttons zu verfolgen

  Future<void> _startStopwatch() async => setState(() {
        _stopwatch.start();
        isSaving = true; // Ändere den Status, um "Speichern" anzuzeigen
        _timer = Timer.periodic(const Duration(milliseconds: 30), (t) async {
          await Future.delayed(const Duration(milliseconds: 1));
          setState(() {});
        });
      });

  Future<void> _stopStopwatch() async => setState(() {
        _stopwatch.stop();
        _timer?.cancel();
        isSaving = false; // Ändere den Status zurück, um "Reset" anzuzeigen
        _lapTimes.add(_formatTime()); // Gemessene Zeit zur Liste hinzufügen
      });

  Future<void> _resetStopwatch() async => setState(() {
        _stopwatch.reset();
        _lapTimes.clear(); // Liste zurücksetzen
        isSaving = false; // Zurücksetzen des Status
      });

  Future<void> _saveLapTime() async => setState(() {
        _lapTimes.add(_formatTime()); // Gemessene Zeit zur Liste hinzufügen
      });

  String _formatTime() =>
      "${_stopwatch.elapsed.inMinutes.remainder(60).toString().padLeft(2, '0')}:"
      "${_stopwatch.elapsed.inSeconds.remainder(60).toString().padLeft(2, '0')}:"
      "${(_stopwatch.elapsed.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Stoppuhr')),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_formatTime(), style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120, // Feste Breite
                    height: 50, // Feste Höhe
                    child: ElevatedButton(
                      onPressed: _stopwatch.isRunning
                          ? () async => await _stopStopwatch()
                          : () async => await _startStopwatch(),
                      child: Text(_stopwatch.isRunning ? 'Stopp' : 'Start'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 120, // Feste Breite
                    height: 50, // Feste Höhe
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_stopwatch.isRunning) {
                          await _saveLapTime(); // Zeit speichern ohne Stoppuhr zu stoppen
                        } else {
                          await _resetStopwatch(); // Wenn nicht läuft, zurücksetzen
                        }
                      },
                      child: Text(_stopwatch.isRunning ? 'Speichern' : 'Reset'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _lapTimes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Runde ${index + 1}"),
                      trailing: Text(_lapTimes[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
