import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mboathoscope/views/widgets/resultChild.dart';
import 'package:path/path.dart' as p;
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
class ResultPage extends StatelessWidget {
  final List<dynamic>? predictionResult;
  final String audioPath;

  ResultPage({Key? key, required this.predictionResult, required this.audioPath}) : super(key: key);

  String categorizeResult(double normalScore, List<dynamic> otherScores) {
    for (var score in otherScores) {
      if (score > normalScore) {
        return 'Abnormal';
      }
    }
    return 'Normal';
  }

  @override
  Widget build(BuildContext context) {
    if (predictionResult == null || predictionResult!.isEmpty || predictionResult![0].isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('No prediction result available.'),
        ),
      );
    }

    List<dynamic> scores = predictionResult![0];
    double normalScore = scores.last.toDouble();
    List<dynamic> otherScores = scores.sublist(0, scores.length - 1);
    String result = categorizeResult(normalScore, otherScores);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              '/homepage', (Route<dynamic> route) => false),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _shareResultAndAudio(result, audioPath);
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Result',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 0,
                left: 70,
                top: 0,
                bottom: 0,
              ),
              child: Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width * .7,
                    child: Lottie.asset('assets/animations/doc.json'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: AddCard(
                    name: 'Normal',
                    isNormal: true,
                    highlighted: result == 'Normal',
                  ),
                ),
                Expanded(
                  child: AddCard(
                    name: 'Abnormal',
                    isNormal: false,
                    highlighted: result == 'Abnormal',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  result == 'Normal' ? 'Your heart sounds are within the normal range.' : 'Your heart sounds may indicate a potential issue. Please consult a healthcare professional.',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: result == 'Normal' ? Colors.blueAccent : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // // Method to share result and audio
  void _shareResultAndAudio(String result, String audioPath) async {
    try {
      // Share both result and audio
      await Share.shareFiles([audioPath], text: 'Heart Sound Result: $result\nAudio Path: $audioPath');
    } catch (e) {
      print('Error sharing: $e');
    }
  }







  // Method to share result and audio
  // void _shareResultAndAudio(String result, String audioPath) async {
  //   try {
  //     // Check if the audio file is already in WAV format
  //     if (!audioPath.toLowerCase().endsWith('.wav')) {
  //       // If not, create a new path for the WAV file
  //       //final wavFilePath = p.join(p.dirname(audioPath), '${p.basenameWithoutExtension(audioPath)}.wav');
  //       //print('wavefilepath $wavFilePath');
  //       print('audio path $audioPath');
  //
  //       // Convert audio to WAV format
  //       //await _convertToWav(audioPath, wavFilePath);
  //
  //       String outputDir = p.dirname(audioPath);
  //       //await _convertToWav(audioPath, outputDir);
  //       // Call the _convertToWav function
  //       _convertToWav(audioPath, outputDir)
  //           .then((wavFilePath) {
  //         // The conversion was successful, and wavFilePath contains the path to the converted WAV file
  //         print('WAV file converted successfully at: $wavFilePath');
  //
  //         // Now you can share the converted WAV file using Share plugin or perform any other actions
  //         // Share the WAV file along with the result
  //         Share.shareFiles([wavFilePath], text: 'Heart Sound Result: $result\nAudio Path: $wavFilePath');
  //       })
  //           .catchError((error) {
  //         // An error occurred during the conversion process
  //         print('Error converting to WAV: $error');
  //         // Handle the error accordingly
  //       });
  //
  //
  //       // Share the WAV file along with the result
  //       //await Share.shareFiles([wavFilePath], text: 'Heart Sound Result: $result\nAudio Path: $wavFilePath');
  //     } else {
  //       // If the audio file is already in WAV format, share it directly
  //       await Share.shareFiles([audioPath], text: 'Heart Sound Result: $result\nAudio Path: $audioPath');
  //     }
  //   } catch (e) {
  //     print('Error sharing: $e');
  //   }
  // }

// Method to convert audio to WAV format
  Future<String> _convertToWav(String originalFilePath, String outputDir) async {
    try {
      // Define the output file path with a unique name (e.g., using timestamp)
      final outputFileName = 'heartbeatsound_${DateTime.now().millisecondsSinceEpoch}.wav';
      final wavFilePath = p.join(outputDir, outputFileName);
      // Execute FFmpeg command to convert audio to WAV format
      final ffmpegCommand = '-i $originalFilePath $wavFilePath';
      //final ffmpegCommand = '-i $originalFilePath -c:a libmp3lame -q:a 2 $wavFilePath';
      final session = await FFmpegKit.executeAsync(ffmpegCommand);

      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        print('Audio conversion to WAV successful');
        return wavFilePath; // Return the path to the converted WAV file
      } else {
        final logs = await session.getAllLogsAsString();
        final logString = logs != null && logs is String ? logs : 'No logs available';
        print('Audio conversion to WAV failed: $logs');
        print('Audio conversion to WAV failed: $logString');
        throw Exception('Audio conversion to WAV failed');
      }
    } catch (e) {
      print('Error converting to WAV: $e');
      rethrow; // Rethrow the error to handle it elsewhere if needed
    }
  }



}
