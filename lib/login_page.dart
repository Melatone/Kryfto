import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kryfto/game_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;



class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  late IO.Socket socket;
  bool checkLogin = false;


  @override
  void initState() {
    // TODO: implement initState
    socket = IO.io(
        "https://kryfto.herokuapp.com/",
        IO.OptionBuilder()
            .setTransports(["websocket"])
            .disableAutoConnect()
            .build());

    socket.on('login', (data){
      print(data);
      if(data['Status'] == "Success"){
        this.setState(() {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const GamePage())));
        });

      }
      
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
                
                autocorrect: false,
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
                autocorrect: false,
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

                socket.emit(
                  'login',
                  json.encode({
                    'Username': userController.text,
                    'Password' : passController.text
                  }));
                
              },
              child: const Text(
                "Login",
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
