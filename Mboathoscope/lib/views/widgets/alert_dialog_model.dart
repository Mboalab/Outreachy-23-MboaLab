import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:mboathoscope/controller/appDirectorySingleton.dart';
import 'package:mboathoscope/views/widgets/result.dart';
import 'package:path/path.dart' as p;

import 'CustomDialoge.dart';



class DialogUtils {
  static final DialogUtils _instance = DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;
  static Directory appDirectory = AppDirectorySingleton().appDirectory;
  static String heartBeatFileFolderPath =
      AppDirectorySingleton.heartBeatParentPath;

  static void showCustomDialog(
      BuildContext context, {
        required String title,
        String deleteBtnText = "Delete",
        String saveBtnText = "Save",
        required String path,
        List<dynamic>? predictionResult,


      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          path: path,
          predictionResult: predictionResult,
        );
      },
    );
  }
}
///
/*  TextEditingController textEditingController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)), //this right here
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
                            borderSide:
                                const BorderSide(width: 1, color:  Colors.blueAccent,),
                            borderRadius: BorderRadius.circular(15),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.blueAccent,),
                            borderRadius: BorderRadius.circular(15),
                          ),

                          border: InputBorder.none,
                          // hintText: 'Enter here',
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
                                print("Start preparing player...");
                                final file = File(path);
                                if (!file.existsSync()) {
                                  print("Error: File not found at $path");
                                  return;
                                }
                                PlayerController tempHeartBeatPlayerController =
                                PlayerController();

                                await tempHeartBeatPlayerController.preparePlayer(
                                  path: path,
                                  shouldExtractWaveform: true,
                                  volume: 1.0,
                                );

                                print("Player prepared successfully.");

                                if (textEditingController.text.isNotEmpty) {
                                  print("Renaming file...");
                                  final file = File(path);
                                  String dir = p.dirname(file.path);
                                  String newPath =
                                  p.join(dir, textEditingController.text);
                                  file.renameSync(newPath);

                                  PlayerController t = PlayerController();

                                  await t.preparePlayer(
                                    path: newPath,
                                    shouldExtractWaveform: true,
                                    volume: 1.0,
                                  );

                                  path = newPath;
                                  print("File renamed successfully to $newPath");
                                }

                                AppDirectorySingleton().addToHeartBeatAndPathMap(
                                    path, tempHeartBeatPlayerController);

                                // Close the dialog
                                Navigator.of(context).pop();
                                print("Dialog closed successfully.");

                                // Navigate to the ResultPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultPage(predictionResult: predictionResult),
                                  ),
                                );

                                print("Navigation to ResultPage successful.");
                              } catch (e, stackTrace) {
                                print("Error: $e");
                                // Handle the error, if any
                              }
                            },
                            //color: const Color(0xFF1BC0C5),
                            child: Text( 'Save and See Result'

                            ),

                            ),

                           *//* Text(
                              "Save",
                              // style: TextStyle(color: Colors.white),
                            ),*//*
                          ),

                        SizedBox(
                          child: TextButton(
                            onPressed: () async {
                              try {
                                final file = File(path);
                                print("Deleting file at $path...");
                                if (file.existsSync()) {
                                  await file.delete(); // Use await to wait for the deletion to complete
                                  print("File deleted successfully.");
                                  AppDirectorySingleton().deletesRecording(path);
                                } else {
                                  print("Error: File not found at $path");
                                }
                              } finally {
                                // Close the dialog, whether the deletion was successful or not
                                Navigator.of(context, rootNavigator: true).pop();
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
        });
  }
}
*/