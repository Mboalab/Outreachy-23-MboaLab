import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mboathoscope/models/recordingmodel.dart';


class RecordingListNotifier extends StateNotifier<List<Recording>>{
  
  RecordingListNotifier() : super([]); 

  // void addRecording(String pathname, Duration duration){

  //   final recording = Recording(
  //     id: DateTime.now().toString(),
  //     pathname: pathname,
  //     filename: 'Recording - ${DateFormat('h:mm a, MMM d yyyy').format(DateTime.now())}',
  //     dateTime: DateTime.now(),
  //     // duration: duration.toString(),
    
  //   );

  //   state = [...state, recording];

  // }

  void deleteRecording(String id){

    state = state.where((element) => element.id != id).toList();

  }

  void updateRecordingName(String id, String name){

    final index = state.indexWhere((element) => element.id == id);
    final recording = state[index];
    recording.pathname = name;
    state = [...state];
    
  }

}

final RecordingListProvider = StateNotifierProvider<RecordingListNotifier,List<Recording>>( 

  (ref) => RecordingListNotifier()

);