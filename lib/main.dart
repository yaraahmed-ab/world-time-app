import 'package:flutter/material.dart';
import 'package:global_time/pages/choose_location.dart';
import 'package:global_time/pages/loading.dart';
import 'package:global_time/pages/home.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",

      routes: {
        "/" : (context) => Loading(),
        "/home" : (context) => Home(),
        "/location" : (context) => ChooseLocation()
      },
    )
  );
}

