import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kryfto/login_page.dart';
import 'package:kryfto/map_page.dart';
import 'game_page.dart';
import 'map_select_page.dart';
import 'home_page.dart';
import 'theme.dart';
import 'dart:async';





class Count extends StatefulWidget {
  const Count({Key? key, required this.start}) : super(key: key);
  
  final int start;
  


  int getStart(){
    return start;
  }

  @override
  State<Count> createState() => _CountState(start);
}

class _CountState extends State<Count> {
  
 late  Timer _timer;
 
  int start; 
  _CountState(this.start);

  void startTimer(){
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec
      , (Timer timer) {
        if(start ==0){
          setState(() {
            timer.cancel();
            Navigator.pop(context);
          });
        }
        else{
          setState(() {
            start--;
          });
        }
       });
  }
  
  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }
  @override
  void initState(){
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
      
    
      centerTitle: true,
     elevation: 0,
      backgroundColor: Theme.of(context).primaryColorLight,
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Center(child: Column(children: <Widget> [
        Spacer(),
        Text("Game begins in..",
        style:
     GoogleFonts.righteous(
    textStyle: TextStyle(
    fontSize: 35, 
    color: Theme.of(context).dialogBackgroundColor))
        ),
        Text("$start",
        style:
     GoogleFonts.righteous(
    textStyle: TextStyle(
    fontSize: 100, 
    color: Theme.of(context).dialogBackgroundColor))
        ),
        Spacer(flex:2),
      ],))
      ,
    
 
    );
  }
}


