import 'package:flutter/material.dart';
import 'package:first_project/home/home.dart';
import 'package:first_project/chatting.dart';


void main() => runApp(MyApp());



class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {


    return new MaterialApp(
      title: "AppName",
      debugShowCheckedModeBanner: false,
      theme: new ThemeData.light(),
      home: new Home(),


    );
  }
}
