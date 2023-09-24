import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:mboathoscope/themes/theme_extension.dart';
import 'package:mboathoscope/views/RolePage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/User.dart' as cu;
import 'package:cloud_firestore/cloud_firestore.dart' as cft;

class OtpPage extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';
  final cu.CustomUser customerUser;
  const OtpPage({Key? key, required this.customerUser}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with WidgetsBindingObserver {
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";
  bool isKeyboardVisible = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  var receivedID = '';
  bool otpFieldVisibility = true;

  ///Firestore Database instance for CRUD actions on the database
  final db = cft.FirebaseFirestore.instance;

  ///Verifies OTP by comparing OTP entered by user with one generated by system
  Future<void> verifyOTPCode() async {
    ///
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: receivedID,
      smsCode: textEditingController.text,
    );

    ///
    await _auth.signInWithCredential(credential).then((value) {
      ///
      debugPrint('User Login In Successful');

      if (widget.customerUser.fullName.isEmpty) {
        ///login fetch in user details
        db
            .collection("Users")
            .where('phoneNumber', isEqualTo: widget.customerUser.phoneNumber)
            .get()
            .then((value) {
          ///
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RolePage(
                      user: cu.CustomUser.fromMap(value.docs.first.data()))));
        });
      } else {
        ///Signup already have user details
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RolePage(user: widget.customerUser)));
      }
    }).catchError((e) {
      if (e.toString().contains('firebase_auth/invalid-verification-code')) {
        ///Handles invalid verification code
        Fluttertoast.showToast(
            msg: "Try again, invalid verification code",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.toString().contains('firebase_auth/session-expired')) {
        ///handle expired otp code
        Fluttertoast.showToast(
            msg: "otp code expired, send again to resend",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        ///handles any other error, could be wrong number, network etc
        Fluttertoast.showToast(
            msg: "Error while verifyinying code",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  ///
  initiateVerification() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.customerUser.phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential).then(
              (value) => debugPrint('Logged In Successfully'),
            );
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        receivedID = verificationId;
        otpFieldVisibility = true;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('TimeOut');
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);

    ///Sends verifications code/initiates authentication
    initiateVerification();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // ignore: deprecated_member_use
    final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffF3F7FF),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            Text(
              "      Verification",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey),
            ),
            Text(
              "     We send you an SMS code",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: context.theme.primaryColor,
              ),
            ),
            Text(
              "      On Number - ${widget.customerUser.phoneNumber.substring(2, 4)}"
                      "XXXXXX" +
                  widget.customerUser.phoneNumber.substring(
                      widget.customerUser.phoneNumber.length - 2,
                      widget.customerUser.phoneNumber.length),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
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
              padding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          context.theme.primaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: MaterialButton(
                      // padding: EdgeInsets.fromLTRB(
                      //     w * .1, h * 0.005, w * .1, h * 0.005),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        ///
                        verifyOTPCode();
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
                TextButton(
                  child: Text(
                    "SEND AGAIN",
                    style: TextStyle(
                        fontSize: 16,
                        color: context.theme.primaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    ///
                    await initiateVerification();
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(55, 0, 55, 0),
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
