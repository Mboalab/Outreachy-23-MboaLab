import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:mboathoscope/controller/appDirectorySingleton.dart';
import 'package:mboathoscope/views/widgets/result.dart';
import 'package:path/path.dart' as p;

class CustomDialog extends StatefulWidget {
  final String path;
  final List<dynamic>? predictionResult;

  const CustomDialog({
    Key? key,
    required this.path,
    this.predictionResult,
  }) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  TextEditingController textEditingController = TextEditingController();
  late String path;

  @override
  void initState() {
    super.initState();
    path = widget.path;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: SizedBox(
        height: 170,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  labelText: 'Enter Recording Name',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    child: TextButton(
                      onPressed: () async {
                        try {
                          PlayerController tempHeartBeatPlayerController =
                          PlayerController();

                          await tempHeartBeatPlayerController.preparePlayer(
                            path: path,
                            shouldExtractWaveform: true,
                            volume: 1.0,
                          );

                          if (textEditingController.text.isNotEmpty) {
                            final file = File(path);
                            String dir = p.dirname(file.path);
                            String newPath = p.join(
                              dir,
                              textEditingController.text,
                            );
                            file.renameSync(newPath);

                            PlayerController t = PlayerController();

                            await t.preparePlayer(
                              path: newPath,
                              shouldExtractWaveform: true,
                              volume: 1.0,
                            );

                            // Update the path with the new path
                            path = newPath;
                            print(
                              "File renamed successfully to $newPath",
                            );
                          }

                          AppDirectorySingleton().addToHeartBeatAndPathMap(
                            path,
                            tempHeartBeatPlayerController,
                          );

                          // Close the dialog
                          Navigator.of(context).pop();

                          // Navigate to the ResultPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultPage(
                                predictionResult: widget.predictionResult,
                                audioPath: path, // Pass the audio recording path
                              ),
                            ),
                          );
                        } catch (e, stackTrace) {
                          print("Error: $e");
                          // Handle the error, if any
                        }
                      },
                      child: Text('Save and See Result'),
                    ),
                  ),
                  SizedBox(
                    child: TextButton(
                      onPressed: () async {
                        try {
                          final file = File(path);
                          if (file.existsSync()) {
                            file.deleteSync();
                            AppDirectorySingleton().deletesRecording(path);
                            // Close the dialog
                            Navigator.of(context).pop();
                            // Navigate to the ResultPage
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/homepage',      ModalRoute.withName('/'), arguments: (Route<dynamic> route) => false);


                          } else {
                            print("Error: File not found at $path");
                            // Handle the case where the file doesn't exist
                          }
                        } catch (e, stackTrace) {
                          print("Error: $e");
                          // Handle the error, if any
                        }
                      },
                      child: const Text(
                        "Delete",
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}