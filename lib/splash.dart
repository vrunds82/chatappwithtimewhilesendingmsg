import 'package:flutter/material.dart';
import 'dart:async';

class splashscreen extends StatefulWidget {
  @override
  _splashscreenState createState() => _splashscreenState();
}
class _splashscreenState extends State<splashscreen> {
  startTime() async {

    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
    navigationPage();
  }
  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('login');
  }
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(decoration: new BoxDecoration(
        color: const Color(0xff7c94b6),
        image: new DecorationImage(
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
          image: new  AssetImage('assets/images/bg.jpg'),
        ),
      ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
           Image.asset('assets/images/chat.png')]
          ),
        ),
      ),
    );
  }
}