import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  TextEditingController controller = TextEditingController();
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );
    _progressAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_progressController);
  }

  @override
  void dispose() {
    _progressController.dispose();
    controller.dispose();
    super.dispose();
  }

  void _startTimer() async {
    setState(() {
      _isRunning = true;
      _isPaused = false;
      if (_remainingSeconds == 0) {
        _remainingSeconds = int.tryParse(controller.text) ?? 0;
        _totalSeconds = _remainingSeconds;
        _progressController.duration = Duration(seconds: _totalSeconds);
        _progressController.reset();
        _progressController.forward();
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
      _progressController.stop();
    });
  }

  void _resumeTimer() {
    setState(() {
      _isPaused = false;
      _isRunning = true;
      _progressController.forward();
    });
    _startTimer();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingSeconds = 0;
      _totalSeconds = 0;
      controller.clear();
      _progressController.reset();
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
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 200, // Größere Höhe des Kreises
                  width: 200, // Größere Breite des Kreises
                  child: CircularProgressIndicator(
                    value: _progressAnimation.value,
                    strokeWidth: 15, // Dickere Kreislinie
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
                Text(
                  _formatTime(_remainingSeconds),
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 40), // Abstand zwischen Kreis und Buttons
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
                  onPressed: _resetTimer, // Button ist immer aktiv
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
