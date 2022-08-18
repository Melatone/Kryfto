import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kryfto/home_page.dart';
import 'package:kryfto/map_page.dart';

import 'theme.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      body: const Game(),),
      debugShowCheckedModeBanner: false,
      theme: theme(),
    
    );
  }
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Center(
   
        child: Column(

     
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Spacer(),
            Text("Kryfto",style: GoogleFonts.righteous(textStyle: TextStyle(fontSize: 80, color: Theme.of(context).primaryColor) )),
           
                Image.asset("images/runawayy.png", width: 200,height: 200),
                Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  ),
minimumSize: const Size(250,80),
maximumSize: const Size(250,80),
primary: Theme.of(context).primaryColor,
                ),
                
              
              child: const Text("Join" ,style: TextStyle(
                fontSize: 40,
              ),), 
              onPressed: () {  
               Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen()));
              },),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  ),
minimumSize: const Size(250,80),
maximumSize: const Size(250,80),
primary: Theme.of(context).primaryColorLight,
                ),
                
              
              child: const Text("Create" ,style: TextStyle(
                fontSize: 40,
              ),), 
              onPressed: () { 
                
               },),
              
            
         Spacer(),
          ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  ),
minimumSize: const Size(140,70),
maximumSize: const Size(140,70),
primary: Theme.of(context).primaryColorDark,
                ),
                
              
              child: const Text("Log Out" ,style: TextStyle(
                fontSize: 30,
              ),), 
              onPressed: () { 
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));;
               },),
               Spacer()],
        ),
      )
    ;
  }
}