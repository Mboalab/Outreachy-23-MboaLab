import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mboathoscope/utils/shared_preference.dart';
import 'package:mboathoscope/views/LoginPage.dart';
import '../models/User.dart';

class ProfilePage extends StatelessWidget {
  final CustomUser user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Text(this.user.fullName,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            const SizedBox(
              height: 25,
            ),
            const CircleAvatar(
              radius: 70,
              backgroundImage:
                  AssetImage("assets/images/SampleProfileImage.png"),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffC5D7FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text("    Personal information",
                        style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 255, 255))),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "First Name : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(this.user.fullName.split(" ").first),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Last Name : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(this.user.fullName.split(" ").last),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "DOB : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("10-02-1999"),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Gender : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(this.user.gender),
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    //.........
                    const SizedBox(
                      height: 10,
                    ),
                    Text("    Contact information",
                        style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 255, 255))),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Phone Number : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(this.user.phoneNumber),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Address : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("985 street, west NY, UK"),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Text("    Medical Details",
                        style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 255, 255))),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Blood Group : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("A+"),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await SharedPreference.removeUserDetails();
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                  ),
                  child: Text("Logout"),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff3D79FD)),
                  ),
                  child: Text("Edit Profile"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
