import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime{
  String location;
  String time="";
  String url;
  bool isDay=true;

  WorldTime({required this.location , required this.url});

Future<void> getTime() async{
  Response response= await get(Uri.parse("https://worldtimeapi.org/api/timezone/${url}"));
  Map data=jsonDecode(response.body);
  String datetime = data['datetime'];
  String offsethour = data['utc_offset'].substring(1,3);
  String offsetminutes = data['utc_offset'].substring(4,6);

  DateTime now = DateTime.parse(datetime);
  now = now.add(Duration(hours: int.parse(offsethour) , minutes: int.parse(offsetminutes) ));

  isDay = now.hour >=6 && now.hour<= 18 ? true : false;
  //set the time property
  time = DateFormat.jm().format(now);
}
}


