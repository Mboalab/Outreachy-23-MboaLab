import 'package:cloud_firestore/cloud_firestore.dart' as cft;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mboathoscope/controller/helpers.dart';
import 'package:mboathoscope/utils/shared_preference.dart';
import 'package:mboathoscope/views/RegisterPage.dart';
import 'package:mboathoscope/views/RolePage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../models/User.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final db = cft.FirebaseFirestore.instance;
  String errorText = "";
  bool accountNotRegistered = false;
  bool emailErrorExist = false;
  bool passwordErrorExist = false;
  String emailErrorText = "";
  String passwordErrorText = "";
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  // signInWithPhone()async{
  //   await db.collection('Users').where('phoneNumber', isEqualTo: phoneNumberController.text).get().then((value){
  //     if(value.docs.length==0){
  //       ///account hasn't been registered
  //       setState(() {
  //         accountNotRegistered = true;
  //         errorText="account doesn't exist, sign up instead";
  //       });
  //
  //     }else{
  //       ///Moves to OTP Page to allow user to confirm password
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => OtpPage(customerUser:
  //       CustomUser(phoneNumber: phoneNumberController.text.replaceAll(" ", ""), uid: '', fullName: '', gender: '', age: '', email: ''),
  //         password: '',)));
  //     }
  //   });
  // }

  ///Authenticate user sign in with Email and Password
  signInWithEmailAndPassword() async {
    setState(() => isLoading = true);
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      await _auth
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        if (value.user != null) {
          ///fetch user details from db
          db
              .collection("Users")
              .where('email', isEqualTo: value.user!.email)
              .get()
              .then((value) async {
            ///
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RolePage(
                        user: CustomUser.fromMap(value.docs.first.data()))));

            ///Save user login Details to SharedPreferences
            await SharedPreference.saveUserDetails(value.docs.first.data());
          });
          setState(() => isLoading = false);
        }
      }).onError((error, stackTrace) {
        setState(() => isLoading = false);
        debugPrint(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    // final phoneNumberField = TextFormField(
    //     autofocus: false,
    //     controller: phoneNumberController,
    //     keyboardType: TextInputType.phone,
    //
    //     validator: (value) {
    //       RegExp regex = RegExp(r'^.{6,}$');
    //       if (value!.isEmpty) {
    //         return ("Phone number is required for login with country code");
    //       }
    //       if (!regex.hasMatch(value)) {
    //         return ("Enter Valid phoneNumber (Min. 10 Character)");
    //       }
    //       if(accountNotRegistered){
    //         return errorText;
    //       }
    //       return null;
    //     },
    //
    //     onSaved: (value) {
    //       phoneNumberController.text = value!;
    //     },
    //     textInputAction: TextInputAction.done,
    //     decoration: InputDecoration(
    //       filled: true,
    //       fillColor: Colors.blue.shade100,
    //       errorBorder: const OutlineInputBorder(
    //           borderSide: BorderSide(color: Colors.white60)),
    //       errorStyle: const TextStyle(color: Colors.red),
    //       errorText: errorText,
    //       prefixIcon: const Icon(
    //         Icons.phone,
    //         color: Colors.white,
    //       ),
    //       hintText: "Phone Number",
    //       hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
    //       border: InputBorder.none,
    //
    //     ));

    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return 'this field can\'t be empty';
          } else if (RegExp(
                  r"^[a-zA-Z\d.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z] +")
              .hasMatch(value)) {
            return "incorrect email format";
          } else if (!value.contains('@')) {
            return "invalid email format";
          } else if (emailErrorExist) {
            return emailErrorText;
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blue.shade100,
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white60)),
          errorStyle: const TextStyle(color: Colors.red),
          errorText: errorText,
          hintText: "Email".tr,
          hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
          border: InputBorder.none,
        ));

    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        validator: (value) {
          if (value!.isEmpty) {
            return "Password cannot be empty";
          } else if (!helpers().isPasswordCompliant(value)) {
            return "Password must be at least 8 character long";
          } else if (passwordErrorExist) {
            return passwordErrorText;
          }
          return null;
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blue.shade100,
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white60)),
          errorStyle: const TextStyle(color: Colors.red),
          errorText: passwordErrorText,
          hintText: "Password".tr,
          hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
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
            onPressed: () async {
              ///deactivate all error messages
              errorText = "";
              accountNotRegistered = false;
              emailErrorText = "";
              passwordErrorText = "";
              emailErrorExist = false;
              passwordErrorExist = false;

              ///Signin with email and Password
              signInWithEmailAndPassword();
            },
            child: Text(
              "Login".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );

    return Container(
      decoration: const BoxDecoration(
        color: const Color(0xffF3F7FF),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ModalProgressHUD(
            inAsyncCall: isLoading,
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
                            'Login'.tr,
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
                          child: Lottie.asset(
                              'assets/animations/LoginPageAnimation.json'),
                        ),
                        SizedBox(height: h * .05),
                        emailField,
                        passwordField,
                        loginButton,
                        SizedBox(height: h * .04),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "NoAccount".tr,
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: h * .021,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPage()));
                                },
                                child: Text(
                                  "Register".tr,
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
      ),
    );
  }
}
