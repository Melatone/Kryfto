import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class registerpage extends StatefulWidget {
  const registerpage({super.key});

  @override
  State<registerpage> createState() => _registerpageState();
}
class _registerpageState extends State<registerpage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final conpassController = TextEditingController();
  late IO.Socket socket;

  @override
  void initState() {
    // TODO: implement initState
    socket = IO.io(
        "https://kryfto.herokuapp.com/",
        IO.OptionBuilder()
            .setTransports(["websocket"])
            .disableAutoConnect()
            .build());

    socket.on('register', (data){
      print(data);
    });

    super.initState();
    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: SingleChildScrollView(
          child: Column(children: [
            Text("Kryfto",
                style: GoogleFonts.righteous(
                    textStyle: TextStyle(
                        fontSize: 80, color: Theme.of(context).primaryColor))),
            Image.asset(
              "images/runawayy.png",
              width: 200, height: 200,
            ),
            Text("Username"),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: userController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your username',
                ),
              ),
            ),
            Text("Password"),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                obscureText: true,
                controller: passController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your Password',
                ),
              ),
            ),
            Text("Confirm Password"),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                obscureText: true,
                controller: conpassController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your Password',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                minimumSize: const Size(130, 50),
                maximumSize: const Size(130, 50),
                primary: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                if(passController.text == conpassController.text){socket.emit(
                  'register',
                  json.encode({
                    'Username': userController.text,
                    'Password' : passController.text
                  }));
                  }
                  else{
                    Fluttertoast.showToast(
                      msg: 'Password and Confirm password not same',
                      gravity: ToastGravity.CENTER);
                  }


              },

              child: const Text(
                "Register",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}