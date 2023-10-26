import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'audio_player.dart';
import 'audio_recorder.dart';

class MyRecorderApp extends StatefulWidget {
  const MyRecorderApp({Key? key}) : super(key: key);

  @override
  State<MyRecorderApp> createState() => _MyRecorderAppState();
}

class _MyRecorderAppState extends State<MyRecorderApp> {
  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 10.0,
      widthFactor: 10.0,
      child: showPlayer
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: AudioPlayer(
                source: audioPath!,
                onDelete: () {
                  setState(() => showPlayer = false);
                },
              ),
            )
          : Recorder(
              onStop: (path) {
                if (kDebugMode) print('Recorded file path: $path');
                setState(() {
                  audioPath = path;
                  showPlayer = true;
                });
              },
            ),
    );
  }
}
