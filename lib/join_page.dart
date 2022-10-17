import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kryfto/Lobby.dart';
import 'package:kryfto/Model/RoomInfo.dart';
import 'package:kryfto/login_page.dart';
import 'package:kryfto/map_page.dart';
import 'Model/User.dart';
import 'Model/player.dart';
import 'game_page.dart';
import 'map_select_page.dart';
import 'home_page.dart';
import 'theme.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class JoinPage extends StatelessWidget {
  const JoinPage({Key? key, required this.socket, required this.user})
      : super(key: key);
  final IO.Socket socket;
  final User user;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Join(
          title: 'join lobby',
          socket: socket,
          user: user,
        ),
      ),
      debugShowCheckedModeBanner: false,
      theme: theme(),
    );
  }
}

class Join extends StatefulWidget {
  const Join(
      {Key? key, required this.title, required this.socket, required this.user})
      : super(key: key);
  final String title;
  final IO.Socket socket;
  final User user;
  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  final roomController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    List<PlayerModel> playersItems = [];
    widget.socket.on("join room", (msg) {
      Map<String, dynamic> map = json.decode(json.encode(msg));
      List<dynamic> data = map["Boundary"];
      List<LatLng> lat_lng = data.map((e) => LatLng(e[0], e[1])).toList();
      print(lat_lng);
      print(lat_lng[0]);
      if (msg['Status'] == 'Success') {
        msg['Players'].forEach((element) {
          print(element['Role'].runtimeType);
          this.setState(() {
            playersItems.add(PlayerModel(element['Username'], element['Role']));
          });
        });

        this.setState(() {
          playersItems.add(PlayerModel(widget.user.username, false));
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Lobby(
                    user: widget.user,
                    socket: widget.socket,
                    playersItems: playersItems,
                    roomcode: roomController.text.toUpperCase(),
                    points: lat_lng,
                    player: PlayerModel(widget.user.username, false),
                    timeLimit: msg['TimeLimit'],
                    hideLimit: msg['HideLimit'],
                  )));
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamePage(
                        socket: widget.socket,
                        user: widget.user,
                      ),
                    ));
              }),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Text("Join Lobby",
              style: GoogleFonts.righteous(
                  textStyle: TextStyle(
                      fontSize: 35,
                      color: Theme.of(context).dialogBackgroundColor)))),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
          child: Column(
        children: <Widget>[
          Spacer(flex: 2),
          Container(
              child: TextFormField(
                controller: roomController,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Room Code',
                ),
              ),
              width: 300),
          Spacer(flex: 3),
          ElevatedButton(
            child: Icon(Icons.arrow_forward_ios),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              minimumSize: const Size(130, 60),
              maximumSize: const Size(130, 60),
              primary: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              widget.socket.emit(
                  'join room',
                  json.encode({
                    'Username': widget.user.username,
                    'Code': roomController.text.toUpperCase(),
                    'Role': false,
                  }));
            },
          ),
          Spacer(),
        ],
      )),
    );
  }
}
