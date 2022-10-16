import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kryfto/map_select_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'Lobby.dart';
import 'Model/User.dart';
import 'Model/player.dart';
import 'end_screen.dart';

class createpage extends StatefulWidget {
  createpage(
      {Key? key,
      required this.socket,
      required this.user,
      required this.lat_lng})
      : super(key: key);
  final IO.Socket socket;
  final User user;
  List<LatLng> lat_lng;
  @override
  State<createpage> createState() => _createpageState();
}

class _createpageState extends State<createpage> {
  List<PlayerModel> playersItems = [];

  @override
  void initState() {
    // TODO: implement initState

    widget.socket.on('create room', (data) {
      print(data);
      if (data['Status'] == "Success") {
        this.setState(() {
          playersItems.add(PlayerModel(widget.user.username, false));
          widget.user.roomcode = data['Code'];
          print(widget.lat_lng[0]);
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => End(
                    user: widget.user,
                    socket: widget.socket,
                    playersItems: playersItems,
                    roomcode: data['Code'],
                    player: PlayerModel(widget.user.username,false),
                    points: widget.lat_lng,
                  )));
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text("Create Room",
              style: GoogleFonts.righteous(
                  textStyle: TextStyle(
                      fontSize: 40, color: Theme.of(context).primaryColor)))),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Spacer(),
                Text(
                  'Gamerules',
                  style: GoogleFonts.righteous(
                    fontSize: 40.0,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
                Spacer(),
                Container(
                  alignment: Alignment.center,
                  width: 350,
                  height: 600,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(33.0),
                  ),
                  child: Screen(
                    socket: widget.socket,
                    user: widget.user,
                    lat_lng: widget.lat_lng,
                  ),
                ),
                Spacer(flex: 3),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Screen extends StatelessWidget {
  Screen(
      {Key? key,
      required this.socket,
      required this.user,
      required this.lat_lng})
      : super(key: key);
  final IO.Socket socket;
  final User user;
  List<LatLng> lat_lng;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Spacer(flex: 1),
          Text(
            'Time Limit',
            style: GoogleFonts.righteous(
              fontSize: 30.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Container(
            height: 70,
            child: ListWheelScrollView.useDelegate(
              onSelectedItemChanged: (value) => print(value),
              itemExtent: 80,
              perspective: 0.001,
              diameterRatio: 0.2,
              physics: const FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 151,
                builder: (context, index) {
                  return MyMinutes(
                    mins: index,
                  );
                },
              ),
            ),
          ),
          Text(
            'Minutes',
            style: GoogleFonts.righteous(
              fontSize: 20.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Spacer(),
          Text(
            'Hide Time',
            style: GoogleFonts.righteous(
              fontSize: 30.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Container(
            height: 70,
            child: ListWheelScrollView.useDelegate(
              onSelectedItemChanged: (value) => print(value),
              itemExtent: 80,
              perspective: 0.001,
              diameterRatio: 0.2,
              physics: const FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 151,
                builder: (context, index) {
                  return Mytimer(
                    timer: index,
                  );
                },
              ),
            ),
          ),
          Text(
            'Minutes',
            style: GoogleFonts.righteous(
              fontSize: 20.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              minimumSize: const Size(200, 60),
              maximumSize: const Size(200, 60),
              primary: Theme.of(context).primaryColor,
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            onPressed: () {
              {
                socket.emit(
                    'create room',
                    json.encode({
                      'Username': user.username,
                      'Boundary': lat_lng,
                    }));
              }
            },
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class MyMinutes extends StatelessWidget {
  int mins;
  MyMinutes({required this.mins});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            mins.toString(),
            style: GoogleFonts.righteous(
              fontSize: 50.0,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class Mytimer extends StatelessWidget {
  int timer;
  Mytimer({required this.timer});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            timer.toString(),
            style: GoogleFonts.righteous(
              fontSize: 50.0,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
