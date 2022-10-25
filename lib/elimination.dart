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
import 'Model/RoomInfo.dart';
import 'Model/User.dart';
import 'Model/player.dart';
import 'map_select_page.dart';
import 'home_page.dart';
import 'theme.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;



class Elimination extends StatefulWidget {


  
 final List<LatLng> points;

  final IO.Socket socket;
  final User user;
  final RoomInfo roomInfo;
  List<PlayerModel> playersItems; 
  final int timeLimit;
  Elimination({Key? key, required this.points, required this.socket, required this.user, required this.roomInfo, required this.playersItems, required this.timeLimit}) : super(key: key);

  @override
  State<Elimination> createState() => _EliminationState();
}

class _EliminationState extends State<Elimination> {


@override
void initState(){
 super.initState();
   widget.socket.on("swap role", (msg) {
      final result = json.decode(msg);
      print(result);
      
        widget.playersItems.forEach(
          (element) {
            print(element.Username);
            if (element.Username == result['Username']) {
              setState(() {
              print(element.Username);
              print(result['Username']);
              print(result['Role']);
              element.Seeker = result['Role'];
              
             
            });
          }
          }
        );
        Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                Rose(points: widget.points,
                    socket: widget.socket,
                    user: widget.user,
                    roomInfo: RoomInfo(widget.points, widget.roomInfo.roomCode,
                        widget.roomInfo.hideTime, widget.timeLimit,
                        ),playersItems: widget.playersItems,
                        timeLimit: widget.timeLimit,
                  ),
        ));
      
    });

 
}
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
            widget.socket.emit(
                      "swap role",
                      json.encode({
                        'Code': widget.roomInfo.roomCode,
                        'Username': widget.user.username,
                        'Role': true,
                      }));
            
            
                
                   
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GamePage(socket: widget.socket, user: widget.user)));
                
                   
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
