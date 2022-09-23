import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kryfto/login_page.dart';
import 'package:kryfto/map_page.dart';
import 'game_page.dart';
import 'map_select_page.dart';
import 'home_page.dart';
import 'theme.dart';



class JoinPage extends StatelessWidget {
  const JoinPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      body: Join(title: 'join lobby',),),
      debugShowCheckedModeBanner: false,
      theme: theme(),
      
   
     
    );
  }
}

class Join extends StatefulWidget {
  const Join({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  
  final roomController = TextEditingController();
  
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back_ios),
        onPressed: (){ 
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const GamePage(),));

        
        }),
    
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColorLight,
      title: Text("Join Lobby",
      style:
     GoogleFonts.righteous(
    textStyle: TextStyle(
    fontSize: 35, 
    color: Theme.of(context).dialogBackgroundColor)))),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(child: Column(children: <Widget> [
        Spacer(flex: 2),
        Container(child: TextFormField(controller: roomController,
        autocorrect: false,
       
        decoration: const InputDecoration(
            
                  border: OutlineInputBorder(),
                  labelText: 'Enter Room Code',
                ),
                ),
                width: 300
                
        ),
        Spacer(flex: 3),
        ElevatedButton(
          child: Icon(Icons.arrow_forward_ios),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                minimumSize: const Size(130, 60),
                maximumSize: const Size(130, 60),
                primary: Theme.of(context).primaryColor,
              ),
              onPressed: (){

              },
              
        ),
        Spacer(),
      ],))
      ,
       
    );
  }
}
