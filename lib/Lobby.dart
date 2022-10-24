import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kryfto/Model/RoomInfo.dart';
import 'package:kryfto/Model/User.dart';
import 'package:kryfto/Model/player.dart';
import 'package:kryfto/map_page.dart';
import 'package:location/location.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'Compass.dart';
import 'countdown.dart';

class Lobby extends StatefulWidget {
  final User user;
  final IO.Socket socket;
  final String roomcode;
  final List<LatLng> points;
  List<PlayerModel> playersItems;
  final PlayerModel player;
  final int timeLimit;
  final int hideLimit;
  
  Lobby({
    Key? key,
    required this.user,
    required this.socket,
    required this.playersItems,
    required this.roomcode,
    required this.points,
    required this.player,
    required this.timeLimit,
    required this.hideLimit,
  }) : super(key: key);
  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {

bool countDone = false;

  @override
  void initState() {
    super.initState();

    widget.socket.on("new join", (msg) {
      if (msg['Status'] == 'Success') {
        this.setState(() {
          widget.playersItems.add(PlayerModel(
            msg['Username'],
            msg['Role'],
          ));
        });
      }
    });

    widget.socket.on("change role", (msg) {
      final result = json.decode(msg);
      this.setState(() {
        widget.playersItems.forEach(
          (element) {
            if (element.Username == result['Username']) {
              print(element.Username);
              print(result['Username']);
              print(result['Role']);
              element.Seeker = result['Role'];
              if(widget.user.username == result['Username']){
                 widget.player.Seeker = result['Role'];
              }
             
            }
          },
        );
      });
    });

    widget.socket.on("start game", (msg) {
      final Map<String, dynamic> result = jsonDecode(jsonEncode(msg));
      print(result['status']);
      this.setState(() {
        if (msg['status'] == "Success") {
          print(widget.player.Seeker);
          if(widget.player.Seeker == true){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                Rose(points: widget.points,
                    socket: widget.socket,
                    user: widget.user,
                    roomInfo: RoomInfo(widget.points, widget.roomcode,
                        widget.hideLimit, widget.timeLimit,
                        ),playersItems: widget.playersItems,
                        timeLimit: widget.timeLimit,
                  )
        ));
          }
          else{
           showOverlay(context);
          }
        }
      });
    });

    super.initState();
  }

  showOverlay(BuildContext context) async {
    int count=widget.hideLimit;
   



    
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Center(child: Count(start: count));
    });
    overlayState?.insert(overlayEntry);
    
    await Future.delayed(Duration(seconds: count));
  setState(() {
        overlayEntry.remove();

         Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                 MapPage(points: widget.points,
                    socket: widget.socket,
                    user: widget.user,
                    roomInfo: RoomInfo(widget.points, widget.roomcode,
                        widget.hideLimit, widget.timeLimit,
                        ), playersItems: widget.playersItems,
                        timeLimit: widget.timeLimit, 
                  ),
          ));
  });
  

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text(widget.roomcode,
              style: GoogleFonts.righteous(
                  textStyle: TextStyle(
                      fontSize: 40, color: Theme.of(context).primaryColor)))),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: Column(
        children: <Widget>[
          Spacer(),
          Text(
            'Players',
            style: GoogleFonts.righteous(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          Spacer(flex: 1),
          Container(
              alignment: Alignment.center,
              width: 350,
              height: 400,
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
          Spacer(),
          Text(
            'Choose Your Role',
            style: GoogleFonts.righteous(
              fontSize: 30,
              color: Theme.of(context).backgroundColor,
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  widget.socket.emit(
                      "change role",
                      json.encode({
                        'Code': widget.roomcode,
                        'Username': widget.user.username,
                        'Role': false,
                      }));
                },
                style: ElevatedButton.styleFrom(
                    maximumSize: Size(200, 100),
                    minimumSize: Size(120, 50),
               
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                child: Text(
                  'Hider',
                  style: GoogleFonts.righteous(
                    fontSize: 30,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  widget.socket.emit(
                      "change role",
                      json.encode({
                        'Code': widget.roomcode,
                        'Username': widget.user.username,
                        'Role': true,
                      }));
                },
                style: ElevatedButton.styleFrom(
                    maximumSize: Size(200, 100),
                    minimumSize: Size(120, 50),
            
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                child: Text(
                  'Seeker',
                  style: GoogleFonts.righteous(
                    fontSize: 30,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              widget.socket
                  .emit("start game", jsonEncode({'Code': widget.roomcode}));
                
            },
            style: ElevatedButton.styleFrom(
                maximumSize: Size(200, 100),
                minimumSize: Size(120, 60),
         
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25))),
            child: Text(
              'Start Game',
              style: GoogleFonts.righteous(
                fontSize: 30,
                color: Theme.of(context).backgroundColor,
              ),
            ),
          ),
          Spacer(flex: 5),
        ],
      )),
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
        padding: EdgeInsets.only(top: height * 0.005, bottom: height * 0.005),
        child: Container(
            width: width,
            height: height * 0.07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29.0),
              color: Theme.of(context).backgroundColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Text(
                  Username,
                  style: GoogleFonts.righteous(
                    fontSize: 20,
                    color: Username == user.username
                        ? Theme.of(context).primaryColor
                        : Color.fromARGB(255, 0, 0, 0),
                  ),
                  textAlign: TextAlign.left,
                ),
                Spacer(flex: 4),
                Text(
                  seeker ? "Seeker" : "Hider",
                  style: GoogleFonts.righteous(
                    fontSize: height * 0.03,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  textAlign: TextAlign.right,
                ),
                Spacer(),
              ],
            )));
  }
}
