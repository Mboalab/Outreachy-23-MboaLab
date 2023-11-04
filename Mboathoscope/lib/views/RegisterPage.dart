import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mboathoscope/controller/helpers.dart';
import 'package:mboathoscope/views/LoginPage.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cft;
import 'package:mboathoscope/views/RolePage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';
import '../models/User.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController NameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController verifyPasswordController =
      TextEditingController();
  final TextEditingController AgeController = TextEditingController();
  final TextEditingController GenderController = TextEditingController();

  ///
  final db = cft.FirebaseFirestore.instance;
  bool phoneNumberExist = false;
  bool emailErrorExist = false;
  String errorText = "";
  String emailErrorText = "";
  bool _obscureText = true;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  ///Creates an email and password authentication for this account.
  initiateVerificationEmailAndPassword(CustomUser customUser) async {
    setState(() => isLoading = true);
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) async {
        /// Add a new user with a generated ID
        await db.collection("Users").add(customUser.toJson());
        setState(() => isLoading = false);
        if (value.user != null) {
          ///Signup already have user details
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RolePage(user: customUser)));
          setState(() => isLoading = false);
        }
      });
    } catch (error) {
      setState(() => isLoading = false);

      ///
      emailErrorExist = true;

      ///Thrown if there already exists an account with the given email address.
      if (error.toString().contains('email-already-in-use')) {
        setState(() {
          emailErrorText = 'Email already in use';
        });

        ///Thrown if the email address is not valid.
      } else if (error.toString().contains('invalid-email')) {
        setState(() {
          emailErrorText = "Invalid email";
        });

        ///Thrown if email/password accounts are not enabled. Enable email/password accounts
        ///in the Firebase Console, under the Auth tab.
      } else if (error.toString().contains("operation-not-allowed")) {
        setState(() {
          emailErrorText = "Ooops, server error";
        });

        ///Thrown if the password is not strong enough.
      } else if (error.toString().contains("weak-password")) {
        setState(() {
          emailErrorText = "weak-password";
        });
      }
    }
  }

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
          errorStyle:
              const TextStyle(color: Color.fromARGB(255, 249, 249, 249)),
          hintText: "Name",
          hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
          border: InputBorder.none,
        ));

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
          errorText: emailErrorText,
          hintText: "Email",
          hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
          border: InputBorder.none,
        ));

    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _obscureText,
        validator: (value) {
          if (value!.isEmpty) {
            return "Password cannot be empty";
          } else if (!helpers().isPasswordCompliant(value)) {
            return "Password must be at least 8 character long";
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
          // errorText: errorText,
          hintText: "Password",
          hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
          border: InputBorder.none,
        ));

    final verifyPasswordField = TextFormField(
        autofocus: false,
        controller: verifyPasswordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _obscureText,
        validator: (value) {
          if (value!.isEmpty) {
            return "Password cannot be empty";
          } else if (!helpers().isPasswordCompliant(value)) {
            return "Password must be at least 8 character long";
          } else if (passwordController.text != value) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          verifyPasswordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blue.shade100,
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white60)),
          errorStyle: const TextStyle(color: Colors.red),
          // errorText: errorText,
          hintText: "Verify Password",
          hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
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
            return ("Enter Valid Phone number (Min. 10 Character)");
          }
          if (phoneNumberExist) {
            return ("Phone number exists");
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
          hintText: "Phone Number",
          hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
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
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white60)),
            errorStyle:
                const TextStyle(color: Color.fromARGB(255, 249, 249, 249)),
            hintText: "Age",
            hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
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
            errorStyle:
                const TextStyle(color: Color.fromARGB(255, 249, 249, 249)),
            hintText: "Gender",
            hintStyle: const TextStyle(fontSize: 18.0, color: Colors.white70),
            border: InputBorder.none,
          )),
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
                          height: h * 0.15,
                        ),
                        SizedBox(
                          height: h * .1,
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Color(0xff3D79FD),
                              fontWeight: FontWeight.bold,
                              fontSize: h * .05,
                            ),
                          ),
                        ),
                        SizedBox(height: h * .01),
                        NameField,
                        SizedBox(height: h * .03),
                        emailField,
                        SizedBox(height: h * .02),
                        passwordField,
                        // SizedBox(height: h * .01),
                        verifyPasswordField,
                        SizedBox(height: h * .01),
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
                                  onPressed: () async {
                                    setState(() {
                                      ///resets error message
                                      phoneNumberExist = false;
                                      emailErrorExist = false;
                                      errorText = "";
                                      emailErrorText = "";
                                    });

                                    ///check if number exists
                                    await db
                                        .collection('Users')
                                        .where('phoneNumber',
                                            isEqualTo:
                                                phoneNumberController.text)
                                        .get()
                                        .then((value) async {
                                      if (value.docs.length > 0) {
                                        setState(() {
                                          phoneNumberExist = true;

                                          ///
                                          errorText =
                                              "Phone Number already exists";
                                        });
                                      } else {
                                        ///creates user credentials object
                                        final user = <String, dynamic>{
                                          'uid': Uuid().v4(),
                                          'fullName': NameController.text,
                                          'age': AgeController.text,
                                          'gender': GenderController.text,
                                          'phoneNumber': phoneNumberController
                                              .text
                                              .replaceAll(" ", ""),
                                          "email": emailController.text
                                        };

                                        ///initiate account registration authentitication with email and password
                                        await initiateVerificationEmailAndPassword(
                                            CustomUser.fromMap(user));
                                      }
                                    });
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
      ),
    );
  }
}
