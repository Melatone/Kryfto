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



class End extends StatefulWidget {
 
final User user;
  final IO.Socket socket;
  final String roomcode;
  final List<LatLng> points;
  List<PlayerModel> playersItems;
  final PlayerModel player;

  End(
      {Key? key,
      required this.user,
      required this.socket,
      required this.playersItems,
      required this.roomcode, 
      required this.points,
      required this.player})
      : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<End> createState() => _EndState();
}

class _EndState extends State<End> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(child:Column(children: <Widget>[
        Spacer(flex:2),
        Text("Game Over",
            style: GoogleFonts.righteous(
                textStyle: TextStyle(
                    fontSize: 55, color: Theme.of(context).backgroundColor))),
                    Text("Hiders Win!",
            style: GoogleFonts.righteous(
                textStyle: TextStyle(
                    fontSize: 25, color: Theme.of(context).backgroundColor))),
                    Spacer(),
                    Text("Hiders Left:",
            style: GoogleFonts.righteous(
                textStyle: TextStyle(
                    fontSize: 30, color: Theme.of(context).backgroundColor))),
                    
               
            
       
     Container(
                    alignment: Alignment.center,
                        width: 360,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListView.builder(
                            itemCount: widget.playersItems.length,
                            itemBuilder: (context, index) {
                              var currentPlayer = widget.playersItems[index];
                              return Players(
                                Username: currentPlayer.Username,
                                seeker: currentPlayer.Seeker,
                                user: widget.user,
                              );
                            })),
            Spacer(flex:2),
            ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            minimumSize: const Size(250, 80),
            maximumSize: const Size(250, 80),
            primary: Theme.of(context).primaryColorDark,
          ),
          child: Text(
            "Home",
            style: GoogleFonts.righteous(
                textStyle:
                    TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GamePage(socket: widget.socket, user: widget.user)));
                   
          },
        ),
        Spacer(),
      ],),
      )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
class Players extends StatelessWidget {
  const Players(
      {Key? key,
      required this.Username,
      required this.seeker,
      required this.user})
      : super(key: key);
  final User user;
  final bool seeker;
  final String Username;
  @override
  Widget build(BuildContext context) {
  
  
        
   return  Container(
            width: 350,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Theme.of(context).backgroundColor,
             
            ),
            child: Row(
        
           
              children: <Widget>[
                Spacer(),
                 Text(
                    Username,
                    style: GoogleFonts.righteous(
                      fontSize: 20,
                      color:  Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.left,
                  ),
                Spacer(flex:4),
              
                  Text(
                    seeker ? "Seeker" : "Hider",
                    style: GoogleFonts.righteous(
                    fontSize: 20,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.right,
                  ),
                Spacer(),
              ],
            ));
  }
}