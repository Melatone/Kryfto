import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'Lobby.dart';
import 'Model/User.dart';
import 'Model/player.dart';

class createpage extends StatefulWidget {
  const createpage({Key? key, required this.socket, required this.user})
      : super(key: key);
  final IO.Socket socket;
  final User user;
  @override
  State<createpage> createState() => _createpageState();
}

class _createpageState extends State<createpage> {
  @override
  void initState() {
    // TODO: implement initState

    widget.socket.on('create room', (data) {
      print(data);
      if (data['Status'] == "Success") {
        this.setState(() {
          widget.user.roomcode = data['Code'];
          print(data['Code']);
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Lobby(
                    user: widget.user,
                    socket: widget.socket,
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
      backgroundColor: const Color(0xFFD20000),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: height * -0.1,
              child: Container(
                height: height * 0.2,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(33.0),
                  color: const Color(0xFFD5D0D0),
                ),
              ),
            ),
            SizedBox(
                width: width,
                height: height,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Kryfto',
                      style: GoogleFonts.righteous(
                        fontSize: 60.0,
                        color: const Color(0xFFFF0000),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * 0.01, bottom: height * 0.01),
                    ),
                    Container(
                      width: width * 0.96,
                      height: height * 0.05,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD5D0D0),
                        borderRadius: BorderRadius.circular(33.0),
                      ),
                      padding: EdgeInsets.only(
                          top: height * 0.01, bottom: height * 0.01),
                      child: Center(
                        child: Text(
                          'Create Room',
                          style: GoogleFonts.righteous(
                            fontSize: 20.0,
                            color: const Color(0xFFFF0000),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * 0.01, bottom: height * 0.01),
                    ),
                    Container(
                      alignment: const Alignment(-1.0, -0.91),
                      width: width * 0.96,
                      height: height * 0.8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD5D0D0),
                        borderRadius: BorderRadius.circular(33.0),
                      ),
                      child: Screen(
                        socket: widget.socket,
                        user: widget.user,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class Screen extends StatelessWidget {
  const Screen({Key? key, required this.socket, required this.user})
      : super(key: key);
  final IO.Socket socket;
  final User user;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.only(top: height * 0.01, bottom: height * 0.01),
          ),
          Text(
            'Gamerules',
            style: GoogleFonts.righteous(
              fontSize: 40.0,
              color: const Color(0xFFFF0000),
            ),
          ),
          Text(
            'Time Limit',
            style: GoogleFonts.righteous(
              fontSize: 30.0,
              color: const Color(0xFFFF0000),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 80,
              child: Center(
                child: ListWheelScrollView.useDelegate(
                  onSelectedItemChanged: (value) => print(value),
                  itemExtent: 70,
                  perspective: 0.01,
                  diameterRatio: 0.4,
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
            ),
          ),
          Text(
            'Minutes',
            style: GoogleFonts.righteous(
              fontSize: 20.0,
              color: const Color(0xFFFF0000),
            ),
          ),
          Text(
            'Number of Hiders',
            style: GoogleFonts.righteous(
              fontSize: 30.0,
              color: const Color(0xFFFF0000),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 80,
              child: Center(
                child: ListWheelScrollView.useDelegate(
                  onSelectedItemChanged: (value) => print(value),
                  itemExtent: 70,
                  perspective: 0.01,
                  diameterRatio: 0.4,
                  physics: const FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 21,
                    builder: (context, index) {
                      return Numhiders(
                        numhiders: index,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Text(
            'Number of Seekers',
            style: GoogleFonts.righteous(
              fontSize: 30.0,
              color: const Color(0xFFFF0000),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 80,
              child: Center(
                child: ListWheelScrollView.useDelegate(
                  onSelectedItemChanged: (value) => print(value),
                  itemExtent: 70,
                  perspective: 0.009,
                  diameterRatio: 0.4,
                  physics: const FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 21,
                    builder: (context, index) {
                      return Numseekers(
                        numseekers: index,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
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
                    }));
              }
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.01),
          ),
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
              fontSize: 40.0,
              color: const Color(0xFFFF0000),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class Numhiders extends StatelessWidget {
  int numhiders;
  Numhiders({required this.numhiders});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            numhiders.toString(),
            style: GoogleFonts.righteous(
              fontSize: 40.0,
              color: const Color(0xFFFF0000),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class Numseekers extends StatelessWidget {
  int numseekers;
  Numseekers({required this.numseekers});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            numseekers.toString(),
            style: GoogleFonts.righteous(
              fontSize: 40.0,
              color: const Color(0xFFFF0000),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
