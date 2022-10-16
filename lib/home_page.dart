import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'login_page.dart';
import 'registerpage.dart';
import 'theme.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatelessWidget {
  const HomePage({super.key, required socket});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      theme: theme(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class Login extends StatefulWidget{
//   showOverlay(BuildContext context){
// OverlayState overlayState = Overlay.of(context);
// OverlayEntry overlayEntry = OverlayEntry(builder: ((context) =>
// LoginPage()
// ))
// overlayEntry.insert(overlayEntry);
//   }
// }

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

    super.initState();
    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(child: Column(
      
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Spacer(),
        Text("Kryfto",
            style: GoogleFonts.righteous(
                textStyle: TextStyle(
                    fontSize: 80, color: Theme.of(context).primaryColor))),
        Image.asset("images/runawayy.png", width: 200, height: 200),
        Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            minimumSize: const Size(250, 80),
            maximumSize: const Size(250, 80),
            primary: Theme.of(context).primaryColor,
          ),
          child: Text(
            "Login",
            style: GoogleFonts.ubuntu(
                textStyle:
                    TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          ),
          onPressed: () {
            
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => loginpage(socket: socket)));
          },
        ),
        const Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            minimumSize: const Size(250, 80),
            maximumSize: const Size(250, 80),
            primary: Theme.of(context).primaryColorLight,
          ),
          child: Text(
            "Register",
            style: GoogleFonts.ubuntu(
                textStyle:
                    TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => registerpage(
                          socket: socket,
                        )));
          },
        ),
        Spacer(),
      ],
    ),
      ),
    );
  }
}
