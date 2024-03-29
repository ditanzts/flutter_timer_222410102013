import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      home: TimerPage(),
    );
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  TextEditingController _minuteController = TextEditingController();
  int _initialTime = 0;
  int _remainingTime = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Set initial time here
    _remainingTime = _initialTime;
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), () {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer!.cancel();
      }
    } as void Function(Timer timer));
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void _resetTimer() {
    setState(() {
      _initialTime = (int.tryParse(_minuteController.text) ?? 0) * 60;
      _remainingTime = _initialTime;
    });

    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    } else {
      _startTimer();
    }
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _minuteController.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _minuteController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Masukan Menit',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  _remainingTime > 0 ? _formatTime(_remainingTime) : '00:00', // Set default value when timer is not started
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _stopTimer,
              child: Text('BERHENTI'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_remainingTime > 0) {
                  _startTimer();
                } else {
                  _resetTimer();
                }
              },
              child: Text('MULAI'),
            ),
            ElevatedButton(
              onPressed: () {
                _resetTimer();
              },
              child: Text('MULAI ULANG'),
            ),
          ],
        ),
      ),
    );
  }
}