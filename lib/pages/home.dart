import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data={};

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty
        ? data
        : (ModalRoute.of(context)?.settings.arguments as Map? ?? {});

    bool isDay = data["isDaytime"] ?? true;
    String bgImage = isDay ? "day.png.jpg" : "night.png.jpg";
    Color bgColor = isDay ? Colors.blue : Colors.indigo[700]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/$bgImage"),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
            child: Column(
                children: [
                  SizedBox(height: 120.0),
                  TextButton.icon(
                    onPressed: ()async{
                     dynamic result= await Navigator.pushNamed(context, "/location");
                     if (result == null)
                       return;
                     setState(() {
                       data = {
                         "time": result["time"]??"",
                         "location": result["location"]??"",
                         "isDaytime": result["isDaytime"]??"",
                         "flag": result["flag"]??""
                       };
                     });
                      },

                    label: Text("Edit location",
                              style: TextStyle(
                                       color: Colors.grey[200],),),
                    icon: Icon(Icons.location_on_outlined,
                      color: Colors.grey[200],),

                     ),
                     SizedBox(height: 20.0),
                     Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text(data["location"],
                             style: TextStyle(
                               fontSize: 32.0,
                               letterSpacing: 2.0,
                               color: Colors.white
                             ),
                           ),

                         ]
                     ),

                     Text(data["time"],
                       style: TextStyle(
                         fontSize: 66.0,
                         letterSpacing: 2.0,
                         color: Colors.white
                       ),
                     )
                   ]
               )


           )
      )

    );
  }
}
