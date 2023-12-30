import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HeartPrediction extends StatefulWidget {
  @override
  _HeartPredictionState createState() => _HeartPredictionState();
}

class _HeartPredictionState extends State<HeartPrediction> {
  String _filePath = '';
  String _predictionResult = '';

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'E:\digital sthethoscope\Outreachy-23-MboaLab\Machine-Learning\HeartSoundTrainedFiles\heartbeatclassifier_model.tflite', // Replace with the path to your TFLite model

    );
  }

  Future<void> pickAudioFile() async {
    String? filePath = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    ).then((value) => value?.files.first.path);

    if (filePath != null) {
      setState(() {
        _filePath = filePath;
      });
    }
  }

  Future<void> makePrediction() async {
    if (_filePath.isNotEmpty) {
      var output = await Tflite.runModelOnPath(
        path: _filePath,
      );
      setState(() {
        _predictionResult = output?[0]['label'] ?? 'No prediction result';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heart Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: pickAudioFile,
              child: Text('Pick Audio File'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: makePrediction,
              child: Text('Make Prediction'),
            ),
            SizedBox(height: 16.0),
            Text('File Path: $_filePath'),
            SizedBox(height: 16.0),
            Text('Prediction Result: $_predictionResult'),
          ],
        ),
      ),
    );
  }
}
