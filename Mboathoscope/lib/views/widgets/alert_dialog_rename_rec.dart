import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mboathoscope/controller/appDirectorySingleton.dart';



class DialogUtils_rename {
  static final DialogUtils_rename _instance = DialogUtils_rename.internal();

  DialogUtils_rename.internal();

  factory DialogUtils_rename() => _instance;
  static Directory appDirectory = AppDirectorySingleton().appDirectory;
  static String heartBeatFileFolderPath =
      AppDirectorySingleton.heartBeatParentPath;

  ///to access rename functions
  static AppDirectorySingleton _appDirectorySingleton = AppDirectorySingleton();


  static Future<String> showCustomDialog(
    BuildContext context, {
    required String title,
    String deleteBtnText = "Delete",
    String saveBtnText = "Save",
    required String path,
  }) async {
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
                          labelText: 'Enter new filename',

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
                              ///renames saved audio file
                              if(textEditingController.text.isNotEmpty){ ///ensures user provides a new file name before proceeding with rename, a form of input validation
                                _appDirectorySingleton.renamesRecording(newFilename: textEditingController.text, oldPath: path);

                                ///close dialog box
                                Navigator.pop(context);

                              }
                              else{
                                ///flutter toast feedback
                                Fluttertoast.showToast(
                                    msg: "You have provided a new file name",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );

                              }

                            },
                            //color: const Color(0xFF1BC0C5),
                            child: const Text(
                              "Rename",
                              // style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          child: TextButton(
                            onPressed: () {
                              ///stops or cancels rename attempt
                              Navigator.pop(context);
                            },
                            //color: const Color(0xFF1BC0C5),
                            child: const Text(
                              "Cancel",
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

       ///Returns value of new file name or null in the case where new file name was not provided.
       return textEditingController.text;
  }
}
