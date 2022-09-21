import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
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
                controller: passController,
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
              onPressed: () {},
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
