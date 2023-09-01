import 'package:flutter/cupertino.dart';

class CustomUser {
  late String uid, fullName, phoneNumber, age, gender, email;

  CustomUser({
    required this.uid, required this.fullName, required this.phoneNumber,
    required this.age, required this.gender, required this.email
  });

  Map<String, dynamic> toJson() => {
    "uid": this.uid,
    "fullName": this.fullName,
    "phoneNumber": this.phoneNumber,
    "age": this.age,
    "gender": this.gender,
    "email": this.email
  };

  // Named constructor
  CustomUser.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['uid'];
    fullName = mapData['fullName'];
    phoneNumber = mapData['phoneNumber'];
    age = mapData['age'];
    gender = mapData['gender'];
    email = mapData['email'];
  }

}
