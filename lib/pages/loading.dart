import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:world_time/worldtime.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => LoadingState();
}

class LoadingState extends State<Loading> {

  String time = 'loading';

  Future<void> setupTime(String s) async {
    WorldTime instance = WorldTime(location: "India", url: s);
    await instance.getTime();
      setState(() {
        time = instance.time;
    });
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'location': instance.location,
        'time': instance.time.substring(0,instance.time.lastIndexOf(" ")),
        'isDay': instance.isDay,
        'ampm' : instance.time.substring(instance.time.lastIndexOf(" ")+1, instance.time.length),
      });
  }

  void initState() {
    super.initState();
      print("started");
      setupTime('Asia/Kolkata');
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SpinKitPouringHourGlassRefined(
          color: Colors.white,
          size: 200,
        ),
      ),
    );
  }
}
