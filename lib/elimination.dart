import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kryfto/Compass.dart';
import 'package:kryfto/countdown.dart';
import 'package:kryfto/game_page.dart';
import 'package:kryfto/login_page.dart';
import 'package:kryfto/map_page.dart';
import 'package:kryfto/registerpage.dart';
import 'Model/User.dart';
import 'Model/player.dart';
import 'map_select_page.dart';
import 'home_page.dart';
import 'theme.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;



class Elimination extends StatefulWidget {
  Elimination({Key? key, }): super(key: key);


  
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<Elimination> createState() => _EliminationState();
}

class _EliminationState extends State<Elimination> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Center(child:Column(children: <Widget>[
        Spacer(),
        Text("Eliminated",
            style: GoogleFonts.righteous(
                textStyle: TextStyle(
                    fontSize: 55, color: Theme.of(context).backgroundColor))),
                    Image.asset("images/runawayyy.png", width: 300, height: 300),
                    Text("You have been caught..",
            style: GoogleFonts.righteous(
                textStyle: TextStyle(
                    fontSize: 25, color: Theme.of(context).backgroundColor))),
                    
                    Text("Continue Playing?",
            style: GoogleFonts.righteous(
                textStyle: TextStyle(
                    fontSize: 20, color: Theme.of(context).backgroundColor))),
                    
               
            
       
     
            Spacer(),
            Row(children: <Widget>[
              Spacer(),
            ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            minimumSize: const Size(150, 80),
            maximumSize: const Size(200, 80),
            primary: Theme.of(context).primaryColorLight,
          ),
          child: Text(
            "Seek",
            style: GoogleFonts.righteous(
                textStyle:
                    TextStyle(fontSize: 35, )),
          ),
          onPressed: () {
            Navigator.pop(context);
            
                
                   
          },
        ),
        Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            minimumSize: const Size(150, 80),
            maximumSize: const Size(200, 80),
            primary: Theme.of(context).primaryColorLight,
          ),
          child: Text(
            "Leave",
            style: GoogleFonts.righteous(
                textStyle:
                    TextStyle(fontSize: 35)),
          ),
          onPressed: () {
            Navigator.pop(context);
            
                
                   
          },
        ),
        Spacer(),
            ]),
        Spacer(),
      ],),
      )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
