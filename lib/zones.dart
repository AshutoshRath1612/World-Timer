import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Zones{
  String zone;
  List timeZones = [];

  Zones({required this.zone});

  Future<void> getZones() async{
    Response response= await get(Uri.parse("https://worldtimeapi.org/api/timezone/${zone}"));
    timeZones= jsonDecode(response.body);
  }
}


