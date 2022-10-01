import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kryfto/Model/User.dart';
import 'package:kryfto/Model/player.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Lobby extends StatefulWidget {
  final User user;
  final IO.Socket socket;
  final String roomcode;
  List<PlayerModel> playersItems;
  Lobby(
      {Key? key,
      required this.user,
      required this.socket,
      required this.playersItems,
      required this.roomcode})
      : super(key: key);
  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
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
              element.Seeker = result['Role'];
            }
          },
        );
      });
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
                        fontSize: height * 0.075,
                        color: const Color(0xFFFF0000),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.02),
                      child: Text(
                        'Room code: ' + widget.roomcode,
                        style: GoogleFonts.righteous(
                          fontSize: height * 0.025,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * 0.01, bottom: height * 0.01),
                      child: Text(
                        'Players',
                        style: GoogleFonts.righteous(
                          fontSize: height * 0.06,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment(-1.0, -0.91),
                        width: width * 0.96,
                        height: height * 0.5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD5D0D0),
                          border: Border.all(
                            width: 1.0,
                            color: const Color(0xFF707070),
                          ),
                        ),
                        child: ListView.builder(
                            itemCount: widget.playersItems.length,
                            itemBuilder: (context, index) {
                              var currentPlayer = widget.playersItems[index];
                              return Players(
                                Username: currentPlayer.Username,
                                seeker: currentPlayer.Seeker,
                              );
                            })),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.03),
                      child: Text(
                        'Choose Your Role',
                        style: GoogleFonts.righteous(
                          fontSize: height * 0.05,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.9,
                      height: height * 0.1,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: width * 0.07, right: width * 0.05),
                            child: InkWell(
                                onTap: () {
                                  widget.socket.emit(
                                      "change role",
                                      json.encode({
                                        'Code': widget.roomcode,
                                        'Username': widget.user.username,
                                        'Role': false,
                                      }));
                                },
                                child: Container(
                                  alignment: Alignment(0.01, 0.06),
                                  width: width * 0.35,
                                  height: height * 0.07,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28.0),
                                    color: const Color(0xFF242222),
                                    border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xFF707070),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFFEEEE)
                                            .withOpacity(0.16),
                                        offset: Offset(0, 6.0),
                                        blurRadius: 12.0,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Hider',
                                    style: GoogleFonts.righteous(
                                      fontSize: height * 0.04,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: width * 0.0),
                            child: InkWell(
                              onTap: () {
                                widget.socket.emit(
                                    "change role",
                                    json.encode({
                                      'Code': widget.roomcode,
                                      'Username': widget.user.username,
                                      'Role': true,
                                    }));
                              },
                              child: Container(
                                alignment: Alignment(0.02, 0.06),
                                width: width * 0.35,
                                height: height * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28.0),
                                  color: const Color(0xFF242222),
                                  border: Border.all(
                                    width: 1.0,
                                    color: const Color(0xFF707070),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFFEEEE)
                                          .withOpacity(0.16),
                                      offset: Offset(0, 6.0),
                                      blurRadius: 12.0,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Seeker',
                                  style: GoogleFonts.righteous(
                                    fontSize: height * 0.04,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
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

class Players extends StatelessWidget {
  const Players({Key? key, required this.Username, required this.seeker})
      : super(key: key);
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
              color: Colors.white,
              border: Border.all(
                width: 1.0,
                color: const Color(0xFF707070),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.05,
                      top: height * 0.015,
                      bottom: height * 0.015),
                  child: Text(
                    Username,
                    style: GoogleFonts.righteous(
                      fontSize: height * 0.03,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.7,
                      top: height * 0.015,
                      bottom: height * 0.015),
                  child: Text(
                    seeker ? "Seeker" : "Hidder",
                    style: GoogleFonts.righteous(
                      fontSize: height * 0.03,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            )));
  }
}
