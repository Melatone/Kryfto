import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kryfto/Model/User.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'game_page.dart';

class registerpage extends StatefulWidget {
  const registerpage({super.key, required this.socket});
  final IO.Socket socket;
  @override
  State<registerpage> createState() => _registerpageState();
}

class _registerpageState extends State<registerpage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final conpassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool userExists = false;

  @override
  void initState() {
    // TODO: implement initState

    widget.socket.on('register', (data) {
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
        if (data['Status'] == 'user_exists') {
          userExists = true;
        }
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
              width: 175,
              height: 175,
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
                validator: (value) {
                  if (userExists) {
                    return 'User already exists';
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
                validator: (value) {
                  if (value != passController.value.text) {
                    return 'Passwords do not match';
                  } else
                    return null;
                },
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
                widget.socket.emit(
                    'register',
                    json.encode({
                      'Username': userController.text,
                      'Password': passController.text
                    }));

                if (_formKey.currentState!.validate()) {}
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
    ));
  }
}
