import 'package:flutter/material.dart';
import 'package:mboathoscope/views/HomePage.dart';
import 'package:mboathoscope/views/LoginPage.dart';
import 'package:mboathoscope/views/RegisterPage.dart';
import 'package:lottie/lottie.dart';
import 'package:mboathoscope/views/OTPpage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController NameController = TextEditingController();
  final TextEditingController AgeController = TextEditingController();
  final TextEditingController GenderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    final NameField = TextFormField(
        autofocus: false,
        controller: NameController,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          phoneNumberController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blue.shade100,
          // errorBorder: const OutlineInputBorder(
          //     borderSide: BorderSide(color: Colors.white60)),
          errorStyle:
              const TextStyle(color: Color.fromARGB(255, 249, 249, 249)),
          // prefixIcon: const Icon(
          //   Icons.person,
          //   color: Colors.white,
          // ),
          // contentPadding:
          //     EdgeInsets.fromLTRB(w * .0005, 0, w * .0005, 0),
          hintText: "Name",
          hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
          // border: OutlineInputBorder(
          //   borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
          //   borderRadius: BorderRadius.circular(10),
          // ),
          border: InputBorder.none,
        ));

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
            return ("Enter Valid Password(Min. 10 Character)");
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
          // errorBorder: const OutlineInputBorder(
          //     borderSide: BorderSide(color: Colors.white60)),
          errorStyle:
              const TextStyle(color: Color.fromARGB(255, 249, 249, 249)),
          // prefixIcon: const Icon(
          //   Icons.phone,
          //   color: Colors.white,
          // ),
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

    final AgeField = SizedBox(
      width: w * .38,
      child: TextFormField(
          // maxLength: 2,
          autofocus: false,
          controller: AgeController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            RegExp regex = RegExp(r'^.{6,}$');
            if (value!.isEmpty) {
              return ("Phone number is required for login with country code");
            }
            if (!regex.hasMatch(value)) {
              return ("Enter Valid Password(Min. 10 Character)");
            }
            return null;
          },
          onSaved: (value) {
            AgeController.text = value!;
          },
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            // errorBorder: const OutlineInputBorder(
            //     borderSide: BorderSide(color: Colors.white60)),
            errorStyle:
                const TextStyle(color: Color.fromARGB(255, 249, 249, 249)),
            // prefixIcon: const Icon(
            //   Icons.phone,
            //   color: Colors.white,
            // ),
            // contentPadding:
            //     EdgeInsets.fromLTRB(w * .0005, 0, w * .0005, 0),
            hintText: "Age",
            hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
            // border: OutlineInputBorder(
            //   borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
            //   borderRadius: BorderRadius.circular(10),
            // ),
            border: InputBorder.none,
          )),
    );

    final GenderField = SizedBox(
      width: w * .38,
      child: TextFormField(
          autofocus: false,
          controller: GenderController,
          keyboardType: TextInputType.text,
          validator: (value) {
            RegExp regex = RegExp(r'^.{6,}$');
            if (value!.isEmpty) {
              return ("Phone number is required for login with country code");
            }
            if (!regex.hasMatch(value)) {
              return ("Enter Valid Password(Min. 10 Character)");
            }
            return null;
          },
          onSaved: (value) {
            GenderController.text = value!;
          },
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            // errorBorder: const OutlineInputBorder(
            //     borderSide: BorderSide(color: Colors.white60)),
            errorStyle:
                const TextStyle(color: Color.fromARGB(255, 249, 249, 249)),
            // prefixIcon: const Icon(
            //   Icons.phone,
            //   color: Colors.white,
            // ),
            // contentPadding:
            //     EdgeInsets.fromLTRB(w * .0005, 0, w * .0005, 0),
            hintText: "Gender",
            hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
            // border: OutlineInputBorder(
            //   borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
            //   borderRadius: BorderRadius.circular(10),
            // ),
            border: InputBorder.none,
          )),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.blue,
                Colors.blueAccent,
              ],
            ),
            borderRadius: BorderRadius.circular(5)),
        child: MaterialButton(
            padding: EdgeInsets.fromLTRB(w * .1, h * 0.015, w * .1, h * 0.015),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Text(
              "Register",
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
                        height: h * 0.15,
                      ),
                      SizedBox(
                        height: h * .1,
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color:  Color(0xff3D79FD),
                            fontWeight: FontWeight.bold,
                            fontSize: h * .05,
                          ),
                        ),
                      ),
                      SizedBox(height: h * .01),
                      NameField,
                      SizedBox(height: h * .02),
                      phoneNumberField,
                      SizedBox(height: h * .02),
                      Row(
                        children: [
                          AgeField,
                          SizedBox(width: w * .04),
                          GenderField,
                        ],
                      ),
                      SizedBox(height: h * .03),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OtpPage()));
                                },
                                child: Text(
                                  "Register",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(height: h * .02),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Already have an account? ",
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
                                        builder: (context) => LoginPage()));
                              },
                              child: Text(
                                "LogIn",
                                style: TextStyle(
                                  color: Color(0xff3D79FD),
                                  fontWeight: FontWeight.bold,
                                  fontSize: h * .024,
                                ),
                              ),
                            )
                          ]),
                      
                      Container(
                        height: h * .4,
                        width: w * .7,
                        child: Lottie.asset(
                            'assets/animations/RegisterScreenAnimation.json'),
                      ),
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
