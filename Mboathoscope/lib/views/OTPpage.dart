import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:mboathoscope/views/HomePage.dart';
import 'package:mboathoscope/views/RolePage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:  const Color(0xffF3F7FF),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            Text(
              "      Verification",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.blueGrey),
            ),
            Text(
              "     We send you an SMS code",
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color:  Color(0xff3D79FD),),
            ),
            Text(
              "      On Number - 95XXXXXX08",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.blueGrey),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(30,5,30,5),
              child: Center(
                child: PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  // animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    activeColor: Colors.blue.shade100,
                    activeFillColor: Colors.blue.shade100,
                    inactiveFillColor: Colors.blue.shade100,
                    selectedFillColor: Colors.blue.shade100,
                    disabledColor: Colors.blue.shade100,
                    inactiveColor: Colors.blue.shade100,
                    selectedColor: Colors.blue,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                  ),
                  enableActiveFill: true,
                  controller: textEditingController,
                  appContext: context,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(17,0,17,0),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.blue,
                           Color(0xff3D79FD),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: MaterialButton(
                      // padding: EdgeInsets.fromLTRB(
                      //     w * .1, h * 0.005, w * .1, h * 0.005),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                         Navigator.push(context,
                            MaterialPageRoute(builder: (context) => RolePage()));
                       
                      },
                      child: Text(
                        "Confirm",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ),
            const SizedBox(height: 10),
             Row(
              children: [
                Text(
                  "      SMS not receireceived ? ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  "SEND AGAIN",
                  style: TextStyle(fontSize: 16, color:  Color(0xff3D79FD),fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(55,0,55,0),
              child: Lottie.asset(
                'assets/animations/ForgetPasswordScreenAnimation.json',
                height: h * 0.7,
                width: w * 0.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
