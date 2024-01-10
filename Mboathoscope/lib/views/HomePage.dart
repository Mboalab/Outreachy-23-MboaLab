import 'package:flutter/material.dart';
import 'package:mboathoscope/models/User.dart';
import 'package:mboathoscope/views/ProfilePage.dart';
import 'package:mboathoscope/views/widgets/RecordingList.dart';
import 'package:mboathoscope/views/widgets/HomePage_headerHalf.dart';

import '../record_implementation/recorder_main.dart';

class HomePage extends StatefulWidget {
  final CustomUser user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///index user has clicked/active navigation button
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    ///for navigation page except settings
    if (index < 3) {
      setState(() {
        _selectedIndex = index;
      });
    }

    ///for settings page
    if (index == 3) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  ///
  List<Widget> widgetList() {
    return [
      ///navigation bottom 0
      Container(
        child: const headerHalf(),
      ),
      // MyRecorderApp(),

      ///navigation bottom 1
      Container(
        child: const RecordingList(),
      ),

      ///navigation bottom 2
      Container(),

      ///navigation bottom 3
      ProfilePage(
        user: widget.user,
      )
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F7FF),
      body: SingleChildScrollView(
        child: widgetList()[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: const Color(0xffF3F7FF),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Color(0xffF3F7FF),
            icon: ImageIcon(
              AssetImage("assets/images/img_profile.png"),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/img_explore.png"),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/img_recordings.png"),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/img_setting.png"),
            ),
            label: '',
          ),
        ],
        selectedItemColor: const Color(0xff3D79FD),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
