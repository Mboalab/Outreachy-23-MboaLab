
class Recording{

  String id;
  String pathname;  // to save the path of memory location where the file is stored
  String filename;  // name of recording
  DateTime dateTime;      // date of recording    // time of recording
  String duration;  // duration of recording
  String result;
  
  Recording({
    required this.id,
    required this.pathname,
    required this.filename,
    required this.dateTime,
    required this.duration,
    required this.result,
    });

}