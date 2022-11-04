import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:world_time/worldtime.dart';
import 'package:world_time/zones.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  Map data = {};

  String currentregion = "Asia";
  String currentZone = "Asia/Kolkata";

  List timeZones = [];
  Future<void> getTimeZones(String s) async{
    Zones zone = Zones(zone: s);
    await zone.getZones();
    setState(() {
      timeZones = zone.timeZones;
    });
  }

  void initState(){
    super.initState();
    getTimeZones('Asia');
  }
  @override
  Widget build(BuildContext context) {
    data = data.isEmpty ? ModalRoute.of(context)!.settings.arguments as Map : data;
    print(data);
    String bgImage = data['isDay'] ? 'assets/day.jpg' : 'assets/night.jpeg';
    Color? bgColor = data['isDay'] ? Colors.indigo : Colors.grey[800];
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
         decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(bgImage),
          fit: BoxFit.cover,
          opacity: 0.5,
        )),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  onPressed: () async{
                   dynamic result = await Navigator.pushNamed(context, '/location', arguments: {
                     'currentregion':currentregion,
                     'currentzone': currentZone,
                     'bgimage':bgImage
                    });
                   setState(() {
                     data = {
                       'zone': result['zone'],
                       'region': result['region'],
                       'isDay' : result['isDay'],
                       'location' : result['zone'].substring(result['zone'].lastIndexOf("/")+1),
                       'time' : result['time'],
                       'ampm' : result['ampm']
                     };
                   print(result);
                     currentZone = result['zone'];
                     currentregion = result['region'];
                   });
                  },
                  icon: Icon(Icons.edit_location),
                  label: Text("Edit Location"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    onPrimary: Colors.white,
                    shape: StadiumBorder(),
                  )),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [

                  Text(
                    data['location'],
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 5,
                        color: Colors.white,
                        fontFeatures: [FontFeature.enable('smcp')]
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text(
                    data['time'],
                    style: TextStyle(
                        fontSize: 85,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          data['ampm'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFeatures: [FontFeature.enable('onum')],
                            color: Colors.white.withOpacity(0.75)
                          ),
                        ),
                      )
                    ],
                  ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      );
  }
}
