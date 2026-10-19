import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class WorldTime {
  String? location; // location of the city
  String? time; // time in that location
  String? flag; // url to an asset flag icon
  String? url; // location url for api endpoint
  bool? isDaytime; // true or false if daytime or not

  WorldTime({this.location, this.flag, this.url});
  Future <void> getTime() async{
    try{Response response = await get(Uri.parse("https://worldtime.timezone.io/api/timezone/$url"));
    Map data= jsonDecode(response.body);


    String datetime = data['datetime'];
    String offset = data['utc_offset'].substring(1,3);
    DateTime now = DateTime.parse(datetime);

    now = now.add(Duration(hours: int.parse(offset)));
    isDaytime = now.hour > 5 && now.hour <19  ? true : false;
    time = DateFormat.jm().format(now);
    }
    catch(e){
      debugPrint("caught error: $e");
      time = "could not get time data";
    }

    }

}