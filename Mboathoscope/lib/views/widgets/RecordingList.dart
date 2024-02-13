import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mboathoscope/controller/appDirectorySingleton.dart';
import 'package:mboathoscope/controller/helpers.dart';
import 'package:mboathoscope/models/recordingmodel.dart';
import 'package:mboathoscope/views/widgets/waveform.dart';
import 'package:provider/provider.dart';


List<Recording> listOfRecordings = [];

List<Recording> getRecordings() {
  return listOfRecordings;
}

class RecordingList extends StatefulWidget {
  //final List<ListItem> items;

  const RecordingList({super.key});

  @override
  State<RecordingList> createState() => _RecordingListState();
}

class _RecordingListState extends State<RecordingList> {
  @override
  void initState() {
    super.initState();
    getRecordings();
  }

  @override
  Widget build(BuildContext context) {
    // final listOfRecordings = ref.read(RecordingListProvider);
    return Consumer<AppDirectorySingleton>(

        builder: (BuildContext context, value, Widget? child) {

          listOfRecordings.clear();

          value.heartbeatAndPathMap.forEach((key, value) {

            Recording rec1 = Recording(
              id: key,
              pathname: key,
              filename: helpers().getFileBaseName(File(key)),
              dateTime: DateTime.now(),
              playerController: value,
            );
            listOfRecordings.add(rec1);
            // listOfRecordings.add(rec1);
          });

          return
            Container(
              child: listOfRecordings.isEmpty
                  ? const SizedBox(
                height: 100,
                child: Center(
                  child: Text('No recordings yet'),
                ),
              )

                  :
              Column(

                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    'All Recordings',

                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SingleChildScrollView(


                    child: SizedBox(
                      height: 900,
                      width: 390,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listOfRecordings.length,
                        itemBuilder: (context, index) {
                          //final item = items[index];r®
                          return ListTile(
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 20,
                                  child: WaveformButton(
                                    playerController:listOfRecordings[index].playerController,
                                    fileName:listOfRecordings[index].filename,
                                    path: listOfRecordings[index].pathname,
                                  ),
                                ),
                              ],
                            ),
                            // subtitle: Text(listOfRecordings[index].filename),

                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
        });

    // return SizedBox(
    //   height: 230,
    //   child: ListView.builder(
    //     shrinkWrap: true,
    //     itemCount: listOfRecordings.length,
    //     itemBuilder: (context, index) {
    //       //final item = items[index];
    //       return ListTile(

    //         title: Row(
    //           children: <Widget>[
    //             const Expanded(
    //               flex: 70,
    //               child: Text('')//WaveformButton(),
    //             ),
    //             Expanded(
    //               flex: 10,
    //               child: GestureDetector(
    //                 onTap: (){
    //                   null;
    //                   //to do task
    //                 },
    //                 child: IconButton(
    //                   icon: const Icon(Icons.edit_outlined),
    //                   onPressed: () {
    //                     ref.read(RecordingListProvider.notifier).updateRecordingName(listOfRecordings[index].id, 'New Name');
    //                   } ,
    //                   color: Colors.black,

    //                 ),
    //               ),
    //             ),

    //             Expanded(
    //               flex: 10,
    //               child: IconButton(
    //                 icon:const Icon(Icons.delete_sweep_outlined),
    //                 onPressed: (){
    //                   ref.read(RecordingListProvider.notifier).deleteRecording(listOfRecordings[index].id);
    //                 },
    //                 color: Colors.black,
    //               ),
    //             ),

    //             const Expanded(
    //               flex: 10,
    //               child: Icon(
    //                 Icons.share,
    //                 color: Colors.black,
    //               ),
    //             ),

    //             Expanded(
    //               flex: 6,
    //               child: Stack(
    //                   children: <Widget>[
    //                     Positioned(
    //                       child: Image.asset(
    //                         'assets/images/img_notiblack.png',
    //                       ),
    //                     ),
    //                     const Positioned(
    //                       top: 0.03,
    //                       left: 10,
    //                       child: CircleAvatar(
    //                         radius: 5,
    //                         backgroundColor: Color(0xff3D79FD),
    //                         foregroundColor: Colors.white,
    //                       ), //CircularAvatar
    //                     ),
    //                   ]
    //               ),
    //             ),
    //           ],

    //         ),
    //         subtitle: const Text("Recording 1"),
    //       );
    //     },
    //   ),
    // );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}

// @override
//   Widget build(BuildContext context) {

//     ///Consumer widget to allow for list update upon addition and deletion of a recording
//     ///It executes this very quietly without setState
//     return Consumer<AppDirectorySingleton>(builder: (BuildContext context, value, Widget? child){

//       ///Initialisation of the heartbeat and its corresponding path using the consumer(Notifier)
//       ///reference object corresponding to the recording and its path fetched ones from memory
//       ///and updates during the global usage across the app
//       _heartbeatAndPathMap = value.heartbeatAndPathMap;

//       return SizedBox(
//         height: 240,
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: _heartbeatAndPathMap.length, ///TODO: Fetch local storage
//           itemBuilder: (context, index) {

//             // List<PlayerController>? heartbeatsPlayers = _heartbeatAndPathMap.values.toList();
//             // List<String>? heartbeatFilePaths = _heartbeatAndPathMap.keys.toList();

//             ///Key: this is used to fetch its coressponding recordings
//             String heartBeathFilePath = _heartbeatAndPathMap.keys.elementAt(index);
//             ///Value: this is used to fetch the Player value corressponding to a path
//             PlayerController heartBeatPlayer = _heartbeatAndPathMap[heartBeathFilePath]!;

//             ///Returns recording list widget
//             return recordingListBody(heartBeatPlayer, heartBeathFilePath, value);

//           },
//         ),
//       );

//     });
//   }