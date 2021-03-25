import 'package:chatapp/Chat.dart';
import 'package:chatapp/Global.dart';
import 'package:chatapp/Home.dart';
import 'package:chatapp/Login.dart';
import 'package:chatapp/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: splashscreen(),
      routes: {
        'login':(context)=>Login(),
        'home':(context)=>Home(),
        'chat':(context)=>ChatP()

      },
    );
  }
}

