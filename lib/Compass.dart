import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kryfto/login_page.dart';
import 'package:kryfto/map_page.dart';
import 'game_page.dart';
import 'map_select_page.dart';
import 'home_page.dart';
import 'theme.dart';
import 'package:flutter_compass/flutter_compass.dart';



class Compass extends StatelessWidget {
  const Compass({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      body: Rose(title: 'join lobby',),),
      debugShowCheckedModeBanner: false,
      theme: theme(),
      
   
     
    );
  }
}

class Rose extends StatefulWidget {
  const Rose({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<Rose> createState() => _RoseState();
}

class _RoseState extends State<Rose> {
  

  double? heading;

  final roomController = TextEditingController();
  Duration time = Duration(minutes: 30);
late Timer timer;

@override
void initState(){
  FlutterCompass.events!.listen((event) {
    setState(() {
      heading = event.heading;
    });
    
  });
  startTimer();
  super.initState();
}

  void startTimer(){
    timer = new Timer.periodic(Duration(seconds: 1), (_) => countDown());
   
   
  }
  void countDown(){
    final second = 1;
    setState(() {

      final seconds = time.inSeconds - second;
      time = Duration(seconds: seconds);
    });
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
     
      appBar: AppBar(
      
    
      centerTitle: true,
      backgroundColor: Color(0xbbf2f2f2),
      title: Text(time.toString().substring(0,time.toString().length-7),
      style:
     GoogleFonts.righteous(
    textStyle: TextStyle(
    fontSize: 35, 
    color: Theme.of(context).primaryColorLight)))),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(child: Column(children: <Widget> [
        Spacer(flex: 2),
        Stack(
          alignment: Alignment.center,
          children:<Widget>[ Image.asset("images/Cross.png", width: 350,height: 350),
       
        Transform.rotate(angle: ((heading ?? 0) * (pi / 180) * -1),
        child:  Image.asset("images/Arrow.png", width: 100,height: 100)),
        ]
                
        ),
        Spacer(flex: 3),
      
       
      ],))
      ,
       
    );
  }
}

