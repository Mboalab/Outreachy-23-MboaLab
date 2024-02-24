import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mboathoscope/controller/appDirectorySingleton.dart';
import 'package:mboathoscope/controller/helpers.dart';
import 'package:mboathoscope/views/widgets/alert_dialog_model.dart';
import 'package:mboathoscope/views/widgets/result.dart';
//import 'package:mboathoscope/views/widgets/result.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'dart:typed_data';

class headerHalf extends StatefulWidget {

  final Function(List<dynamic>,String filePath) onPredictionComplete;
  const headerHalf({Key? key, required this.onPredictionComplete}) : super(key: key);

  @override
  State<headerHalf> createState() => _headerHalfState();
}



class _headerHalfState extends State<headerHalf> {
  static const platform = MethodChannel('com.example.mfcc_flutter_project/audio');


  late final RecorderController recorderController;
  bool isRecordingCompleted = false;


  bool _modelLoaded = false;

  ///for time to determine whether to save or delete
  bool isRecording = false;

  ///for time to determine whether to show microphone or not
  late String path;
  late String outputPath;
  late FlutterSoundPlayer flutterSoundPlayer;
  late List<List<List<List<double>>>> outputFilePath2;
  static Directory appDirectory = AppDirectorySingleton().appDirectory;
  AppDirectorySingleton appDirectorySingleton = AppDirectorySingleton();
  String heartBeatFileFolderPath = AppDirectorySingleton.heartBeatParentPath;
  late tfl.Interpreter _interpreter;

  @override
  void initState() {
    _initialiseController();
    flutterSoundPlayer = FlutterSoundPlayer();
    _loadModel();
    super.initState();
  }


  @override
  void dispose() {
    flutterSoundPlayer.closePlayer();
    super.dispose();
  }
  ///Initializes Recorder
  void _initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }
  Future<List<dynamic>> getMFCC(String path) async {
    try {

      final List<dynamic> mfcc = await platform.invokeMethod('getMFCC', {'filePath': path});
      // print('MFCC: $mfcc');
      return mfcc;
    } on PlatformException catch (e) {
      print("Failed to Extract MFCC: '${e.message}'.");
      return [];
    }
  }
  Future<void> _loadModel() async {
    try {
      _interpreter = await tfl.Interpreter.fromAsset('assets/updated_heart_model.h5.tflite');

      // Check if the input shape matches the expected shape
      var inputShape = _interpreter.getInputTensor(0).shape;
      if (inputShape[0] != 1 || inputShape[1] != 128 || inputShape[2] != 130 || inputShape[3] != 1) {
        print("Error: Model input shape is not as expected.");
        _modelLoaded = false;
      } else {
        // Set a flag to indicate that the model has been successfully loaded
        _modelLoaded = true;
        print('Model loaded successfully.');
      }
    } catch (e) {
      print("Error loading model: $e");
      // Set a flag to indicate that the model failed to load
      _modelLoaded = false;
    }
  }

  Future<void> _predictHeartCondition(List<List<List<List<double>>>> rawData) async {
    try {
      // Print the shape of the input data
      print("Input shape: ${rawData.length} x ${rawData[0].length} x ${rawData[0][0].length} x ${rawData[0][0][0].length}");

      // Ensure that the model is loaded before proceeding
      if (!_modelLoaded) {
        print("Model not loaded yet. Waiting for initialization.");
        await _loadModel();
      }

      if (_modelLoaded && _interpreter != null) {
        // Debugging information
        print("Model input shape: ${_interpreter.getInputTensor(0).shape}");

        // Run the model
        var output = List.filled(_interpreter.getOutputTensor(0).shape.reduce((a, b) => a * b), 0).reshape(_interpreter.getOutputTensor(0).shape);
        _interpreter.run(rawData, output);

        setState(() {
          // Update _prediction with the result
          print("Prediction 1: ${output.toString()}");
          print("Output type home : ${output.runtimeType}");
          widget.onPredictionComplete(output,outputPath);

        });
      } else {
        print("Model failed to load. Prediction cannot be performed.");
      }
    } catch (e) {
      print("Error loading or predicting: $e");
    }
  }



  Widget heartLines() {
    if (isRecording) {
      return SafeArea(

        child: Lottie.asset(
            'assets/animations/lines.json'),
      );
    }
    else {
      return SafeArea(

        child: Lottie.asset(
            'assets/animations/Sline.json'),
      );
    }
  }
  ///
  Widget recordBody() {
    if (isRecording) {
      ///recorderController.isRecording: could have used this but issuing stoprecorder doesn't change it state, will investigate why it doesn't refresh
      return InkWell(
        onTap: () {
          ///For Start or Stop Recording
          _startOrStopRecording();
        },
        child: SafeArea(

          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: RippleAnimation(
                repeat: true,
                color: const Color(0xff3D79FD),
                minRadius: 65,
                ripplesCount: 6,
                child: const CircleAvatar(
                  maxRadius: 65.0,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(
                    Icons.stop,
                    color: Colors.white,
                    size: 70.0,
                  ),
                ),
              )

            // AudioWaveforms(              // ASK..

            //   enableGesture: false,
            //   size: Size(MediaQuery.of(context).size.width / 2, 50),
            //   recorderController: recorderController,
            //   waveStyle: const WaveStyle(waveColor: Color.fromARGB(255, 161, 14, 14), extendWaveform: true, showMiddleLine: false,
            //       durationStyle: TextStyle(color: Colors.black), showDurationLabel: true,
            //       durationLinesColor: Colors.transparent),
            //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: helpers.appBlueColor,),
            //   padding: const EdgeInsets.only(left: 18),
            //   margin: const EdgeInsets.symmetric(horizontal: 15),
            // )

          ),
        ),
      );
    } else {
      ///Applies when recording is completed and saved or start of the page
      return InkWell(
        child: CircleAvatar(
          maxRadius: 80.0,
          backgroundColor: Colors.white,
          child: Image.asset(
            'assets/images/img_record.png',
            height: 150,
            width: 150,
          ),
        ),
        onTap: () {
          ///Start or Stop Recording
          _startOrStopRecording();
        },
      );

      // Container(                           // ASK..
      //   height: 140,
      //   width: 140,
      //   decoration: BoxDecoration(
      //     color: helpers.appBlueColor,
      //     shape: BoxShape.circle,
      //   ),
      //   child: IconButton(
      //     icon: const Icon(Icons.mic),
      //     iconSize: 100,
      //     color: Colors.white,
      //     onPressed: () {
      //       ///Start or Stop Recording
      //       _startOrStopRecording();
      //     },
      //   ),
      // );
    }
  }

  ///Starts and Stops Recorder
  _startOrStopRecording() async {
    ///
    helpers().checkForMicrophonePermission(recorderController);

    try {
      if (recorderController.isRecording) {
        recorderController.reset();

        ///Stops recording and returns path,
        ///saves file automatically here
        recorderController.stop(false).then((value) async {
          outputPath = await executeFFmpegCommand(path!);

          // Get MFCC results and await the result directly
          final mfccResults = await getMFCC(path);
          print("MFCC Results - 1: $mfccResults");
          List<double> mfccDoubleResults = mfccResults.cast<double>();
          List<List<List<List<double>>>> reshapedMfccResults = reshapeMfccResults(mfccDoubleResults);
          print("MFCC Results - 2: $reshapedMfccResults");
          DialogUtils.showCustomDialog(
              context, title: 'title', path: outputPath);
          /*    print("Before calling convertAudioToArray");

          outputFilePath2 = await convertAudioToArray(path);
          print("After calling convertAudioToArray");
          print("Audio3DArray22222222222222222: $outputFilePath2");*/

          // Predict heart condition after converting our decode audio array to 3D
          await _predictHeartCondition(reshapedMfccResults.cast<List<List<List<double>>>>());

        });

        ///Remove because rename and delete functions have a bug
        ///This allows UI to switch to allow user to either save or delete, also allow for rename
        setState(() {
          isRecording = !isRecording;
          // isRecordingCompleted = true;
        });
      } else {
        ///States paths for recording to be saved
        path =
        "${appDirectory.path}/$heartBeatFileFolderPath${DateTime
            .now()
            .millisecondsSinceEpoch}.mpeg4";
        final denoiseCommand = "-i $path -af nlmeans $path";
        final session = await FFmpegKit.executeAsync(denoiseCommand);
        final returnCode = await session.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
          print("FFmpeg process completed successfully.");
        } else if (ReturnCode.isCancel(returnCode)) {
          print("FFmpeg process cancelled by user.");
        } else {
          print("FFmpeg process failed with return code $returnCode.");
        }
        await recorderController.record(path: path);

        /// refresh state for changes on page to reflect
        setState(() {
          isRecording = !isRecording;
        });
      }
    } catch (error) {
      debugPrint(error.toString());
    } finally {}
  }


  // Initialize the 4D array with the specified dimensions: [1, height, width, channels]

  List<List<List<List<double>>>> reshapeMfccResults(List<double> mfccResults) {
    // Initialize the 4D array with zeros for padding
    int height = 128;
    int width = 130;
    int channels = 1;
    List<List<List<List<double>>>> reshaped = List.generate(1, (_) =>
        List.generate(height, (_) =>
            List.generate(width, (_) =>
                List.generate(channels, (_) => 0.0) // Use zeros for padding
            )
        )
    );

    // Calculate the number of elements to iterate over in the flat list
    int numElements = min(mfccResults.length, height * width);

    // Populate the 4D array with values from mfccResults
    for (int i = 0; i < numElements; i++) {
      int h = i ~/ width;
      int w = i % width;
      reshaped[0][h][w][0] = mfccResults[i];
    }

    return reshaped;
  }
/*
  List<List<List<List<double>>>> reshapeMfccResults(List<double> mfccResults) {
    // Initialize the 4D array with zeros for padding
    int height = 128;
    int width = 130;
    int channels = 1;
    List<List<List<List<double>>>> reshaped = List.generate(1, (_) =>
        List.generate(height, (_) =>
            List.generate(width, (_) =>
                List.generate(channels, (_) => 0.0) // Use zeros for padding
            )
        )
    );

    // Calculate the number of elements to iterate over in the flat list
    int numElements = min(mfccResults.length, height * width);

    // Populate the 4D array with values from mfccResults
    for (int i = 0; i < numElements; i++) {
      int h = i ~/ width;
      int w = i % width;
      reshaped[0][h][w][0] = mfccResults[i];
    }

    return reshaped;
  }
*/


  Future<List<List<List<List<double>>>>> convertAudioToArray(String outputPath) async {
    try {
      print("Opening player...");
      await flutterSoundPlayer.openPlayer();

      // Use flutter_sound to load audio file
      File audioFile = File(outputPath);
      List<int> audioBytes = await audioFile.readAsBytes();

      // Convert the list of bytes to Uint8List
      Uint8List audioData = Uint8List.fromList(audioBytes);

      // Set the number of channels (adjust based on your actual data)
      int channels = 1;

      // Set the default width to 130
      int targetWidth = 130;

      // Set the dimensions for height and width
      int height = 128; // Replace with your desired height
      int width = targetWidth;

      // Set the depth (new dimension for 4D array)
      int depth = 1;

      // Create a 4D array to store the audio data
      List<List<List<List<double>>>> audio4DArray = List.generate(
        channels,
            (channelIndex) => List.generate(
          height,
              (depthIndex) => List.generate(
            width,
                (heightIndex) => List.generate(
              depth,
                  (widthIndex) {
                int sampleIndex = heightIndex * width + widthIndex;
                int byteIndex = (sampleIndex * channels + channelIndex) * 1;

                // Ensure that byteIndex is within the valid range
                if (byteIndex < audioData.length) {
                  double normalizedValue = (audioData[byteIndex] - 128) / 128.0;
                  return normalizedValue;
                } else {
                  // Handle the case where byteIndex is out of range
                  return 0.0; // or any default value
                }
              },
            ),
          ),
        ),
      );

      // Print the 4D array (for demonstration purposes)
      print("Audio4DArray: $audio4DArray");

      print("Returning audio4DArray...");
      return audio4DArray;
    } catch (e) {
      print("Error: $e");
      return null!;
    } finally {
      print("Closing player...");
      await flutterSoundPlayer.closePlayer();
    }
  }

  Future<String> executeFFmpegCommand(String input) async {

    String path = '${appDirectory!.path}/${'audio_message'.substring(0, min('audio_message'.length, 100))}_${DateTime.now().millisecondsSinceEpoch.toString()}.aac';
    await FFmpegKit
        .execute(
        '-y -i $input -af "asplit[a][b],[a]adelay=32S|32S[a],[b][a]anlms=order=128:leakage=0.0005:mu=.5:out_mode=o" $path')
        .then((session) async{
      await session.getLogs().then((value) {
        for (Log i in value) {
          if (kDebugMode) {
            print(i.getMessage());
          }
        }
      });

      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        if (kDebugMode) {
          print("FFmpeg process completed successfully.");
        }
      } else if (ReturnCode.isCancel(returnCode)) {
        if (kDebugMode) {
          print("FFmpeg process cancelled.");
        }
        path = "";
      } else {
        if (kDebugMode) {
          print("FFmpeg process failed.");
        }
        path = "";
      }
    });
    return path;
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.only(top: 34.0, left: 20, right: 30),
          child: Row(
            children: <Widget>[


              Expanded(
                flex: 5,
                child: Image.asset(
                  'assets/images/img_head.png',
                  height: 80,
                  width: 80,
                ),
              ),

              const SizedBox(
                width: 150,
              ),

              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Image.asset(
                          'assets/images/img_notiblack.png',
                          height: 35,
                          width: 32,
                          color: const Color(0xff3D79FD),
                        ),
                      ),

                      const Positioned(
                        bottom: 0.02,
                        right: 3,
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Color(0xff3D79FD),
                          foregroundColor: Colors.white,
                        ), //CircularAvatar
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
            padding: const EdgeInsets.only(
              right: 0,
              left: 10,
              top: 0,
              bottom: 0,
            ),
            child : Row (
              children:   [Container(
                height: h * .4,
                width: w * .9,
                child: heartLines(),
              ),
              ],
            )
        ),


        Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
            left: 8.0,
            top: 0.0,
            bottom: 0.0,
          ),


          child: Row(
            children: <Widget>[

              // Expanded(                  // ASK --> heart & lung switch
              //   flex: 1,
              //   //padding: const EdgeInsets.only(left: 2.0, right: 2.0),
              //   child: Stack(
              //     children: [
              //       Container(
              //         alignment: Alignment.center,
              //         child: Image.asset(
              //           'assets/images/img_round.png',
              //           height: 80,
              //           width: 80,
              //         ),
              //       ),
              //       Container(
              //         alignment: Alignment.center,
              //         child: Padding(
              //           padding: const EdgeInsets.only(top: 18.0),
              //           child: Column(
              //             children: [
              //               Image.asset(
              //                 'assets/images/img_heart.png',
              //                 height: 20,
              //                 width: 20,
              //               ),
              //               const Text(
              //                 'heart',
              //                 style: TextStyle(
              //                   fontSize: 12,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    left: 8.0,
                    top: 20.0,
                    bottom: 7.0,
                  ),
                  child: recordBody(),
                ),
              )
            ],
          ),
        ),


        // Consumer<AppDirectorySingleton>(           // ASK..
        //   builder: (context, appDirSingleton, child) {
        //     return Text(
        //         'Total count: ${appDirSingleton.heartbeatAndPathMap.entries.length}');
        //   },
        // ),

        const Text(
          'Press and hold the button to transmit the sound',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
          ),
        ),
        const Padding(
          padding:
          EdgeInsets.only(top: 10.0, bottom: 8.0, left: 35.0, right: 35.0),
          child: Text(
            'Please ensure that you are wearing noise cancelling headphones',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),


      ],
    );

  }
}