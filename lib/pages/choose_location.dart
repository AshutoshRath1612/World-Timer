import 'dart:convert';
import 'dart:ui';
import 'package:world_time/pages/loading.dart';
import 'package:world_time/zones.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../worldtime.dart';
import 'home.dart';

class CHooseLocation extends StatefulWidget {
  const CHooseLocation({Key? key}) : super(key: key);

  @override
  State<CHooseLocation> createState() => _CHooseLocationState();
}

class _CHooseLocationState extends State<CHooseLocation> {
  String zonedropdownvalue = 'Asia';
  String timezonedropdown = 'Asia/Kolkata';
  String currentregion = "";
  String currentZone = "";
  bool isSelected = false;
  String time="";
  bool isDay = true;
  bool isSelectedDay = true;

  // List of items in our dropdown menu
  var zones = [
    "Choose a Zone",
    'Asia',
    'Africa',
    'America',
    'Atlantic',
    'Australia',
    'Europe',
    'Pacific',
  ];

  List timeZones = [];

  Future<void> getTimeZones(String s) async {
    Zones zone = Zones(zone: s);
    await zone.getZones();
    setState(() {
      timeZones = zone.timeZones;
      timezonedropdown = timeZones[0];
    });
  }
  Future<void> setupTime(String s) async {
    WorldTime instance = WorldTime(
        location: "India", url: s);
    await instance.getTime();
      time = instance.time;
      isDay = instance.isDay;
      currentZone = timezonedropdown;
      currentregion = zonedropdownvalue;
  }

  Map data = {};

  @override
  Widget build(BuildContext context) {
    data=ModalRoute.of(context)!.settings.arguments as Map;
    currentZone=data['currentzone'];
    currentregion=data['currentregion'];
    print(data);
    isSelectedDay = data['bgimage'] == 'assets/day.jpg' ? true : false;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("Choose a location"),centerTitle: true,
        backgroundColor: Colors.transparent,foregroundColor:isSelectedDay? Colors.black : Colors.white ,),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(data['bgimage']),
            fit: BoxFit.cover,
            opacity: 0.9
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Current Region: ${currentregion}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  color: isSelectedDay? Colors.black : Colors.white,
                    fontFeatures: [FontFeature.enable('smcp')]
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Text(
                "Current Zone: ${currentZone}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,
                    color: isSelectedDay? Colors.black : Colors.white,
                    fontFeatures: [FontFeature.enable('smcp')]
                ),
              ),
              SizedBox(
                height: 50,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                    color:
                        isSelectedDay ? Colors.grey.withOpacity(0.2): Colors.transparent, //background color of dropdown button

                    border: Border.all(
                        color: Colors.transparent,
                        width: 3), //border of dropdown button
                    borderRadius: BorderRadius.circular(
                        50), //border raiuds of dropdown button
                    boxShadow: <BoxShadow>[
                      //apply shadow on Dropdown button
                      BoxShadow(
                          color:
                              Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                          blurRadius: 5) //blur radius of shadow
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: DropdownButton(
                    dropdownColor: Color.fromRGBO(
                        83, 11, 11, 0.7647058823529411),

                    hint: Text("Select a Zone"),
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    items: zones.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items,
                        style: TextStyle(
                          color: Colors.white
                        ),
                        ),
                      );
                    }).toList(),
                    style: TextStyle(
                      fontSize: 25,
                      color: isSelectedDay? Colors.black : Colors.white,
                    ),
                    value: isSelected ? zonedropdownvalue : "Choose a Zone",
                    borderRadius: BorderRadius.circular(20),
                    onChanged: (String? newValue) {
                      setState(() {
                        isSelected = true;
                        zonedropdownvalue = newValue!;
                        timeZones.clear();
                        getTimeZones(zonedropdownvalue);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                    color:
                    isSelectedDay ? Colors.grey.withOpacity(0.5): Colors.transparent, //background color of dropdown button
                    border: Border.all(
                        color: Colors.transparent,
                        width: 3), //border of dropdown button
                    borderRadius: BorderRadius.circular(
                        50), //border raiuds of dropdown button
                    boxShadow: <BoxShadow>[
                      //apply shadow on Dropdown button
                      BoxShadow(
                          color:
                              Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                          blurRadius: 5) //blur radius of shadow
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: DropdownButton(
                    dropdownColor: Color.fromRGBO(21, 41, 170, 0.8),
                    hint: Text("Select a time zone",
                          style: TextStyle(
                            color: isSelectedDay? Colors.black : Colors.white,
                          ),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    value: timezonedropdown,
                    items: timeZones.map((items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    onChanged: (newValue) {
                      setState(() {
                        timezonedropdown = newValue.toString();
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () async{
                    setState((){
                      currentZone = timezonedropdown;
                      currentregion = zonedropdownvalue;
                    });
                   await setupTime(currentZone);
                      Navigator.pop(context,
                          {
                            'zone': currentZone,
                            'region': currentregion,
                            'time': time.substring(0,time.lastIndexOf(" ")),
                            'ampm' : time.substring(time.lastIndexOf(" ")+1 , time.length),
                            'isDay' : isDay
                          });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh,color: isSelectedDay? Colors.black : Colors.white,),
                    SizedBox(width: 20,),
                    Text(
                    "Update",
                    style: TextStyle(fontSize: 25,color: isSelectedDay? Colors.black : Colors.white,),
                  )
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
