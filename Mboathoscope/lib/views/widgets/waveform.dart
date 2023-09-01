import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:mboathoscope/views/widgets/alert_dialog_rename_rec.dart';
import '../../controller/appDirectorySingleton.dart';





class WaveformButton extends StatefulWidget {
  final PlayerController playerController;
  final String fileName;
  final String path;
  const WaveformButton({Key? key, required this.playerController,required this.fileName, required this.path})
      : super(key: key);

  @override
  State<WaveformButton> createState() => _WaveformButtonState();
}

class _WaveformButtonState extends State<WaveformButton> {

  ///Recording Player
  late bool isPlaying;

  ///state of recording player
  late Duration duration;

  ///Duration of recording
  static int millisecondsInAnHour = 3600000;

  ///Equivalence of milliseconds in an hour


  ///To access delete and rename function of saved recorded files
  AppDirectorySingleton _appDirectorySingleton = AppDirectorySingleton();


  @override
  void initState() {
    super.initState();

    ///Sets recording's player state to not playing upon page initialization
    isPlaying = false;

    ///Initializes the duration of the player's maximum duration
    duration = Duration(milliseconds: widget.playerController.maxDuration);

    ///Used to listen and update duration during the cause of playing
    widget.playerController.onCurrentDurationChanged.listen((event) {
      if(mounted){
        setState(() {
          duration = Duration(milliseconds: event);
        });
      }
    });

    ///Gets player completion event and use to trigger player to
    ///pause when entire audio has been listened
    widget.playerController.onCompletion.listen((event) {
      if(mounted){
        setState(() {
          ///Set playing to not playing since player has reached its end
          isPlaying = !isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    ///Removes all listeners associated to a player
    ///Suspected it is the cause of the bug of audio data
    ///being unable to replayed after several plays, so
    ///commented it out for several re-testing
    // widget.playerController.removeListener(() {});

    ///Stop players since it will no longer be played
    ///Commented it out for several restesting to see
    ///if is the cause of re-play failing after several plays
    // widget.playerController.stopPlayer();

    ///Causes an error/audio leaks so removed,
    ///will investigate later on what causes this
    ///Took it out to retest if it is the cause of re-play failure
    ///after several plays of audio files
    // playerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 7),
          padding: const EdgeInsets.all(2.0),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black),
            color: const Color(0x5ebcc9e5),
          ),

          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(20.0),
          //   color: const Color(0xffF3F7FF),
          //   border: Border.all(color: Colors.black),
          // ),

          child: Row(
            children: <Widget>[

              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    maxRadius: 15.0,
                    backgroundColor: Colors.black,
                    child: IconButton(
                      color: Colors.white,
                      iconSize: 16,
                      icon: isPlaying
                          ? const Icon(Icons.pause,
                              color: Color.fromARGB(255, 154, 202, 241))
                          : const Icon(
                              Icons.play_arrow,
                              color: Color.fromARGB(255, 154, 202, 241),
                            ),
                      onPressed: () {
                        try {
                          if (isPlaying) {
                            ///pause player without freeing resources hence allow replay/continue
                            widget.playerController.pausePlayer();
                          } else {
                            ///FinishMode.pause: Allows audio to replayed several times starting from 0 second
                            widget.playerController.startPlayer(
                                finishMode: FinishMode.pause);
                          }

                          ///Toggls between playing and not playing
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        } catch (e) {
                          ///Print error message in a safe and production friendly way
                          debugPrint(e.toString());
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 2.0,),

              Expanded(
                flex: 5,
                child: AudioFileWaveforms(
                  size: Size(MediaQuery.of(context).size.width, 40.0),
                  playerController: widget.playerController,
                  enableSeekGesture: true,
                  waveformType: WaveformType.long,
                  waveformData: widget.playerController.waveformData,
                  playerWaveStyle: const PlayerWaveStyle(
                    fixedWaveColor: Colors.white54,
                    liveWaveColor: Colors.blueAccent,
                    spacing: 6,
                  ),
                ),
              ),
              const SizedBox(width: 2.0,),
              //------
               Expanded(
                  flex: 1,
                 child: Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: Container(
                      child: GestureDetector(
                        onTap: (){
                          ///Pops up dialog box to enter to new filename
                          DialogUtils_rename.showCustomDialog(context, title: 'title', path: widget.path).
                              then((value){ ///value represents new filename

                              ///Renames recording recording
                              _appDirectorySingleton.renamesRecording(newFilename:value, oldPath: widget.path);
                          });

                        },
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.black,
               
                        ),
                      ),
                    ),
                  ),
               ),
                
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                          ///Deletes recordings from memory
                          _appDirectorySingleton.deletesRecording(widget.path);
                        },
                        child: const Icon(
                          Icons.delete_sweep_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right:1,),
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                
                        },
                        child: const Icon(
                          Icons.share,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

              //-----------
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 9.0, bottom: 2),
          child: duration.inMilliseconds >= millisecondsInAnHour
              ?

              ///Display format for when player is at least an hour of duration
              Row(
                children: [
                  Text(
                      duration.toHHMMSS(),
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  const SizedBox(width: 40),
                    Text(
                      widget.fileName,
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14),
                      ),
                ],
              )
              :

              ///Display format for when player is less than  an hour
              Row(
                children: [
                  Text(
                      duration.toHHMMSS().substring(3, 8),
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(width: 40),
                    Text(
                      widget.fileName,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                ],
              ),
        )
      ],
    );
  }
}
