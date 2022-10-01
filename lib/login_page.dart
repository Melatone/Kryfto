import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kryfto/Model/User.dart';
import 'package:kryfto/game_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class loginpage extends StatefulWidget {
  const loginpage({super.key, required this.socket});
  final IO.Socket socket;

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool checkLogin = false;
  bool wrongPass = false;
  bool wrongUser = false;

  @override
  void initState() {
    // TODO: implement initState

    widget.socket.on('login', (data) {
      print(data);
      if (data['Status'] == "Success") {
        this.setState(() {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => GamePage(
                    socket: widget.socket,
                    user: User(
                        username: userController.text,
                        password: passController.text,
                        roomcode: null),
                  ))));
        });
      }
      if (data['Status'] == "Wrong password") {
        wrongPass = true;
        print(wrongPass);
      }
      if (data['Status'] == "Username Incorrect") {
        wrongUser = true;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: SingleChildScrollView(
          child: Column(children: [
            Text("Kryfto",
                style: GoogleFonts.righteous(
                    textStyle: TextStyle(
                        fontSize: 80, color: Theme.of(context).primaryColor))),
            Image.asset(
              "images/runawayy.png",
              width: 200,
              height: 200,
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
                validator: (value) {
                  if (wrongUser) {
                    return "Incorrect Username";
                  } else {
                    return null;
                  }
                },
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
                  validator: (value) {
                    if (wrongPass) {
                      return "Incorrect Password";
                    } else {
                      return null;
                    }
                  }),
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
                if (_formKey.currentState!.validate()) {}
                widget.socket.emit(
                    'login',
                    json.encode({
                      'Username': userController.text,
                      'Password': passController.text
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
    ));
  }
}
