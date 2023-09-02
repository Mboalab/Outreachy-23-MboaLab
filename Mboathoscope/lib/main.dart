import 'package:flutter/material.dart';
import 'package:mboathoscope/controller/appDirectorySingleton.dart';
import 'package:mboathoscope/views/LoginPage.dart';
import 'package:mboathoscope/views/RolePage.dart';
import 'package:mboathoscope/views/StartPage.dart';
import 'package:mboathoscope/views/homePage.dart';
import 'package:provider/provider.dart' as provider;
import 'package:firebase_core/firebase_core.dart';
import 'models/User.dart';





void main() async{

  ///
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AppDirectorySingleton().getAppDirectory();
  await AppDirectorySingleton().fetchRecordings();

  runApp(
      provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider<AppDirectorySingleton>(create: (_) => AppDirectorySingleton()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const StartPage(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '': (context) => const StartPage(),
            '/rolepage': (context) => RolePage(user: CustomUser(uid: '', fullName: "", phoneNumber: '', age: '', gender: '', email: ''),),
            '/login': (context) => const LoginPage(),
            '/homepage': (context) => HomePage(user: CustomUser(uid: '', fullName: "", phoneNumber: '', age: '', gender: '', email: ''),),
          },
        ),
      )
  );
}

