import 'package:flutter/material.dart';
import 'package:mboathoscope/controller/appDirectorySingleton.dart';
import 'package:mboathoscope/views/RolePage.dart';
import 'package:mboathoscope/views/StartPage.dart';
import 'package:mboathoscope/views/homePage.dart';
import 'package:provider/provider.dart' as provider;





void main() async{

  ///
  WidgetsFlutterBinding.ensureInitialized();
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
            '/rolepage': (context) => const RolePage(),
            '/homepage': (context) => const HomePage(),
          },
        ),
      )
  );
}

