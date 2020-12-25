import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:social_network_app/screens/login_screen.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  //
  // Firestore.instance.settings();

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.black,
      dialogBackgroundColor: Colors.black,
      primarySwatch: Colors.grey,
      cardColor: Colors.white70,
      accentColor: Colors.black,
    ),
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white60);
    return new SplashScreen(
      title: new Text(
        'Welcome In SplashScreen',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      seconds: 6,
      navigateAfterSeconds: LoginScreen(),
      image: new Image.asset('assets/images/loading.gif'),
      backgroundColor: Colors.black,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 150.0,
      onClick: () => print("Flutter Egypt"),
      loaderColor: Colors.white,
    );
  }
}
