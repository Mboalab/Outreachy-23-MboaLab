import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mboathoscope/views/widgets/resultChild.dart';

class ResultPage extends StatelessWidget {
  final List<dynamic>? predictionResult;
  ResultPage({Key? key, required this.predictionResult}) : super(key: key);

  // Method to determine if the result is "Normal" or "Abnormal"
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

    // Assuming the last element is a list containing scores
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
}
