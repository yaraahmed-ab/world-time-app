import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:global_time/services/world_time.dart';
import 'package:http/http.dart';


class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  void updateTime(Map city) async {
    if (city["timezone"] == null || isLoading) return;

    setState(() => isLoading = true);

    String code = (city["country_code"] ?? "").toLowerCase();
    WorldTime instance = WorldTime(
        location: city["name"],
        flag: code,
        url: city["timezone"]);
    await instance.getTime();
    if (!mounted) return;

    // getTime() leaves isDaytime null when the request fails
    if (instance.isDaytime == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not get the time for this location")),
      );
      return;
    }

    Navigator.pop(context, {
      "location": instance.location,
      "flag": instance.flag,
      "time": instance.time,
      "isDaytime": instance.isDaytime,
    });
  }

  List results = [];
  Timer? _debounce;
  bool isLoading = false;
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future <void> searchLocation(String city) async{
    if (city.trim().length < 2) {
     setState(() => results = []);
     return;}
    try{
      final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
        'name': city
      });
      Response response = await get(uri);
      Map data = jsonDecode(response.body);
      setState(() {
      results = data["results"] ?? [];
      });

    }
    catch (e){
      print("caught error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text("Choose a location",
        style: TextStyle(
          color: Colors.white
        ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading) const LinearProgressIndicator(),
          SearchBar(
            hintText: "Search for a city",
            leading: Icon(Icons.search),
            onChanged: (value){
              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                searchLocation(value);
              });
            },
          ),
          SizedBox(height: 30.0),
          Expanded(child:  ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index){
                Map city= results[index];
                String code= (city["country_code"] ?? "").toLowerCase();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                  child: Card(
                    child: ListTile(
                      onTap: (){updateTime(city);},
                      title: Text(city["name"] ?? ''),
                      subtitle: Text(city["country"] ?? ''),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage("https://flagcdn.com/w80/$code.png"),
                      ),
                    )
                  )
                );
              }
            )
          ),]
      ),
    );
  }
}