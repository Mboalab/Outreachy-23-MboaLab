import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mboathoscope/views/HomePage.dart';
import 'package:mboathoscope/views/RolePage.dart';
import 'package:mboathoscope/views/StartPage.dart';


void main() {

  runApp(
   const ProviderScope(child: MyApp()),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
      // title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const StartPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '': (context) => const StartPage(),
        '/rolepage': (context) => const RolePage(),
        '/homepage': (context) => const HomePage(),
      },
    );
    
  }
}

