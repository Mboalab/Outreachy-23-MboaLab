import 'package:flutter/material.dart';
import 'package:mboathoscope/views/buttons/CustomButton.dart';
import 'package:mboathoscope/views/homePage.dart';
import '../models/User.dart';


class RolePage extends StatelessWidget {
  static const id = 'RolePage';
  final CustomUser user;
  const RolePage({Key? key, required this.user}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF3F7FF),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26,right: 26, top: 87),
            child: Image.asset(
              'assets/images/img_role.png',
              height: 280,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 23, right: 23),
            child: Text(
              'Please select your role',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 35, right: 25, left: 25),
            child: Row(
              children: const [
                 CustomButton(
                  txt: 'Transmitter',
                ),
                 SizedBox(
                  width: 50,
                ),
                 CustomButton(
                  txt: ' Receiver  ',
                )
              ],
            ),
          ),
          
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 40),
            child: GestureDetector(
              onTap: (){
                ///
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: this.user)));
              },
              child: Container(
                width: 120,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  // color: Colors.redAccent,
                  gradient: const LinearGradient(
                    colors: [Color(0xffC5D7FE),Colors.blueAccent],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Next ",
                        style: TextStyle(color: Colors.black,fontSize: 20)
                      ),
                      WidgetSpan(
                        child: Icon(Icons.arrow_forward_ios, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}