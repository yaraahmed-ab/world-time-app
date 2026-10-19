import 'package:flutter/material.dart';
import 'package:global_time/services/world_time.dart';
import'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {



  void setworldtime() async{
    WorldTime instance = WorldTime(location: "Berlin", flag: "de", url: "Europe/Berlin");
    await instance.getTime();
    if (!mounted)
      return;
    Navigator.pushReplacementNamed(context, "/home", arguments: {
      "location": instance.location,
      "flag": instance.flag,
      "time": instance.time,
      "isDaytime": instance.isDaytime,
    });
  }


  @override
  void initState() {
    super.initState();
    setworldtime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF061B49),
      body: Center(
        child: SpinKitSpinningLines(
          color: Colors.white,
          size: 80.0,
        ),
      )
    );
  }
}
