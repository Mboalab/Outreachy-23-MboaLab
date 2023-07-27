import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:mboathoscope/controller/appDirectorySingleton.dart';
import 'package:path/path.dart' as p;


class DialogUtils {
  static final DialogUtils _instance = DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;
  static Directory appDirectory = AppDirectorySingleton().appDirectory;
  static String heartBeatFileFolderPath = AppDirectorySingleton.heartBeatParentPath;

  static void showCustomDialog(BuildContext context,
      {
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
                borderRadius:
                BorderRadius.circular(25.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name of recording'),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          child: TextButton(
                            onPressed: () async{
                              PlayerController tempHeartBeatPlayerController = PlayerController();

                              ///
                              await tempHeartBeatPlayerController.preparePlayer(
                                path: path,
                                shouldExtractWaveform: true,
                                volume: 1.0,
                              );

                              ///
                              if(textEditingController.text.isNotEmpty){
                                final file = File(path); // Your file path
                                String dir = p.dirname(file.path); // Get directory
                                String newPath = p.join(dir, textEditingController.text); // Rename
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
                              AppDirectorySingleton().addToHeartBeatAndPathMap(path, tempHeartBeatPlayerController);

                              Navigator.pop(context);

                            },
                            //color: const Color(0xFF1BC0C5),
                            child: const Text(
                              "save",
                              // style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        SizedBox(
                          child: TextButton(
                            onPressed: () {
                              ///
                              final file = File(path);
                              file.deleteSync();

                              ///
                              AppDirectorySingleton().deleteFromHeartBeatAndPathMap(path);

                              ///
                              Navigator.pop(context);
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