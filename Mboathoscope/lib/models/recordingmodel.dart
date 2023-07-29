
import 'package:audio_waveforms/audio_waveforms.dart';

class Recording{

  String id;
  String pathname;  // to save the path of memory location where the file is stored
  String filename;  // name of recording
  DateTime dateTime;      // date of recording    // time of recording
  // duration of recording

  PlayerController playerController;
  
  Recording({
    required this.id,
    required this.pathname,
    required this.filename,
    required this.dateTime,
    required this.playerController,

    });

}