import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  TextEditingController controller = TextEditingController();

  void _startTimer() async {
    setState(() {
      _isRunning = true;
      _isPaused = false;
      if (_remainingSeconds == 0) {
        _remainingSeconds = int.tryParse(controller.text) ?? 0;
      }
    });

    while (_remainingSeconds > 0 && _isRunning && !_isPaused) {
      await Future.delayed(const Duration(seconds: 1));
      if (_isRunning && !_isPaused) {
        setState(() {
          _remainingSeconds--;
        });
      }
    }

    if (_remainingSeconds == 0 && _isRunning) {
      _showNotification();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
      _isRunning = false;
    });
  }

  void _resumeTimer() {
    setState(() {
      _isPaused = false;
      _isRunning = true;
    });
    _startTimer();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingSeconds = 0;
      controller.clear();
    });
  }

  void _showNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Der Timer ist abgelaufen!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Timer-Dauer in Sekunden',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Verbleibende Zeit: ${_formatTime(_remainingSeconds)}',
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _isRunning
                      ? (_isPaused ? _resumeTimer : _pauseTimer)
                      : _startTimer,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 100), // Feste Größe
                    shape: const CircleBorder(), // Runde Form
                    padding: const EdgeInsets.all(20), // Innenabstand
                  ),
                  child: Text(_isRunning
                      ? (_isPaused ? 'Weiter' : 'Pause')
                      : 'Starten'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed:
                      _remainingSeconds > 0 || _isPaused ? _resetTimer : null,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 100), // Feste Größe
                    shape: const CircleBorder(), // Runde Form
                    padding: const EdgeInsets.all(20), // Innenabstand
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
