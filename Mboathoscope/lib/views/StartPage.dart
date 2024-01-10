import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mboathoscope/utils/shared_preference.dart';
import 'package:mboathoscope/views/buttons/CustomButton.dart';

import '../models/User.dart';
import 'HomePage.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

bool isChecking = false;

class _StartPageState extends State<StartPage> {
  void checkNextRoute(BuildContext context) async {
    setState(() => isChecking = true);
    if (await SharedPreference.userIsSaved()) {
      Map<String, dynamic>? userDetails =
      await SharedPreference.readUserDetails();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage(user: CustomUser.fromMap(userDetails))));
    }
    setState(() => isChecking = false);
  }

  @override
  initState() {
    checkNextRoute(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F7FF),
      body: isChecking
          ? CircularProgressIndicator()
          : SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 26, right: 26, top: 87),
                child: Image.asset(
                  'assets/images/img.png',
                  height: 260,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 21, right: 21),
                child: Text(
                  'mboathoscope',
                  style: TextStyle(
                    color: Color(0xff3D79FD),
                    fontWeight: FontWeight.bold,
                    fontSize: 46,
                  ),
                ),
              ),
              const SizedBox(
                height: 44,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/homepage');
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 199),
                  child: CustomButton(
                    txt: 'GetStarted'.tr,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
