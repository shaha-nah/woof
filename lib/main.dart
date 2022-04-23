import 'dart:async';

import 'package:flutter/material.dart';
import 'package:woof/widget/button_widget.dart';

import 'package:wakelock/wakelock.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  
  runApp(Woof());
}

class Woof extends StatefulWidget {
  @override
  _WoofState createState() => _WoofState();
}

class _WoofState extends State<Woof> {
  static const maxSeconds = 30;
  int seconds = maxSeconds;

  Timer? timer;

  void resetTimer() => setState(() => seconds = maxSeconds);

  void startTimer(bool reset) {
    if (reset) {
      resetTimer();
    }

    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        stopTimer(false);
        FlutterRingtonePlayer.playNotification();
      }
    });
  }

  void stopTimer(bool reset) {
    if (reset) {
      resetTimer();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTimer(),
                const SizedBox(height: 80),
                buildButtons(),
              ],
            ),
          ),
        ),
      );

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == maxSeconds || seconds == 0;

    return isRunning || !isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: isRunning ? 'Pause' : 'Resume',
                onClicked: () {
                  if (isRunning) {
                    stopTimer(false);
                  } else {
                    startTimer(false);
                  }
                },
              ),
              const SizedBox(width: 12),
              ButtonWidget(
                text: 'Cancel',
                onClicked: () {
                  stopTimer(true);
                },
              ),
            ],
          )
        : ButtonWidget(
            text: 'Start',
            color: Colors.black,
            backgroundColor: Colors.white,
            onClicked: () {
              startTimer(true);
            },
          );
  }

  Widget buildTimer() => SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: seconds / maxSeconds,
              strokeWidth: 12,
              valueColor: AlwaysStoppedAnimation(Colors.black),
              backgroundColor: Colors.blueAccent,
            ),
            Center(child: buildTime())
          ],
        ),
      );

  Widget buildTime() {
    return Text(
      '$seconds',
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 80),
    );
  }
}
