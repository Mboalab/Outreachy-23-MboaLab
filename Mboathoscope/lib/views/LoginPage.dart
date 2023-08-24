import 'package:flutter/material.dart';
import 'package:mboathoscope/views/RegisterPage.dart';
import 'package:lottie/lottie.dart';
import 'package:mboathoscope/views/OTPpage.dart';
import '../models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cft;



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneNumberController = TextEditingController();
  final db = cft.FirebaseFirestore.instance;
  String errorText = "";
  bool accountNotRegistered = false;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    final phoneNumberField = TextFormField(
        autofocus: false,
        controller: phoneNumberController,
        keyboardType: TextInputType.phone,

        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Phone number is required for login with country code");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid phoneNumber (Min. 10 Character)");
          }
          if(accountNotRegistered){
            return errorText;
          }
          return null;
        },

        onSaved: (value) {
          phoneNumberController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blue.shade100,
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white60)),
          errorStyle: const TextStyle(color: Colors.red),
          errorText: errorText,
          prefixIcon: const Icon(
            Icons.phone,
            color: Colors.white,
          ),
          // contentPadding:
          //     EdgeInsets.fromLTRB(w * .0005, 0, w * .0005, 0),
          hintText: "Phone Number",
          hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
          // border: OutlineInputBorder(
          //   borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
          //   borderRadius: BorderRadius.circular(10),
          // ),
          border: InputBorder.none,
          
        ));

    final loginButton = Material(
      elevation: 5,
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
            padding: EdgeInsets.fromLTRB(w * .1, h * 0.015, w * .1, h * 0.015),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () async{
              ///deactivate all error messages
              errorText = "";
              accountNotRegistered = false;

              await db.collection('Users').where('phoneNumber', isEqualTo: phoneNumberController.text).get().then((value){
                if(value.docs.length==0){
                  ///account hasn't been registered
                  setState(() {
                    accountNotRegistered = true;
                    errorText="account doesn't exist, sign up instead";
                  });

                }else{
                  ///Moves to OTP Page to allow user to confirm password
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => OtpPage(customerUser:
                  CustomUser(phoneNumber: phoneNumberController.text.replaceAll(" ", ""), uid: '', fullName: '', gender: '', age: ''))));
                }
              });
            },
            child: Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );

    return Container(
      decoration: const BoxDecoration(color: const Color(0xffF3F7FF),),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(w * .1, h * 0.05, w * .1, h * 0.01),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: h * .1,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xff3D79FD),
                            fontWeight: FontWeight.bold,
                            fontSize: h * .05,
                          ),
                        ),
                      ),
                      SizedBox(height: h * .02),
                      Container(
                        height: h * .4,
                        width: w * .8,
                        child: Lottie.asset('assets/animations/LoginPageAnimation.json'),
                        // assets\animations\LoginPageAnimation.json
                      ),
                      SizedBox(height: h * .05),
                      phoneNumberField,
                      SizedBox(height: h * .04),
                      loginButton,
                      SizedBox(height: h * .04),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: h * .025,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Color(0xff3D79FD),
                                  fontWeight: FontWeight.bold,
                                  fontSize: h * .022,
                                ),
                              ),
                            )
                          ])
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

