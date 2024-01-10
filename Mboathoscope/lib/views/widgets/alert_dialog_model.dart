import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:mboathoscope/controller/appDirectorySingleton.dart';
import 'package:mboathoscope/views/widgets/result.dart';
import 'package:path/path.dart' as p;

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
      }) {
    ///
    TextEditingController textEditingController = TextEditingController();

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
                              PlayerController tempHeartBeatPlayerController =
                              PlayerController();

                              ///
                              await tempHeartBeatPlayerController.preparePlayer(
                                path: path,
                                shouldExtractWaveform: true,
                                volume: 1.0,
                              );

                              ///
                              if (textEditingController.text.isNotEmpty) {
                                final file = File(path); // Your file path
                                String dir =
                                p.dirname(file.path); // Get directory
                                String newPath = p.join(
                                    dir, textEditingController.text); // Rename
                                file.renameSync(newPath);

                                PlayerController t = PlayerController();

                                await t.preparePlayer(
                                  path: newPath,
                                  shouldExtractWaveform: true,
                                  volume: 1.0,
                                );

                                ///reset path to the newpath
                                path = newPath;
                              }

                              ///Add to local recording Map/Iterable for Global context
                              ///usage without having to read from Local Storage
                              AppDirectorySingleton().addToHeartBeatAndPathMap(
                                  path, tempHeartBeatPlayerController);

                              // Navigator.pop(context);
                            },
                            //color: const Color(0xFF1BC0C5),
                            child: GestureDetector(
                                child: const Text('Save and See Results'),
                                onTap: () {
                                  Navigator.pushNamed(context, '/Result');
                                }
                            ),

                          ),

                          /* Text(
                              "Save",
                              // style: TextStyle(color: Colors.white),
                            ),*/
                        ),

                        SizedBox(
                          child: TextButton(
                            onPressed: () {
                              ///
                              final file = File(path);
                              file.deleteSync();

                              ///
                              AppDirectorySingleton()
                                  .deletesRecording(path);

                              ///
                              //Navigator.pop(context);
                            },
                            //color: const Color(0xFF1BC0C5),
                            child: const Text(
                              "Delete",
                              // style: TextStyle(color: Colors.white),
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
