

import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mboathoscope/controller/PermissionsHelper.dart';
import 'package:mboathoscope/controller/appDirectorySingleton.dart';
import 'package:path_provider/path_provider.dart';

class helpers{

  static Color appBlueColor = const Color(0xff3D79FD);

  ///
  Future<Directory> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    final path = Directory('${directory.path}/heartsound');

    ///if path doesnt exist create it
    await path.exists().then((value){
      if(!value){
        path.create();
      }
    });

    return path;
  }


  ///Get file basename
  String getFileBaseName(File file){
    return file.uri.pathSegments.last.split('.').first;
  }

  ///To delete a recording from the app directory storage/local storage
  deleteRecording(String path){
    File file = File(path);

    if(file.existsSync()){
      file.delete();
    }
  }


  ///Used for confirming before taking irrevertible actions
  confirmActionDialog({required BuildContext context, required String title, required String content, required Function noFunction,
    required Function yesFunction}){
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title, textAlign: TextAlign.justify,),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: ()=>noFunction(),
            child: const Text('No', style: TextStyle(color: Colors.red),),
          ),

          TextButton(
            onPressed: ()=>yesFunction(),
            child: const Text('Yes', style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }


  ///Check for microphone permission
  checkForMicrophonePermission(RecorderController recorderController)async{
    bool hasPermission = await recorderController.checkPermission();
    if(!hasPermission){
      await PermissionsHelper().checkAndRequestForAudioRecordingPermission();
    }
  }


  ///
  saveRecording(TextEditingController textEditingController, oldPath){
    ///Rename if user change default recording name
    if(textEditingController.text.isNotEmpty){

      ///Rename file
      ///It has a bug: After a successful rename, the audioplayer, loses it wave data,
      ///so this function will always be false since I have set input field to read only
      AppDirectorySingleton().renamesRecording(newFilename: textEditingController.text, oldPath: oldPath);


      ///Clears textfiled after saving file so default file name takes over for new file name
      textEditingController.clear();
    }

    ///Remove because rename and delete functions have a bug
    // setState(() {
    //   ///set isRecordingCompleted to false to allow UI to move to default ready to record,
    //   ///else it will stay on save or delete, without allowing new
    //   ///audio to be recorded
    //   isRecordingCompleted = !isRecordingCompleted;
    // });


    ///Toast message of successful addition of new recording
    Fluttertoast.showToast(
        msg: 'New BP Record Added',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }


  ///
  bool isPasswordCompliant(String password, [int minLength = 8]) {
    bool hasMinLength = password.length >= minLength;
    return hasMinLength;
  }

}